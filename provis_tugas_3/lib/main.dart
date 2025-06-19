import 'package:flutter/material.dart';
import 'package:provis_tugas_3/routes/app_routes.dart';
import 'package:provis_tugas_3/screens/cart/cart_page.dart';
import 'package:provis_tugas_3/screens/transaction/transaction_page.dart';
import 'package:intl/date_symbol_data_local.dart'; // Add this import

// Import screens
import 'screens/home/home_page.dart';
import 'screens/profile/pf_user/profile_screen.dart';
import 'screens/auth/login_page.dart';

// Import package Firebase Core dan file konfigurasi
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('id_ID'); // Use 'id_ID' for Indonesian locale
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YukKemah!',
      theme: ThemeData(
        primaryColor: const Color(0xFF4B6543),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF4B6543)),
        // fontFamily: 'Inter',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4B6543),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      routes: AppRoutes.routes,
    );
  }
}

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yuk Kemah!'), centerTitle: true),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Text(
              'Nomor Kelompok: 6',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Home Page',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Profile User',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TransactionPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Transaksi',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RentalCartPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Keranjang',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
