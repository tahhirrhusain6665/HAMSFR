import 'package:flutter/material.dart';

class DriverSplashScreen extends StatefulWidget {
  const DriverSplashScreen({super.key});
  @override State<DriverSplashScreen> createState() => _DriverSplashScreenState();
}
class _DriverSplashScreenState extends State<DriverSplashScreen> {
  @override void initState() { super.initState(); Future.delayed(const Duration(seconds: 1), () {
    if (mounted) Navigator.pushReplacementNamed(context, '/driver-login');
  });}
  @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Humsafar Driver', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))));
}
