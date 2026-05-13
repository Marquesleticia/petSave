class LoginService {
  // Simula autenticação. Substitua por chamada real à API se necessário.
  Future<bool> authenticate(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    // Exemplo: aceita qualquer email e senha com 6+ caracteres
    return email.isNotEmpty && password.length >= 6;
  }
}
