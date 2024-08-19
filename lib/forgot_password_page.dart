import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http; // Importa el paquete http
import 'dart:convert'; // Importa para decodificar la respuesta JSON

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  void _showCustomDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue),
            SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.openSans(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: GoogleFonts.openSans(
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Aceptar',
              style: GoogleFonts.openSans(
                color: Color(0xFF6F35A5),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForgotPassword(BuildContext context) async {
    final email = _emailController.text;

    if (email.isEmpty) {
      _showCustomDialog(context, 'Campo vacío',
          'Por favor, ingrese su correo electrónico para continuar.');
      return;
    }

    final url = Uri.parse(
        'https://api-digitalevent.onrender.com/api/password/forgot-password');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        _showCustomDialog(context, 'Solicitud enviada',
            'Se ha enviado un enlace de restablecimiento de contraseña a su correo electrónico.');
      } else {
        _showCustomDialog(context, 'Error',
            'Hubo un problema al enviar el enlace de restablecimiento. Por favor, intente nuevamente.');
      }
    } catch (error) {
      _showCustomDialog(context, 'Error de red',
          'No se pudo conectar al servidor. Por favor, verifique su conexión a Internet e intente nuevamente.');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: ColorFiltered(
              colorFilter:
                  const ColorFilter.mode(Colors.purple, BlendMode.srcATop),
              child: Image.asset(
                'assets/main_top.png',
                width: size.width * 0.37,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                          Color(0xFF6F35A5), BlendMode.srcATop),
                      child: Image.asset(
                        'assets/LOGO HUB BLANCO 1.png',
                        fit: BoxFit.cover,
                        width: 200,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Recuperar Contraseña",
                      style: GoogleFonts.openSans(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 70, 70, 70)),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 325,
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(255, 234, 219, 252),
                          labelText: 'Correo Electrónico:',
                          labelStyle: GoogleFonts.openSans(
                              color: const Color.fromARGB(255, 86, 86, 86),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          prefixIcon: const Icon(Icons.person,
                              color: Color(0xFF6F35A5)),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => _submitForgotPassword(context),
                      child: Container(
                        width: 250,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Colors.purple,
                              Colors.deepPurple,
                              Colors.purpleAccent
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send, color: Colors.white),
                            const SizedBox(width: 10),
                            Text(
                              'Enviar Correo',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Volver a Iniciar Sesión',
                        style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
