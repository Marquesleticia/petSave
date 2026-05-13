import 'package:flutter/material.dart';
import '../models/login_model.dart';
import '../services/login_service.dart';

class LoginController extends ChangeNotifier {
  final LoginService _service;
  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  LoginController({LoginService? service})
      : _service = service ?? LoginService();

  Future<bool> login(LoginModel model) async {
    _setLoading(true);
    _error = null;
    notifyListeners();
    try {
      final success = await _service.authenticate(model.email, model.password);
      if (!success) {
        _error = 'E-mail ou senha inválidos';
      }
      return success;
    } catch (e) {
      _error = 'Erro ao autenticar';
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
