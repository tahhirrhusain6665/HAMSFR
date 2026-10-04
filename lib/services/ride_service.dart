import 'package:cloud_firestore/cloud_firestore.dart';

class RideService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> createRide({
    required String riderId,
    required String pickup,
    required String destination,
    required double pickupLat,
    required double pickupLng,
    required double destinationLat,
    required double destinationLng,
    required double estimatedFare,
    required String vehicleType,
  }) async {
    final ref = await _db.collection('rides').add({
      'riderId': riderId,
      'pickup': pickup,
      'destination': destination,
      'pickupLat': pickupLat,
      'pickupLng': pickupLng,
      'destinationLat': destinationLat,
      'destinationLng': destinationLng,
      'estimatedFare': estimatedFare,
      'vehicleType': vehicleType,
      'status': 'searching',
      'driverId': null,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchRide(String id) =>
      _db.collection('rides').doc(id).snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> watchOpenRides() =>
      _db.collection('rides')
          .where('status', isEqualTo: 'searching')
          .orderBy('createdAt', descending: true)
          .snapshots();

  Future<void> acceptRide(String rideId, String driverId) =>
      _db.collection('rides').doc(rideId).update({
        'driverId': driverId,
        'status': 'accepted',
        'acceptedAt': FieldValue.serverTimestamp(),
      });

  Future<void> updateStatus(String rideId, String status) =>
      _db.collection('rides').doc(rideId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });

  Future<void> cancelRide(String rideId) =>
      updateStatus(rideId, 'cancelled');

  Future<void> rateRide(String rideId, int rating) =>
      _db.collection('rides').doc(rideId).update({'riderRating': rating});
}
