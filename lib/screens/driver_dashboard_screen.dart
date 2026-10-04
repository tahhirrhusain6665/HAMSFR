import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/driver_service.dart';
import '../services/ride_service.dart';

class DriverDashboardScreen extends StatelessWidget {
  const DriverDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthService>().currentUser?.uid;
    if (uid == null) return const Scaffold(body: Center(child: Text('Driver login required')));
    return Scaffold(
      appBar: AppBar(title: const Text('Humsafar Driver')),
      body: StreamBuilder<DriverStats>(
        stream: context.read<DriverService>().watchStats(uid),
        builder: (context, stats) {
          final s = stats.data ?? const DriverStats();
          return ListView(padding: const EdgeInsets.all(20), children: [
            Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
              const Text("Today's Earnings"),
              Text('₹${s.earnings.toStringAsFixed(0)}', style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text('${s.rides}\nRides', textAlign: TextAlign.center),
                Text(s.rating.toStringAsFixed(1) + '\nRating', textAlign: TextAlign.center),
              ]),
            ]))),
            const SizedBox(height: 16),
            StreamBuilder<bool>(
              stream: context.read<DriverService>().watchOnline(uid),
              builder: (context, snap) {
                final online = snap.data ?? false;
                return SwitchListTile(
                  title: Text(online ? 'Online - Requests receive होंगे' : 'Offline'),
                  value: online,
                  onChanged: (v) => context.read<DriverService>().setOnline(uid, v),
                );
              },
            ),
            const SizedBox(height: 16),
            const Text('Open Ride Requests', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            StreamBuilder(
              stream: context.read<RideService>().watchOpenRides(),
              builder: (context, snap) {
                if (!snap.hasData) return const CircularProgressIndicator();
                final docs = snap.data!.docs;
                if (docs.isEmpty) return const Card(child: Padding(padding: EdgeInsets.all(20), child: Text('अभी कोई ride request नहीं है.')));
                return Column(children: docs.map((d) {
                  final x = d.data();
                  return Card(child: ListTile(
                    title: Text('${x['pickup'] ?? ''} → ${x['destination'] ?? ''}'),
                    subtitle: Text('₹${x['estimatedFare'] ?? 0} • ${x['vehicleType'] ?? ''}'),
                    trailing: ElevatedButton(onPressed: () => context.read<RideService>().acceptRide(d.id, uid), child: const Text('Accept')),
                  ));
                }).toList());
              },
            ),
          ]);
        },
      ),
    );
  }
}
