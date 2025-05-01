// lib/screens/auth/auth_service.dart

import 'package:provis_tugas_3/models/user_model.dart';
import 'package:provis_tugas_3/services/mock_user_data.dart';

class AuthService {
  // Fungsi login untuk mencocokkan email dan password dengan data mock
  Future<UserModel?> login(String email, String password) async {
    // Menunggu beberapa detik agar terasa seperti proses autentikasi nyata
    await Future.delayed(const Duration(seconds: 1));

    // Mencari user yang cocok dengan email dan password
    final user = mockUsers.firstWhere(
      (user) => user.email == email && user.password == password,
      orElse: () => UserModel(id: -1, name: "", email: "", password: ""),
    );

    // Jika user ditemukan (id != -1), kembalikan user, jika tidak return null
    if (user.id != -1) {
      return user;
    } else {
      return null;
    }
  }
}
