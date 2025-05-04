import 'package:flutter/material.dart';
import 'package:provis_tugas_3/screens/home/home_page.dart';
import 'package:provis_tugas_3/screens/auth/login_page.dart';
import 'package:provis_tugas_3/screens/auth/register_page.dart';
import 'package:provis_tugas_3/screens/auth/forget_pass_page.dart';
import 'package:provis_tugas_3/screens/auth/change_password_page.dart';
import 'package:provis_tugas_3/screens/profile/profile_page.dart';
import 'package:provis_tugas_3/screens/product/browse.dart';
import 'package:provis_tugas_3/screens/product/detail.dart';

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgetpass = '/forgetpass';
  static const String changepassword = '/changepassword';
  static const String profile = '/profile';
  static const String browse = '/browse';
  static const String detail = '/detail';

  static Map<String, WidgetBuilder> routes = {
  home: (context) => const HomePage(),
  login: (context) => const LoginPage(),
  register: (context) => const RegisterPage(),
  forgetpass: (context) => const ForgetPassPage(),
  changepassword: (context) {
      final email = ModalRoute.of(context)?.settings.arguments as String;
      return ChangePasswordPage(email: email);
    },
  profile: (context) => const ProfilePage(),
  browse: (context) => const Browse(),
  detail: (context) => const Detail(),
  };
}
