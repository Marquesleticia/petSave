import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'pages/login_page.dart';

/// Ponto de entrada da aplicação.
///
/// Inicializa o SDK do Supabase antes de rodar o app (RQ02).
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url:    SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  runApp(const PetSaveApp());
}

/// Widget raiz da aplicação.
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
