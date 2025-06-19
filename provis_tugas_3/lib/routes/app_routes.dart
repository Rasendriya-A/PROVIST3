import 'package:flutter/material.dart';
import 'package:provis_tugas_3/screens/home/home_page.dart';
import 'package:provis_tugas_3/screens/auth/login_page.dart';
import 'package:provis_tugas_3/screens/auth/register_page.dart';
import 'package:provis_tugas_3/screens/auth/forget_pass_page.dart';
import 'package:provis_tugas_3/screens/auth/change_password_page.dart';
import 'package:provis_tugas_3/screens/profile/profile_page.dart';
import 'package:provis_tugas_3/screens/product/browse.dart';
import 'package:provis_tugas_3/screens/cart/cart_page.dart';
import 'package:provis_tugas_3/screens/checkout/checkout_page.dart';
import 'package:provis_tugas_3/screens/transaction/transaction_page.dart';

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgetpass = '/forgetpass';
  static const String changepassword = '/changepassword';
  static const String profile = '/profile';
  static const String browse = '/browse';
  static const String detail = '/detail';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String transaction = '/transaction';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const HomePage(),
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
    forgetpass: (context) => const ForgetPassPage(),
    changepassword: (context) => const ChangePasswordPage(),
    profile: (context) => const ProfilePage(),
    browse: (context) => const Browse(),
    // detail: (context) => const Detail(),
    cart: (context) => const RentalCartPage(),
    checkout: (context) => const CheckoutPage(),
    transaction: (context) => const TransactionPage(),
  };
}
