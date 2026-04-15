// Importações para UI e navegação
import 'package:flutter/material.dart';
import 'package:pet_save/pages/home_page.dart';
import 'package:pet_save/pages/register_page.dart';

// Página de login - utiliza StatefulWidget para gerenciar estado do formulário
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// Estado da página de login
class _LoginPageState extends State<LoginPage> {
  // Chave para validação do formulário
  final _formKey = GlobalKey<FormState>();
  // Controladores dos campos de entrada
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // Flag para controlar visibilidade da senha
  bool _obscurePassword = true;

  // Libera recursos dos controladores quando a página é fechada
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Valida e realiza o login
  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      // Navega para a página inicial com o nome do usuário
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PetSaveHomePage(userName: _emailController.text.split('@').first),
        ),
      );
    }
  }

  // Constrói a interface com layout responsivo
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      // Layout adaptativo para diferentes tamanhos de tela
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Detecta se a tela é grande (tablet/desktop)
          final isWide = constraints.maxWidth >= 800;

          return isWide
              ? _WideLayout(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  obscurePassword: _obscurePassword,
                  onTogglePassword: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  onLogin: _login,
                )
              : _NarrowLayout(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  obscurePassword: _obscurePassword,
                  onTogglePassword: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  onLogin: _login,
                );
        },
      ),
    );
  }
}

// Layout para telas LARGAS (≥ 800px) - painel duplo com imagem e formulário
class _WideLayout extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onLogin;

  const _WideLayout({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ── Painel esquerdo: foto ──────────────
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                'https://cdn.pixabay.com/photo/2016/02/19/15/46/dog-1210559_1280.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFE8D5B0),
                  child: const Icon(Icons.pets, size: 80, color: Colors.white),
                ),
              ),
              // Gradiente escuro na parte inferior
              Positioned.fill(
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xCC1A1A1A)],
                      stops: [0.5, 1.0],
                    ),
                  ),
                ),
              ),
              // Logo no topo
              Positioned(
                top: 32,
                left: 32,
                child: _Logo(light: true),
              ),
              // Texto no rodapé
              Positioned(
                bottom: 40,
                left: 36,
                right: 36,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Juntos fazemos\na diferença.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 1.25,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Junte-se a milhares de pessoas que ajudam\nanimais a encontrar o caminho de volta a casa.',
                      style: TextStyle(
                        color: Color(0xCCFFFFFF),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── Painel direito: formulário ─────────
        SizedBox(
          width: 480,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
              child: _FormContent(
                formKey: formKey,
                emailController: emailController,
                passwordController: passwordController,
                obscurePassword: obscurePassword,
                onTogglePassword: onTogglePassword,
                onLogin: onLogin,
                showLogo: false,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Layout para telas PEQUENAS (< 800px) - coluna única com banner e formulário
class _NarrowLayout extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onLogin;

  const _NarrowLayout({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Mini banner no topo
          SizedBox(
            height: 220,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://cdn.pixabay.com/photo/2016/02/19/15/46/dog-1210559_1280.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: const Color(0xFFE8D5B0)),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xAA1A1A1A)],
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: _Logo(light: true),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: _FormContent(
              formKey: formKey,
              emailController: emailController,
              passwordController: passwordController,
              obscurePassword: obscurePassword,
              onTogglePassword: onTogglePassword,
              onLogin: onLogin,
              showLogo: false,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget da logo PetSave
class _Logo extends StatelessWidget {
  // true = logo em branco, false = logo em preto
  final bool light;
  const _Logo({this.light = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFF97316),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.pets, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 10),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Pet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: light ? Colors.white : const Color(0xFF1A1A1A),
                ),
              ),
              const TextSpan(
                text: 'Save',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFF97316),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Formulário de login - reutilizável em ambos os layouts
class _FormContent extends StatelessWidget {
  // Dados do formulário
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword; // Controla visibilidade da senha
  // Callbacks
  final VoidCallback onTogglePassword; // Alterna visibilidade
  final VoidCallback onLogin; // Executa login
  final bool showLogo; // Mostra logo ou não

  const _FormContent({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onLogin,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFF97316);
    const dark = Color(0xFF1A1A1A);

    final inputDecoration = InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: orange, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );

    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: inputDecoration,
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showLogo) ...[
              const _Logo(),
              const SizedBox(height: 32),
            ],

            // Ícone avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0E6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.person_outline, color: orange, size: 28),
            ),
            const SizedBox(height: 20),

            const Text(
              'Bem-vindo de volta',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: dark,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Faça login na sua conta para registrar alertas e gerir os seus animais.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF6B6B6B),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 36),

            // Campo e-mail
            const Text(
              'Endereço de Email',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: dark,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'exemplo@email.com',
                prefixIcon: Icon(Icons.mail_outline,
                    size: 20, color: Color(0xFF9E9E9E)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Informe seu e-mail';
                if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'E-mail inválido';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Campo senha
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Palavra-passe',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: dark,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Recuperação de senha ainda não implementada.'),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Esqueceu-se?',
                    style: TextStyle(
                        color: orange,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: passwordController,
              obscureText: obscurePassword,
              decoration: InputDecoration(
                hintText: '••••••••',
                prefixIcon: const Icon(Icons.lock_outline,
                    size: 20, color: Color(0xFF9E9E9E)),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: const Color(0xFF9E9E9E),
                  ),
                  onPressed: onTogglePassword,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Informe sua senha';
                if (value.length < 6) return 'Mínimo de 6 caracteres';
                return null;
              },
            ),
            const SizedBox(height: 28),

            // Botão entrar
            SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                onPressed: onLogin,
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: const Text(
                  'Entrar na Conta',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: dark,
                  foregroundColor: Colors.white,
                  iconColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Link cadastro
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: WidgetSpan(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Ainda não tem conta? ',
                        style:
                            TextStyle(color: Color(0xFF6B6B6B), fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Registe-se gratuitamente',
                          style: TextStyle(
                            color: orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
