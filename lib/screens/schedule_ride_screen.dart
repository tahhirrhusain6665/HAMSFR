import 'package:flutter/material.dart';

class ScheduleRideScreen extends StatelessWidget {
  const ScheduleRideScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Schedule Ride')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Plan your ride in advance', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
      ListTile(leading: const Icon(Icons.calendar_month), title: const Text('Date'), subtitle: const Text('Choose date'), onTap: () {}),
      ListTile(leading: const Icon(Icons.access_time), title: const Text('Time'), subtitle: const Text('Choose time'), onTap: () {}),
      ListTile(leading: const Icon(Icons.people), title: const Text('Passengers'), subtitle: const Text('1 passenger'), onTap: () {}),
      const SizedBox(height: 20),
      ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Schedule Ride')),
    ]),
  );
}
