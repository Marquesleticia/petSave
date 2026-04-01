import 'package:flutter/material.dart';

import 'pages/home_page.dart'; 

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
      // 2. Aqui nós chamamos a classe principal que está lá no seu home_page.dart
      home: const PetSaveHomePage(), 
      debugShowCheckedModeBanner: false, // Remove a faixa de "DEBUG" da tela
    );
  }
}