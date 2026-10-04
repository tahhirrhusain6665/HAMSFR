import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? _verificationId;
  int? _resendToken;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> sendOtp({
    required String phone,
    required void Function() codeSent,
    required void Function(String) onError,
    void Function()? autoVerified,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        forceResendingToken: _resendToken,
        verificationCompleted: (credential) async {
          try {
            await _auth.signInWithCredential(credential);
            autoVerified?.call();
          } catch (e) {
            onError('Automatic verification failed. Enter the OTP.');
          }
        },
        verificationFailed: (e) => onError(e.message ?? 'OTP could not be sent.'),
        codeSent: (id, token) {
          _verificationId = id;
          _resendToken = token;
          codeSent();
        },
        codeAutoRetrievalTimeout: (id) => _verificationId = id,
      );
    } catch (_) {
      onError('Could not send OTP. Check Firebase configuration and phone number.');
    }
  }

  Future<UserCredential> verifyOtp(String otp) async {
    final id = _verificationId;
    if (id == null) {
      throw FirebaseAuthException(
        code: 'missing-verification-id',
        message: 'Request OTP again.',
      );
    }
    return _auth.signInWithCredential(
      PhoneAuthProvider.credential(verificationId: id, smsCode: otp),
    );
  }

  Future<void> saveUser({required User user, required String role}) async {
    await _db.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'phone': user.phoneNumber,
      'role': role,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (role == 'driver') {
      await _db.collection('drivers').doc(user.uid).set({
        'uid': user.uid,
        'phone': user.phoneNumber,
        'isOnline': false,
        'rating': 5.0,
        'todayEarnings': 0,
        'todayRides': 0,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  Future<void> signOut() => _auth.signOut();
}
