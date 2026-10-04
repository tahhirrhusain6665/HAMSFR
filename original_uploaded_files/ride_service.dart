import 'package:cloud_firestore/cloud_firestore.dart';

class RideService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> createRide({
    required String riderId,
    required String pickup,
    required String destination,
    required double estimatedFare,
  }) async {
    final ref = await _db.collection('rides').add({
      'riderId': riderId,
      'pickup': pickup,
      'destination': destination,
      'estimatedFare': estimatedFare,
      'status': 'searching',
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchRide(String rideId) =>
      _db.collection('rides').where(FieldPath.documentId, isEqualTo: rideId).snapshots();

  Future<void> cancelRide(String rideId) =>
      _db.collection('rides').doc(rideId).update({'status': 'cancelled'});

  Future<void> rateRide(String rideId, int rating) =>
      _db.collection('rides').doc(rideId).update({'riderRating': rating});
}
