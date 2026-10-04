import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Wallet & Payments')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Card(color: AppColors.primary, child: const Padding(padding: EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Total Balance', style: TextStyle(color: Colors.white70)),
        Text('₹250', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
      ]))),
      ListTile(leading: const Icon(Icons.account_balance_wallet), title: const Text('UPI Payments'), onTap: () {}),
      ListTile(leading: const Icon(Icons.receipt_long), title: const Text('Payment History'), onTap: () {}),
      ListTile(leading: const Icon(Icons.card_giftcard), title: const Text('Offers & Coupons'), onTap: () {}),
      ListTile(leading: const Icon(Icons.redeem), title: const Text('Loyalty Rewards'), onTap: () {}),
      ListTile(leading: const Icon(Icons.group_add), title: const Text('Referral Program'), onTap: () {}),
    ]),
  );
}
