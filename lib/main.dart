import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const PetSaveApp());
}

class PetSaveApp extends StatelessWidget {
  const PetSaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetSave',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
