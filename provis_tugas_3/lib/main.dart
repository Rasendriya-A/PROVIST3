import 'package:flutter/material.dart';
import 'screens/home/home_page.dart';
import 'screens/profile/pf_user/profile_screen.dart';
import 'screens/auth/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Resep',
      theme: ThemeData(
        primaryColor: Color(0xFF4B6543),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4B6543),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF4B6543),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const NavigationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yuk Kemah!'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Text(
              'Nomor Kelompok: 6',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
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
                          MaterialPageRoute(builder: (context) => const HomePage()),
                        );
                      },
                      child: const Text('Home Page', style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfileScreen()),
                        );
                      },
                      child: const Text('Profile User', style: TextStyle(fontSize: 16)),
                    ),
                    // const SizedBox(height: 16),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => const TransaksiScreen()),
                    //     );
                    //   },
                    //   child: const Text('Transaksi', style: TextStyle(fontSize: 16)),
                    // ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text('Login', style: TextStyle(fontSize: 16)),
                    ),
                    // const SizedBox(height: 16),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => const KeranjangScreen()),
                    //     );
                    //   },
                    //   child: const Text('Keranjang', style: TextStyle(fontSize: 16)),
                    // ),
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