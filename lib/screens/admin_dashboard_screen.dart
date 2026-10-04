import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('HUMSAFR Admin')),
    drawer: const Drawer(child: SafeArea(child: ListView(children: [
      DrawerHeader(child: Text('HUMSAFR\\nAdmin Panel', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
      ListTile(leading: Icon(Icons.dashboard), title: Text('Dashboard')),
      ListTile(leading: Icon(Icons.directions_car), title: Text('Drivers')),
      ListTile(leading: Icon(Icons.people), title: Text('Customers')),
      ListTile(leading: Icon(Icons.receipt_long), title: Text('Rides')),
      ListTile(leading: Icon(Icons.payments), title: Text('Payments')),
      ListTile(leading: Icon(Icons.report), title: Text('Reports')),
      ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
    ])),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      const Text('Dashboard', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, children: const [
        _Metric('Total Rides', '12,408'),
        _Metric('Total Drivers', '342'),
        _Metric('Total Customers', '43,320'),
        _Metric('Today Orders', '2,156'),
      ]),
      const SizedBox(height: 16),
      const Card(child: SizedBox(height: 220, child: Center(child: Icon(Icons.show_chart, size: 110, color: AppColors.primary)))),
      const SizedBox(height: 16),
      const Text('Recent Rides', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ...['Rohit Sharma  • ₹48', 'Suresh Kumar • ₹72', 'Amit Yadav • ₹62'].map((x) => Card(child: ListTile(title: Text(x), trailing: const Text('Completed')))),
    ]),
  );
}
class _Metric extends StatelessWidget {
  final String a,b; const _Metric(this.a,this.b);
  @override Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
    Text(a, style: const TextStyle(color: AppColors.grey)), Text(b, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
  ])));
}
