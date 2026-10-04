import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/ride_service.dart';

class RideTrackingScreen extends StatelessWidget {
  const RideTrackingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String?;
    if (id == null) return const Scaffold(body: Center(child: Text('Ride not found')));
    return Scaffold(
      appBar: AppBar(title: const Text('Your Humsafar')),
      body: StreamBuilder(
        stream: context.read<RideService>().watchRide(id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!.data() ?? {};
          final status = data['status'] ?? 'searching';
          final driver = data['driverName'];
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(children: [
              const Icon(Icons.local_taxi, size: 80),
              const SizedBox(height: 20),
              Text(_label(status), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (driver != null) Text('Driver: $driver'),
              const Spacer(),
              if (status == 'searching')
                OutlinedButton(onPressed: () => context.read<RideService>().cancelRide(id), child: const Text('Cancel Ride')),
              if (status == 'completed')
                ElevatedButton(onPressed: () => Navigator.pushReplacementNamed(context, '/completed', arguments: id), child: const Text('Rate Ride')),
            ]),
          );
        },
      ),
    );
  }
  String _label(String s) {
    switch (s) {
      case 'accepted': return 'Driver accepted your ride';
      case 'arriving': return 'Driver is arriving';
      case 'started': return 'Ride started';
      case 'completed': return 'Ride completed';
      case 'cancelled': return 'Ride cancelled';
      default: return 'Finding a Humsafar driver...';
    }
  }
}
