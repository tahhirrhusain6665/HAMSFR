import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/feature_data.dart';

class HumsafarHomeScreen extends StatefulWidget {
  const HumsafarHomeScreen({super.key});
  @override State<HumsafarHomeScreen> createState() => _HumsafarHomeScreenState();
}
class _HumsafarHomeScreenState extends State<HumsafarHomeScreen> {
  int tab = 0;
  String pickup = 'Current Location';
  String destination = '';
  String vehicle = 'Bike';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Stack(children: [
        Column(children: [
          _header(),
          Expanded(child: _mapArea()),
        ]),
        Positioned(left: 14, right: 14, bottom: 14, child: _bookingCard()),
      ])),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (v) => setState(() => tab = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Bookings'),
          NavigationDestination(icon: Icon(Icons.wallet_outlined), label: 'Wallet'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _header() => Container(
    padding: const EdgeInsets.fromLTRB(18, 12, 12, 12),
    color: AppColors.primaryDark,
    child: Row(children: [
      Container(width: 42, height: 42,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: const Center(child: Text('H', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.primary)))),
      const SizedBox(width: 10),
      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('HUMSFR', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
        Text('Your City. Your Companion.', style: TextStyle(color: Colors.white70, fontSize: 11)),
      ])),
      IconButton(onPressed: () => Navigator.pushNamed(context, '/profile'), icon: const Icon(Icons.person, color: Colors.white)),
    ]),
  );

  Widget _mapArea() => Container(
    color: const Color(0xffdfe9dd),
    child: Stack(children: [
      Center(child: Icon(Icons.map, size: 120, color: Colors.green.shade200)),
      Positioned(left: 38, top: 80, child: _pin(Icons.location_on, 'Pickup')),
      Positioned(right: 48, top: 210, child: _pin(Icons.location_on, 'Destination')),
      Positioned(right: 18, top: 18, child: FloatingActionButton.small(
        onPressed: () {}, child: const Icon(Icons.my_location))),
    ]),
  );

  Widget _pin(IconData icon, String label) => Column(children: [
    Icon(icon, color: AppColors.primary, size: 38),
    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
  ]);

  Widget _bookingCard() => Card(
    elevation: 8,
    child: Padding(padding: const EdgeInsets.all(14), child: Column(children: [
      TextField(
        decoration: const InputDecoration(prefixIcon: Icon(Icons.my_location), hintText: 'Pickup location'),
        controller: TextEditingController(text: pickup),
        onChanged: (v) => pickup = v,
      ),
      const SizedBox(height: 8),
      TextField(
        decoration: const InputDecoration(prefixIcon: Icon(Icons.location_on), hintText: 'Where to?'),
        onChanged: (v) => destination = v,
      ),
      const SizedBox(height: 10),
      SizedBox(height: 86, child: ListView(
        scrollDirection: Axis.horizontal,
        children: vehicles.map((v) => GestureDetector(
          onTap: () => setState(() => vehicle = v.name),
          child: Container(
            width: 112, margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: vehicle == v.name ? const Color(0xffe7f7ed) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: vehicle == v.name ? AppColors.primary : AppColors.lightGrey, width: 1.5),
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(v.icon, style: const TextStyle(fontSize: 25)),
              Text(v.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('from ₹${v.baseFare}', style: const TextStyle(fontSize: 10)),
            ]),
          ),
        )).toList(),
      )),
      const SizedBox(height: 8),
      SizedBox(width: double.infinity, child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, '/vehicle-selection'),
        child: const Text('Confirm Location & Choose Ride'),
      )),
      const SizedBox(height: 4),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: whyHumsafar.map((x) =>
        Column(children: [Text(x.$1, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)), Text(x.$2, style: const TextStyle(fontSize: 9))])
      ).toList()),
    ])),
  );
}
