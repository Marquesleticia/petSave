import 'package:flutter/material.dart';

import 'package:pet_save/models/login_model.dart';
import 'package:pet_save/services/login_service.dart';

/// Controller da tela de login (RQ03).
///
/// Gerencia estado de carregamento e erros.
/// Expõe [loggedUserName] após autenticação bem-sucedida.
class LoginController extends ChangeNotifier {
  final LoginService _service;

  bool    _loading        = false;
  String? _error;
  String? _loggedUserName;

  bool    get loading        => _loading;
  String? get error          => _error;
  String? get loggedUserName => _loggedUserName;

  LoginController({LoginService? service})
      : _service = service ?? LoginService();

  /// Autentica o usuário. Retorna [true] em sucesso.
  Future<bool> login(LoginModel model) async {
    _setLoading(true);
    _error          = null;
    _loggedUserName = null;

    try {
      final name = await _service.authenticate(model.email, model.password);

      if (name == null) {
        _error = 'E-mail ou senha inválidos.';
        return false;
      }

      _loggedUserName = name;
      return true;
    } catch (_) {
      _error = 'Erro ao autenticar. Tente novamente.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
