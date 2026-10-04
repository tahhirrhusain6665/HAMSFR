import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('On the Way')),
    body: Column(children: [
      Expanded(child: Container(color: const Color(0xffdfe9dd), child: const Center(child: Icon(Icons.alt_route, size: 120, color: AppColors.primary)))),
      Container(padding: const EdgeInsets.all(16), child: Column(children: [
        Row(children: [
          const CircleAvatar(child: Icon(Icons.person)),
          const SizedBox(width: 12),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Rohit Sharma', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('★ 4.8 • RJ07 XX 1234'),
          ])),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.sos, color: Colors.red)),
        ]),
        const SizedBox(height: 8),
        const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('3 min'), Text('1.2 km')]),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/ride-completed'), child: const Text('Demo: Complete Ride')),
      ])),
    ]),
  );
}
