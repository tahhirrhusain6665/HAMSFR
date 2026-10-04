import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class FeatureCenterScreen extends StatelessWidget {
  const FeatureCenterScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Humsafar Services')),
    body: GridView.count(
      padding: const EdgeInsets.all(16), crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12,
      children: const [
        _F(Icons.people_alt, 'Trip Sharing'),
        _F(Icons.payments, 'Multiple Payments'),
        _F(Icons.calendar_month, 'Ride Scheduling'),
        _F(Icons.card_membership, 'Driver Subscription'),
        _F(Icons.redeem, 'Loyalty Rewards'),
        _F(Icons.group_add, 'Referral Program'),
        _F(Icons.support_agent, 'In-app Support'),
        _F(Icons.language, 'Multi-language'),
        _F(Icons.emergency, 'Emergency SOS'),
        _F(Icons.location_city, 'Local Places'),
      ],
    ),
  );
}
class _F extends StatelessWidget {
  final IconData icon; final String label;
  const _F(this.icon, this.label);
  @override Widget build(BuildContext context) => Card(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Icon(icon, size: 34, color: AppColors.primary), const SizedBox(height: 8), Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))
  ]));
}
