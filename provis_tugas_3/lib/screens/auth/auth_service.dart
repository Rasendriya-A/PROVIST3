// lib/screens/auth/auth_service.dart

import 'package:provis_tugas_3/models/user_model.dart';
import 'package:provis_tugas_3/screens/profile/services/mock_user_data.dart';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      print("Error saat registrasi: ${e.message}");
      return null;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      print("Error saat login: ${e.message}");
      return null;
    }
  }

  // Fungsi login untuk mencocokkan email dan password dengan data mock
  // Future<UserModel?> login(String email, String password) async {
  //   // Menunggu beberapa detik agar terasa seperti proses autentikasi nyata
  //   await Future.delayed(const Duration(seconds: 1));
  //
  //   // Mencari user yang cocok dengan email dan password
  //   final user = mockUsers.firstWhere(
  //     (user) => user.email == email && user.password == password,
  //     orElse: () => UserModel(id: -1, name: "", email: "", password: ""),
  //   );
  //
  //   // Jika user ditemukan (id != -1), kembalikan user, jika tidak return null
  //   if (user.id != -1) {
  //     return user;
  //   } else {
  //     return null;
  //   }
  // }
}
