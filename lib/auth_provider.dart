import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  Map<String, dynamic>? _user;

  String? get token => _token;
  Map<String, dynamic>? get user => _user;

  bool get isAuth {
    return _token != null;
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse('https://api-digitalevent.onrender.com/api/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'contrasena': password,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        _token = responseData['token'];
        _user = responseData['user'];
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', _token!);
        prefs.setString('user', json.encode(_user));
        notifyListeners();
      } else {
        throw Exception(responseData['error']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> register(String nombre, String email, String lastName, String password, String telefono) async {
    final url = Uri.parse('https://api-digitalevent.onrender.com/api/users/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nombre': nombre,
          'email': email,
          'last_name': lastName,
          'contrasena': password,
          'telefono': telefono,
          'rol_id': 2, // rol_id is set to 2 by default for users
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        // Automatically login after successful registration
        await login(email, password);
        notifyListeners(); // Ensure the UI is updated
      } else {
        throw Exception(responseData['error']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('user');
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) {
      return;
    }
    _token = prefs.getString('token');
    if (prefs.containsKey('user')) {
      _user = json.decode(prefs.getString('user')!);
    }
    notifyListeners();
  }
}
