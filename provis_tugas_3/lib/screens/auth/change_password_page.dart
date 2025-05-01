import 'package:flutter/material.dart';
import 'package:provis_tugas_3/utils/app_colors.dart';
import 'package:provis_tugas_3/utils/app_text_styles.dart';
import 'package:provis_tugas_3/models/user_model.dart';
import 'package:provis_tugas_3/services/mock_user_data.dart';

class ChangePasswordPage extends StatefulWidget {
  final String email; // Menambahkan email untuk mengidentifikasi pengguna

  const ChangePasswordPage({super.key, required this.email});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Fungsi untuk memeriksa apakah password valid
  bool _isPasswordValid(String password) {
    return password.length >= 6;
  }

  // Fungsi untuk mengubah password
  void _changePassword() {
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Validasi password
    if (!_isPasswordValid(newPassword)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password harus lebih dari 6 karakter")),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password tidak cocok")),
      );
      return;
    }

    // Mencari user yang sesuai berdasarkan email yang diterima
    UserModel? userToUpdate = mockUsers.firstWhere(
      (user) => user.email == widget.email,
      orElse: () => UserModel(id: -1, name: "", email: "", password: ""),
    );

    if (userToUpdate.id != -1) {
      // Memperbarui password pengguna yang ditemukan
      setState(() {
        userToUpdate.updatePassword(newPassword); // Menggunakan metode updatePassword
      });

      // Jika password valid dan cocok
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password berhasil diubah")),
      );

      // Navigasi ke halaman login setelah perubahan
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User tidak ditemukan")),
      );
    }
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
              Text("Ubah Password", style: AppTextStyles.header),
              const SizedBox(height: 24),

              // Input Password Baru
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Masukkan Password Baru", style: AppTextStyles.label),
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
                      controller: _newPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration.collapsed(hintText: "Password"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Input Konfirmasi Password
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Masukkan Kembali Password", style: AppTextStyles.label),
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
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration.collapsed(hintText: "Konfirmasi Password"),
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
                  onPressed: _changePassword,  // Panggil fungsi untuk mengubah password
                  child: Text(
                    "Ubah Password",
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
