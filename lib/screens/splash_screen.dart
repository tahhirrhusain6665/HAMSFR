import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
    });
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
        ),
      ),
      child: const Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          CircleAvatar(radius: 52, backgroundColor: Colors.white,
            child: Text('H', style: TextStyle(fontSize: 58, fontWeight: FontWeight.bold, color: AppColors.primary))),
          SizedBox(height: 20),
          Text('HUMSAFAR', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 2)),
          SizedBox(height: 8),
          Text('Your City. Your Companion.', style: TextStyle(color: Colors.white70)),
        ]),
      ),
    ),
  );
}
