import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class RideCompletedV2Screen extends StatefulWidget {
  const RideCompletedV2Screen({super.key});
  @override State<RideCompletedV2Screen> createState() => _RideCompletedV2ScreenState();
}
class _RideCompletedV2ScreenState extends State<RideCompletedV2Screen> {
  int rating = 5;
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Ride Completed')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      const Icon(Icons.check_circle, color: AppColors.primary, size: 90),
      const Center(child: Text('Ride Completed', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold))),
      const SizedBox(height: 20),
      const Card(child: ListTile(title: Text('Total Fare'), trailing: Text('₹48', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)))),
      const SizedBox(height: 12),
      const Center(child: Text('Rate Driver')),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) => IconButton(
        onPressed: () => setState(() => rating = i + 1),
        icon: Icon(Icons.star, color: i < rating ? Colors.amber : Colors.grey, size: 40),
      ))),
      ElevatedButton(onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false), child: const Text('View Details')),
      OutlinedButton(onPressed: () {}, child: const Text('Paid via UPI')),
    ]),
  );
}
