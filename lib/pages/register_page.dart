// Importações para UI e serviços
import 'package:flutter/material.dart';
import 'package:pet_save/pages/home_page.dart';
import 'package:pet_save/services/postgres_service.dart';

// Definição das cores usadas na página de registro
const _bg = Color(0xFF141210); // Cor de fundo escuro
const _surface = Color(0xFF1F1C19); // Cor do card/superficie
const _orange = Color(0xFFF97316); // Cor laranja para destaques
const _textPrimary = Color(0xFFF5F0EA); // Cor do texto principal
const _textSecondary = Color(0xFF9E9589); // Cor do texto secundário
const _divider = Color(0xFF3E3933); // Cor das bordas/divisores

// Página de registro de novo usuário - utiliza StatefulWidget para gerenciar estado
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

// Estado da página de registro
class _RegisterPageState extends State<RegisterPage> {
  // Chave para validação do formulário
  final _formKey = GlobalKey<FormState>();

  // Controladores dos campos de input
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Flag para indicar se está processando o registro
  bool _isLoading = false;

  // Serviço para comunicação com o banco de dados
  final _service = PostgresService();

  // Libera recursos dos controladores quando a página é fechada
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Valida os dados e registra o novo usuário no banco de dados
  Future<void> _register() async {
    // Valida os campos do formulário
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Inicia o carregamento
    setState(() => _isLoading = true);

    // Envia os dados para o serviço de registro
    final error = await _service.registerUser(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Exibe mensagem de erro, se houver
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    // Sucesso: navega para a página inicial
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PetSaveHomePage(userName: _nameController.text.trim()),
      ),
    );
  }

  // Define o estilo dos campos de texto com ícone
  InputDecoration _field(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: _textSecondary),
      prefixIcon: Icon(icon, color: _textSecondary),
      filled: true,
      fillColor: _bg,
      // Borda padrão
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _divider)),
      // Borda quando o campo não está ativo
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _divider)),
      // Borda quando o campo está em foco (laranja)
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _orange, width: 1.5)),
      // Borda quando há erro
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEF4444))),
      // Borda quando há erro e está em foco
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5)),
    );
  }

  // Constrói a interface da página
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      // Barra superior com título
      appBar: AppBar(
        title: const Text('Cadastre-se',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: _bg,
        foregroundColor: _textPrimary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: _orange),
      ),
      // Layout responsivo que se adapta a telas largas (tablets/desktop)
      body: LayoutBuilder(builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 800;
        return Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            // Card contendo o formulário
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: isWide ? 520 : double.infinity),
              child: Container(
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: _divider),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10))
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Título e subtítulo
                      Text('Crie sua conta',
                          style: TextStyle(
                              fontSize: isWide ? 32 : 28,
                              fontWeight: FontWeight.w900,
                              color: _textPrimary,
                              letterSpacing: -0.5)),
                      const SizedBox(height: 8),
                      const Text(
                          'Preencha seus dados para entrar na comunidade.',
                          style: TextStyle(
                              fontSize: 15,
                              color: _textSecondary,
                              height: 1.5)),
                      const SizedBox(height: 32),

                      // Campo de nome
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        style: const TextStyle(color: _textPrimary),
                        cursorColor: _orange,
                        decoration:
                            _field('Nome', Icons.person_outline_rounded),
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Informe seu nome'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Campo de e-mail com validação
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: _textPrimary),
                        cursorColor: _orange,
                        decoration: _field('E-mail', Icons.email_outlined),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Informe seu e-mail';
                          if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(v)) return 'E-mail inválido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Campo de senha
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(color: _textPrimary),
                        cursorColor: _orange,
                        decoration: _field('Senha', Icons.lock_outline_rounded),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Informe sua senha';
                          if (v.length < 6) return 'Mínimo de 6 caracteres';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Campo de confirmação de senha
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        style: const TextStyle(color: _textPrimary),
                        cursorColor: _orange,
                        decoration: _field(
                            'Confirme a senha', Icons.lock_reset_rounded),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Confirme sua senha';
                          if (v != _passwordController.text)
                            return 'As senhas não coincidem';
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),

                      // Botão de cadastro
                      SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _orange,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: _orange.withOpacity(0.5),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          // Mostra loading enquanto está processando
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2.5))
                              : const Text('Cadastrar',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5)),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Link para voltar ao login
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(foregroundColor: _orange),
                        child: const Text('Já tem uma conta? Faça login',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
