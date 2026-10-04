import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  String? _verificationId;
  int? _resendToken;

  Future<void> sendOtp({
    required String phone,
    required void Function() codeSent,
    required void Function(String message) onError,
    void Function()? autoVerified,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        forceResendingToken: _resendToken,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);
            if (autoVerified != null) autoVerified();
          } catch (e) {
            onError('Automatic verification failed. Please enter the OTP.');
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Could not send OTP. Check the number and Firebase setup.');
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          codeSent();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      onError('Could not send OTP. Please try again.');
    }
  }

  Future<UserCredential?> verifyOtp(String otp) async {
    if (_verificationId == null) {
      throw FirebaseAuthException(code: 'missing-verification-id', message: 'Please request OTP again.');
    }
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );
    return _auth.signInWithCredential(credential);
  }

  Future<void> saveUserProfile({required User user, required String role}) async {
    await _db.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'phone': user.phoneNumber,
      'role': role,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> saveDriverProfile({required User user}) async {
    await _db.collection('drivers').doc(user.uid).set({
      'uid': user.uid,
      'phone': user.phoneNumber,
      'role': 'driver',
      'isOnline': false,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<User?> authStateChanges() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<void> signOut() => _auth.signOut();
}
