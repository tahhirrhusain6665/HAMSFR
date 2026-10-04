import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/feature_data.dart';

class VehicleSelectionScreen extends StatefulWidget {
  const VehicleSelectionScreen({super.key});
  @override State<VehicleSelectionScreen> createState() => _VehicleSelectionScreenState();
}
class _VehicleSelectionScreenState extends State<VehicleSelectionScreen> {
  int selected = 0;
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Choose Your Ride')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      const Text('Pickup', style: TextStyle(color: AppColors.grey)),
      const Text('Ratan Bada, Bikaner', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text('Destination', style: TextStyle(color: AppColors.grey)),
      const Text('Junagarh Fort, Bikaner', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
      ...List.generate(vehicles.length, (i) {
        final v = vehicles[i];
        return Card(
          child: ListTile(
            leading: Text(v.icon, style: const TextStyle(fontSize: 32)),
            title: Text(v.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${v.subtitle} • ${i == 0 ? '2 min' : i == 1 ? '4 min' : '6 min'}'),
            trailing: Text('₹${v.baseFare}', style: const TextStyle(fontWeight: FontWeight.bold)),
            selected: selected == i,
            onTap: () => setState(() => selected = i),
          ),
        );
      }),
      const SizedBox(height: 10),
      const Card(child: Padding(padding: EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Why HUMSAFR?', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('✓ Verified Drivers\\n✓ Live Tracking\\n✓ Transparent Fare\\n✓ 24/7 Support'),
      ]))),
      const SizedBox(height: 12),
      ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, '/driver-found'),
        child: const Text('Book Ride'),
      ),
      OutlinedButton(onPressed: () => Navigator.pushNamed(context, '/schedule-ride'), child: const Text('Schedule for later')),
    ]),
  );
}
