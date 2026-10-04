import { onCall, HttpsError } from "firebase-functions/v2/https";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { setGlobalOptions } from "firebase-functions/v2";
import { initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { getMessaging } from "firebase-admin/messaging";
import { distanceBetween, geohashForLocation } from "geofire-common";

initializeApp();
setGlobalOptions({ region: "asia-south1", maxInstances: 20 });

const db = getFirestore();

async function requireAuth(request: any) {
  if (!request.auth?.uid) throw new HttpsError("unauthenticated", "Login required.");
  return request.auth.uid as string;
}

function assertRole(request: any, roles: string[]) {
  const role = request.auth?.token?.role as string | undefined;
  if (!role || !roles.includes(role)) {
    throw new HttpsError("permission-denied", "This action is not allowed for this role.");
  }
}

export const setUserRole = onCall(async (request) => {
  const uid = await requireAuth(request);
  assertRole(request, ["admin"]);
  const targetUid = String(request.data?.uid || "");
  const role = String(request.data?.role || "");
  if (!targetUid || !["rider", "driver", "admin"].includes(role)) {
    throw new HttpsError("invalid-argument", "Invalid uid or role.");
  }
  await getAuth().setCustomUserClaims(targetUid, { role });
  await db.collection("users").doc(targetUid).set({ role }, { merge: true });
  return { ok: true };
});

export const setDriverOnline = onCall(async (request) => {
  const uid = await requireAuth(request);
  assertRole(request, ["driver"]);
  const online = Boolean(request.data?.online);
  await db.collection("drivers").doc(uid).set({
    uid, isOnline: online, updatedAt: FieldValue.serverTimestamp()
  }, { merge: true });
  return { ok: true };
});

export const updateDriverLocation = onCall(async (request) => {
  const uid = await requireAuth(request);
  assertRole(request, ["driver"]);
  const lat = Number(request.data?.lat);
  const lng = Number(request.data?.lng);
  if (!Number.isFinite(lat) || !Number.isFinite(lng)) {
    throw new HttpsError("invalid-argument", "Invalid coordinates.");
  }
  await db.collection("drivers").doc(uid).set({
    lat, lng, geohash: geohashForLocation([lat, lng]),
    locationUpdatedAt: FieldValue.serverTimestamp()
  }, { merge: true });
  return { ok: true };
});

export const createRide = onCall(async (request) => {
  const uid = await requireAuth(request);
  assertRole(request, ["rider"]);
  const d = request.data || {};
  const lat = Number(d.pickupLat), lng = Number(d.pickupLng);
  if (!Number.isFinite(lat) || !Number.isFinite(lng) || !d.destination) {
    throw new HttpsError("invalid-argument", "Pickup and destination are required.");
  }
  const ref = await db.collection("rides").add({
    riderId: uid,
    pickup: String(d.pickup || "Current location"),
    destination: String(d.destination),
    pickupLat: lat, pickupLng: lng,
    destinationLat: Number(d.destinationLat || lat),
    destinationLng: Number(d.destinationLng || lng),
    vehicleType: String(d.vehicleType || "Mini"),
    estimatedFare: Number(d.estimatedFare || 0),
    status: "searching",
    driverId: null,
    createdAt: FieldValue.serverTimestamp()
  });
  return { rideId: ref.id };
});

export const findNearbyDrivers = onCall(async (request) => {
  await requireAuth(request);
  const lat = Number(request.data?.lat);
  const lng = Number(request.data?.lng);
  const radiusKm = Math.min(Number(request.data?.radiusKm || 5), 20);
  if (!Number.isFinite(lat) || !Number.isFinite(lng)) {
    throw new HttpsError("invalid-argument", "Invalid coordinates.");
  }

  // Prototype implementation. For high scale, use a geo-index/query service.
  const snap = await db.collection("drivers").where("isOnline", "==", true).limit(200).get();
  const result: any[] = [];
  for (const doc of snap.docs) {
    const x = doc.data();
    if (typeof x.lat !== "number" || typeof x.lng !== "number") continue;
    const km = distanceBetween([lat, lng], [x.lat, x.lng]);
    if (km <= radiusKm) result.push({ uid: doc.id, distanceKm: km, ...x });
  }
  result.sort((a, b) => a.distanceKm - b.distanceKm);
  return { drivers: result.slice(0, 20) };
});

export const acceptRide = onCall(async (request) => {
  const driverId = await requireAuth(request);
  assertRole(request, ["driver"]);
  const rideId = String(request.data?.rideId || "");
  if (!rideId) throw new HttpsError("invalid-argument", "rideId required.");

  const ref = db.collection("rides").doc(rideId);
  await db.runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    if (!snap.exists) throw new HttpsError("not-found", "Ride not found.");
    const ride = snap.data()!;
    if (ride.status !== "searching" || ride.driverId) {
      throw new HttpsError("failed-precondition", "Ride is no longer available.");
    }
    tx.update(ref, {
      driverId,
      status: "accepted",
      acceptedAt: FieldValue.serverTimestamp()
    });
  });
  return { ok: true };
});

export const updateRideStatus = onCall(async (request) => {
  const uid = await requireAuth(request);
  const rideId = String(request.data?.rideId || "");
  const status = String(request.data?.status || "");
  const allowed = ["arriving", "started", "completed", "cancelled"];
  if (!allowed.includes(status)) throw new HttpsError("invalid-argument", "Invalid status.");
  const ref = db.collection("rides").doc(rideId);
  const snap = await ref.get();
  if (!snap.exists) throw new HttpsError("not-found", "Ride not found.");
  const ride = snap.data()!;
  if (ride.riderId !== uid && ride.driverId !== uid) {
    throw new HttpsError("permission-denied", "Not your ride.");
  }
  await ref.update({ status, updatedAt: FieldValue.serverTimestamp() });
  return { ok: true };
});

export const rideCreatedNotification = onDocumentCreated("rides/{rideId}", async (event) => {
  const ride = event.data?.data();
  if (!ride) return;
  const snap = await db.collection("drivers").where("isOnline", "==", true).limit(200).get();
  const tokens: string[] = [];
  snap.forEach(d => {
    const token = d.data().fcmToken;
    if (typeof token === "string" && token) tokens.push(token);
  });
  if (tokens.length) {
    await getMessaging().sendEachForMulticast({
      tokens: tokens.slice(0, 500),
      notification: { title: "New Humsafar Ride", body: `${ride.pickup} → ${ride.destination}` },
      data: { rideId: event.params.rideId, type: "new_ride" }
    });
  }
});
