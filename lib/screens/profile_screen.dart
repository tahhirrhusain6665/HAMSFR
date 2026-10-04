import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthService>().currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        const CircleAvatar(radius: 42, child: Icon(Icons.person, size: 42)),
        const SizedBox(height: 16),
        Center(child: Text(user?.phoneNumber ?? 'Humsafar Rider', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        const SizedBox(height: 24),
        ListTile(leading: const Icon(Icons.history), title: const Text('Ride History'), onTap: () {}),
        ListTile(leading: const Icon(Icons.help), title: const Text('Help & Support'), onTap: () {}),
        ListTile(leading: const Icon(Icons.logout), title: const Text('Logout'), onTap: () async {
          await context.read<AuthService>().signOut();
          if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
        }),
      ]),
    );
  }
}
