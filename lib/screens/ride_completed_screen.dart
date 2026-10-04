import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/ride_service.dart';

class RideCompletedScreen extends StatefulWidget {
  const RideCompletedScreen({super.key});
  @override State<RideCompletedScreen> createState() => _RideCompletedScreenState();
}
class _RideCompletedScreenState extends State<RideCompletedScreen> {
  int rating = 5;
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String?;
    return Scaffold(
      appBar: AppBar(title: const Text('Ride Complete')),
      body: Center(child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.check_circle, size: 90, color: Colors.green),
          const SizedBox(height: 20),
          const Text('How was your ride?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) =>
            IconButton(onPressed: () => setState(() => rating = i + 1),
              icon: Icon(Icons.star, color: i < rating ? Colors.amber : Colors.grey, size: 38)))),
          ElevatedButton(onPressed: () async {
            if (id != null) await context.read<RideService>().rateRide(id, rating);
            if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
          }, child: const Text('Done')),
        ]),
      )),
    );
  }
}
