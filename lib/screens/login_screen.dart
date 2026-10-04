import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../utils/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final phone = TextEditingController();
  final otp = TextEditingController();
  bool sent = false, loading = false;

  Future<void> send() async {
    final value = phone.text.trim();
    if (value.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('10 digit mobile number डालें')));
      return;
    }
    setState(() => loading = true);
    await context.read<AuthService>().sendOtp(
      phone: '+91$value',
      codeSent: () => setState(() { sent = true; loading = false; }),
      onError: (m) { setState(() => loading = false); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m))); },
    );
  }

  Future<void> verify() async {
    setState(() => loading = true);
    try {
      final cred = await context.read<AuthService>().verifyOtp(otp.text.trim());
      if (cred.user != null) {
        await context.read<AuthService>().saveUser(user: cred.user!, role: 'rider');
        if (mounted) Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP गलत है या Firebase सेटअप बाकी है.')));
    } finally { if (mounted) setState(() => loading = false); }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Humsafar')),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 30),
        const Text('Ride शुरू करें', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('अपने मोबाइल नंबर से सुरक्षित लॉगिन करें'),
        const SizedBox(height: 30),
        if (!sent) ...[
          TextField(controller: phone, keyboardType: TextInputType.phone, maxLength: 10,
            decoration: const InputDecoration(labelText: 'Mobile Number', prefixText: '+91 ')),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: loading ? null : send,
            child: Text(loading ? 'Sending...' : 'Get OTP'),
          )),
        ] else ...[
          TextField(controller: otp, keyboardType: TextInputType.number, maxLength: 6,
            textAlign: TextAlign.center, decoration: const InputDecoration(labelText: '6 digit OTP')),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: loading ? null : verify,
            child: Text(loading ? 'Verifying...' : 'Verify & Continue'),
          )),
        ],
        const Spacer(),
        Center(child: TextButton(
          onPressed: () => Navigator.pushNamed(context, '/driver-login'),
          child: const Text('Driver Login'),
        )),
      ]),
    ),
  );
}
