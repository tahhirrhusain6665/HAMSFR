import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../services/location_service.dart';
import '../services/ride_service.dart';
import '../services/auth_service.dart';
import '../utils/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? map;
  LatLng center = const LatLng(28.0229, 73.3119); // Bikaner fallback
  final pickup = TextEditingController();
  final destination = TextEditingController();
  String vehicle = 'Mini';
  bool locating = false;

  Future<void> locate() async {
    setState(() => locating = true);
    try {
      final p = await context.read<LocationService>().currentPosition();
      setState(() => center = LatLng(p.latitude, p.longitude));
      await map?.animateCamera(CameraUpdate.newLatLngZoom(center, 15));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally { if (mounted) setState(() => locating = false); }
  }

  Future<void> book() async {
    if (destination.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Destination डालें')));
      return;
    }
    final user = context.read<AuthService>().currentUser;
    if (user == null) return;
    final id = await context.read<RideService>().createRide(
      riderId: user.uid,
      pickup: pickup.text.trim().isEmpty ? 'Current location' : pickup.text.trim(),
      destination: destination.text.trim(),
      pickupLat: center.latitude, pickupLng: center.longitude,
      destinationLat: center.latitude, destinationLng: center.longitude,
      estimatedFare: vehicle == 'Bike' ? 70 : vehicle == 'Auto' ? 110 : 160,
      vehicleType: vehicle,
    );
    if (mounted) Navigator.pushNamed(context, '/ride', arguments: id);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Humsafar'), actions: [
      IconButton(onPressed: () => Navigator.pushNamed(context, '/profile'), icon: const Icon(Icons.person))
    ]),
    body: Stack(children: [
      GoogleMap(
        initialCameraPosition: CameraPosition(target: center, zoom: 13),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        onMapCreated: (c) => map = c,
      ),
      Positioned(
        left: 16, right: 16, bottom: 16,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              TextField(controller: pickup, decoration: const InputDecoration(prefixIcon: Icon(Icons.my_location), hintText: 'Pickup')),
              const SizedBox(height: 10),
              TextField(controller: destination, decoration: const InputDecoration(prefixIcon: Icon(Icons.location_on), hintText: 'Where to?')),
              const SizedBox(height: 10),
              Row(children: [
                for (final v in ['Bike','Auto','Mini']) Expanded(
                  child: ChoiceChip(label: Text(v), selected: vehicle == v, onSelected: (_) => setState(() => vehicle = v)),
                ),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                IconButton(onPressed: locating ? null : locate, icon: const Icon(Icons.gps_fixed)),
                Expanded(child: ElevatedButton(onPressed: book, child: const Text('Book Humsafar'))),
              ]),
            ]),
          ),
        ),
      ),
    ]),
  );
}
