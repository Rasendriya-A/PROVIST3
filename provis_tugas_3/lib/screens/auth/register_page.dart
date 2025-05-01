import 'package:flutter/material.dart';
import 'package:provis_tugas_3/utils/app_colors.dart';
import 'package:provis_tugas_3/utils/app_text_styles.dart';
import 'package:provis_tugas_3/models/user_model.dart';
import 'package:provis_tugas_3/services/mock_user_data.dart'; // Untuk mock data

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controller untuk email, password, dan konfirmasi password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Fungsi untuk menangani pendaftaran
  void _register() {
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Validasi form
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field harus diisi")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password dan konfirmasi password tidak cocok")),
      );
      return;
    }

    // Cek apakah email sudah terdaftar
    bool emailExists = mockUsers.any((user) => user.email == email);
    if (emailExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email sudah terdaftar")),
      );
      return;
    }

    // Menambahkan user baru ke mock data
    final newUser = UserModel(
      id: mockUsers.length + 1,
      name: "User ${mockUsers.length + 1}",
      email: email,
      password: password,
    );

    mockUsers.add(newUser); // Menambahkan user ke mock data

    // Navigasi ke halaman login setelah berhasil daftar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pendaftaran berhasil! Silakan login")),
    );
    Navigator.pushReplacementNamed(context, '/login');  // Mengarahkan ke login
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
              Text(
                "YukKemah!",
                style: AppTextStyles.appTitle,
              ),
              const SizedBox(height: 32),

              // Judul Register
              Text(
                "Daftar",
                style: AppTextStyles.header,
              ),
              const SizedBox(height: 24),

              // Email
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Masukkan Email", style: AppTextStyles.label),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration.collapsed(hintText: "Email"),
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
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration.collapsed(hintText: "Password"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Konfirmasi Password
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Masukkan Kembali Password", style: AppTextStyles.label),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration.collapsed(hintText: "Ulangi Password"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sudah punya akun?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      "Sudah punya Akun?",
                      style: AppTextStyles.link.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Tombol Daftar
              ElevatedButton(
                onPressed: _register,  // Panggil fungsi _register
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Daftar",
                  style: AppTextStyles.button.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
