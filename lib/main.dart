import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/firebase_service.dart';
import 'services/auth_service.dart';
import 'services/ride_service.dart';
import 'services/driver_service.dart';
import 'services/location_service.dart';
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
import 'screens/humsafar_home_screen.dart';
import 'screens/vehicle_selection_screen.dart';
import 'screens/driver_found_screen.dart';
import 'screens/live_tracking_screen.dart';
import 'screens/ride_completed_v2_screen.dart';
import 'screens/schedule_ride_screen.dart';
import 'screens/wallet_screen.dart';
import 'screens/feature_center_screen.dart';
import 'screens/admin_dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(const HumsafarApp());
}

class HumsafarApp extends StatelessWidget {
  const HumsafarApp({super.key});
  @override Widget build(BuildContext context) => MultiProvider(
    providers: [
      Provider(create: (_) => AuthService()),
      Provider(create: (_) => RideService()),
      Provider(create: (_) => DriverService()),
      Provider(create: (_) => LocationService()),
    ],
    child: MaterialApp(
      title: 'Humsafar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/design-home',
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreen(),
        '/design-home': (_) => const HumsafarHomeScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/ride': (_) => const RideTrackingScreen(),
        '/completed': (_) => const RideCompletedScreen(),
        '/ride-completed': (_) => const RideCompletedV2Screen(),
        '/driver': (_) => const DriverSplashScreen(),
        '/driver-login': (_) => const DriverLoginScreen(),
        '/driver-dashboard': (_) => const DriverDashboardScreen(),
        '/vehicle-selection': (_) => const VehicleSelectionScreen(),
        '/driver-found': (_) => const DriverFoundScreen(),
        '/live-tracking': (_) => const LiveTrackingScreen(),
        '/schedule-ride': (_) => const ScheduleRideScreen(),
        '/wallet': (_) => const WalletScreen(),
        '/features': (_) => const FeatureCenterScreen(),
        '/admin': (_) => const AdminDashboardScreen(),
      },
    ),
  );
}
