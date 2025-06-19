import 'package:flutter/material.dart';
import 'package:provis_tugas_3/utils/app_colors.dart';
import 'package:provis_tugas_3/utils/app_text_styles.dart';
import 'dart:math'; // Untuk meng-generate kode acak
import 'package:provis_tugas_3/routes/app_routes.dart';

class ForgetPassPage extends StatefulWidget {
  const ForgetPassPage({super.key});

  @override
  State<ForgetPassPage> createState() => _ForgetPassPageState();
}

class _ForgetPassPageState extends State<ForgetPassPage> {
  final TextEditingController _emailController = TextEditingController();
  String? _verificationCode; // Variabel untuk menyimpan kode verifikasi

  // Fungsi untuk meng-generate kode acak
  String _generateRandomCode() {
    final random = Random();
    return (random.nextInt(900000) + 100000).toString();  // 6 digit kode
  }

  // Fungsi untuk menangani proses lupa password
  void _sendVerificationCode() {
    String email = _emailController.text;

    // Cek apakah email valid atau ada dalam mock data
    // Jika ada, kirimkan kode verifikasi (simulasi)
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Masukkan email yang valid")),
      );
      return;
    }

    // Generate kode verifikasi acak
    _verificationCode = _generateRandomCode();

    // Cetak kode ke konsol untuk debugging
    debugPrint("Kode Verifikasi yang Dikirim: $_verificationCode");

    // Kirim email ke ChangePasswordPage menggunakan rute dengan argumen
    Navigator.pushNamed(
      context,
      AppRoutes.changepassword,
      arguments: email,  // Kirim email ke ChangePasswordPage
    );
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

              // Judul Lupa Password
              Text("Lupa Password", style: AppTextStyles.header),
              const SizedBox(height: 24),

              // Pesan & Kode
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Pesan", style: AppTextStyles.label),
                  const SizedBox(height: 8),
                  Text("Masukkan Email Anda dan tunggu kode yang akan dikirimkan", style: AppTextStyles.small),
                  const SizedBox(height: 16),
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
                      controller: _emailController, // Menghubungkan controller dengan input
                      decoration: const InputDecoration.collapsed(hintText: "Email"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Tombol Kirim
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _sendVerificationCode,  // Panggil fungsi untuk mengirim kode
                  child: Text(
                    "Kirim",
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
