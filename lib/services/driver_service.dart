import 'package:cloud_firestore/cloud_firestore.dart';

class DriverStats {
  final double earnings;
  final int rides;
  final double rating;
  const DriverStats({this.earnings = 0, this.rides = 0, this.rating = 0});

  factory DriverStats.fromMap(Map<String, dynamic> data) => DriverStats(
    earnings: (data['todayEarnings'] as num?)?.toDouble() ?? 0,
    rides: (data['todayRides'] as num?)?.toInt() ?? 0,
    rating: (data['rating'] as num?)?.toDouble() ?? 0,
  );
}

class DriverService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<DriverStats> watchStats(String uid) =>
      _db.collection('drivers').doc(uid).snapshots().map(
        (s) => DriverStats.fromMap(s.data() ?? {}),
      );

  Stream<bool> watchOnline(String uid) =>
      _db.collection('drivers').doc(uid).snapshots().map(
        (s) => (s.data()?['isOnline'] as bool?) ?? false,
      );

  Future<void> setOnline(String uid, bool value) =>
      _db.collection('drivers').doc(uid).set({
        'isOnline': value,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
}
