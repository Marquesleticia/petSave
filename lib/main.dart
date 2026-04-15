// Importações para Flutter
import 'package:flutter/material.dart';
import 'pages/login_page.dart';

// Função principal - ponto de entrada da aplicação
void main() {
  runApp(const PetSaveApp());
}

// Widget raiz da aplicação - define configurações globais
class PetSaveApp extends StatelessWidget {
  const PetSaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetSave',
      // Configuração do tema da aplicação
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      // Define LoginPage como página inicial
      home: const LoginPage(),
      // Remove o banner de debug no canto superior direito
      debugShowCheckedModeBanner: false,
    );
  }
}
