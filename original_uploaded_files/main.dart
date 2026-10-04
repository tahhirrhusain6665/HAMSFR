import 'package:flutter/material.dart';
import 'services/firebase_service.dart';
import 'services/auth_service.dart';
import 'utils/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/ride_tracking_screen.dart';
import 'screens/ride_completed_screen.dart';
import 'screens/driver_splash_screen.dart';
import 'screens/driver_login_screen.dart';
import 'screens/driver_dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(const HamsfrApp());
}

class HamsfrApp extends StatelessWidget {
  const HamsfrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HAMSFR',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/ride': (_) => const RideTrackingScreen(),
        '/completed': (_) => const RideCompletedScreen(),
        '/driver': (_) => const DriverSplashScreen(),
        '/driver-login': (_) => const DriverLoginScreen(),
        '/driver-dashboard': (_) => const DriverDashboardScreen(),
      },
    );
  }
}

final authService = AuthService();
