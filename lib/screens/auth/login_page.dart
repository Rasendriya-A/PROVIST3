import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provis_tugas_3/utils/app_colors.dart';
import 'package:provis_tugas_3/utils/app_text_styles.dart';
import 'package:provis_tugas_3/screens/auth/auth_service.dart'; // Impor AuthService
// Impor UserModel

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk email dan password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Fungsi untuk menangani login
  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      // Menampilkan pesan jika ada field yang kosong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan password tidak boleh kosong")),
      );
      return;
    }

    // Instance dari AuthService
    // Menunggu proses login dan memeriksa hasilnya
    final AuthService authService = AuthService();
    User? user = await authService.login(email, password);

    if (user != null) {
      // Jika login berhasil
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login Berhasil!")));
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Jika login gagal
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email atau password salah.")),
      );
    }

    // if (user != null) {
    //   // Jika login berhasil, navigasi ke halaman Home
    //   Navigator.pushReplacementNamed(
    //     context,
    //     '/home',
    //   ); // Ganti '/home' dengan route yang sesuai
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(const SnackBar(content: Text("Login Berhasil!")));
    // } else {
    //   // Jika login gagal
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("Email atau password salah")),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            children: [
              const SizedBox(height: 32),

              // Judul Aplikasi
              Text("YukKemah!", style: AppTextStyles.appTitle),
              const SizedBox(height: 32),

              // Judul Login
              Text("Masuk", style: AppTextStyles.header),
              const SizedBox(height: 24),

              // Email
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Masukkan Email", style: AppTextStyles.label),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: _emailController, // Controller untuk email
                      decoration: const InputDecoration.collapsed(
                        hintText: "Email",
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Password
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Masukkan Password", style: AppTextStyles.label),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller:
                          _passwordController, // Controller untuk password
                      obscureText: true,
                      decoration: const InputDecoration.collapsed(
                        hintText: "Password",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Link Register & Lupa Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      "Belum punya akun?",
                      style: AppTextStyles.link.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/forgetpass');
                    },
                    child: Text(
                      "Lupa Password?",
                      style: AppTextStyles.link.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Tombol Masuk
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _login, // Panggil fungsi _login
                  child: Text(
                    "Masuk",
                    style: AppTextStyles.button.copyWith(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
