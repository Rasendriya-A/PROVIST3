import 'package:flutter/material.dart';
import 'package:provis_tugas_3/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YukKemah!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppRoutes.home, // ganti dari home ke initialRoute
      routes: AppRoutes.routes,     // pasang daftar route dari AppRoutes
    );
  }
}
