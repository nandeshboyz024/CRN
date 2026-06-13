import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameCtrl  = TextEditingController(text: 'Rahul Sharma');
  final _phoneCtrl = TextEditingController(text: '+91 98765 43210');
  bool _loading = false;

  Future<void> _login() async {
    if (_nameCtrl.text.trim().isEmpty) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 36),
              // Logo
              Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.motorcycle, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 12),
                  const Text('CRN', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2)),
                ],
              ),
              const SizedBox(height: 52),
              const Text(
                'Welcome Back,\nRider!',
                style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, height: 1.2),
              ),
              const SizedBox(height: 10),
              const Text('Sign in to join your ride group',
                  style: TextStyle(color: Colors.white54, fontSize: 16)),
              const SizedBox(height: 48),
              _InputField(label: 'Full Name',     controller: _nameCtrl,  icon: Icons.person_outline),
              const SizedBox(height: 16),
              _InputField(label: 'Phone Number',  controller: _phoneCtrl, icon: Icons.phone_outlined,
                          inputType: TextInputType.phone),
              const SizedBox(height: 12),
              // Quick-select dummy user
              const Text('  Quick select:', style: TextStyle(color: Colors.white38, fontSize: 12)),
              const SizedBox(height: 8),
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: DummyData.users.length,
                  separatorBuilder: (ctx, i) => const SizedBox(width: 8),
                  itemBuilder: (ctx, i) {
                    final u = DummyData.users[i];
                    return GestureDetector(
                      onTap: () {
                        _nameCtrl.text  = u.name;
                        _phoneCtrl.text = u.phone;
                        DummyData.currentUser = u;
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Color(u.avatarColorValue).withAlpha(40),
                          border: Border.all(color: Color(u.avatarColorValue).withAlpha(120)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(u.name.split(' ')[0],
                            style: TextStyle(color: Color(u.avatarColorValue), fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _loading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFE53935).withAlpha(120),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: _loading
                      ? const SizedBox(width: 22, height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                      : const Text('Get Started', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ),
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text('Demo app — no real authentication',
                    style: TextStyle(color: Colors.white24, fontSize: 11)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({required this.label, required this.controller, required this.icon, this.inputType});
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? inputType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white38, size: 22),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.5),
        ),
      ),
    );
  }
}
