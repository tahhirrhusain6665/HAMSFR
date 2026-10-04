import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class DriverFoundScreen extends StatelessWidget {
  const DriverFoundScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Driver Found')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      const Card(child: Padding(padding: EdgeInsets.all(18), child: Column(children: [
        CircleAvatar(radius: 34, child: Icon(Icons.person, size: 36)),
        SizedBox(height: 10),
        Text('Rohit Sharma', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
        Text('★ 4.8 • Maruti Suzuki WagonR'),
        Text('RJ07 XX 1234'),
      ]))),
      const SizedBox(height: 12),
      SizedBox(height: 230, child: Container(
        decoration: BoxDecoration(color: const Color(0xffdfe9dd), borderRadius: BorderRadius.circular(16)),
        child: const Center(child: Icon(Icons.route, size: 100, color: AppColors.primary)),
      )),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.call), label: const Text('Call'))),
        const SizedBox(width: 10),
        Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.message), label: const Text('Message'))),
      ]),
      const SizedBox(height: 10),
      ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/live-tracking'), child: const Text('Share Ride & Track Driver')),
    ]),
  );
}
