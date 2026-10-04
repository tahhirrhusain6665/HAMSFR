import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class FirebaseService {
  static bool isConfigured = false;

  static Future<void> initialize() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      }
      isConfigured = true;
    } catch (_) {
      // The app remains launchable until the developer adds Firebase config.
      // Live OTP/Firestore require a configured Firebase Android project.
      isConfigured = false;
    }
  }
}
