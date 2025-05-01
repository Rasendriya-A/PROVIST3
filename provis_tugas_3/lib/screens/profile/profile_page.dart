import 'package:flutter/material.dart';
import 'package:provis_tugas_3/screens/auth/login_page.dart';  // Import halaman login
import 'package:provis_tugas_3/screens/auth/register_page.dart';  // Import halaman register
import 'package:provis_tugas_3/screens/auth/forget_pass_page.dart';  // Import halaman forget password

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text('Register'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ForgetPassPage()),
                );
              },
              child: const Text('Forget Password'),
            ),
          ],
        ),
      ),
    );
  }
}
