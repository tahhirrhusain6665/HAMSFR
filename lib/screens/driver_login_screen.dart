import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class DriverLoginScreen extends StatefulWidget {
  const DriverLoginScreen({super.key});
  @override State<DriverLoginScreen> createState() => _DriverLoginScreenState();
}
class _DriverLoginScreenState extends State<DriverLoginScreen> {
  final phone = TextEditingController();
  final otp = TextEditingController();
  bool sent = false, loading = false;

  void send() {
    final value = phone.text.trim();
    if (value.length != 10) return;
    setState(() => loading = true);
    context.read<AuthService>().sendOtp(
      phone: '+91$value',
      codeSent: () => setState(() { sent = true; loading = false; }),
      onError: (m) { setState(() => loading = false); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m))); },
    );
  }

  Future<void> verify() async {
    setState(() => loading = true);
    try {
      final c = await context.read<AuthService>().verifyOtp(otp.text.trim());
      if (c.user != null) {
        await context.read<AuthService>().saveUser(user: c.user!, role: 'driver');
        if (mounted) Navigator.pushReplacementNamed(context, '/driver-dashboard');
      }
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP verification failed.')));
    } finally { if (mounted) setState(() => loading = false); }
  }

  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Driver Login')),
    body: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
      const SizedBox(height: 30),
      TextField(controller: phone, keyboardType: TextInputType.phone, maxLength: 10, decoration: const InputDecoration(labelText: 'Mobile Number', prefixText: '+91 ')),
      if (sent) TextField(controller: otp, keyboardType: TextInputType.number, maxLength: 6, decoration: const InputDecoration(labelText: 'OTP')),
      const SizedBox(height: 20),
      SizedBox(width: double.infinity, child: ElevatedButton(
        onPressed: loading ? null : (sent ? verify : send),
        child: Text(sent ? 'Verify & Continue' : 'Get OTP'),
      )),
    ])),
  );
}
