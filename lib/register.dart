import 'package:digitalevent/login.dart';
import 'package:digitalevent/auth_provider.dart';
import 'package:digitalevent/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isObscured = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  void _showCustomDialog(BuildContext context, String title, String message,
      {bool isError = true}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: isError ? Colors.red : Colors.green,
            ),
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

  void _submit(BuildContext context) async {
    final nombre = nameController.text;
    final lastName = lastNameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final telefono = phoneController.text;

    if (nombre.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        telefono.isEmpty) {
      _showCustomDialog(context, 'Campos vacíos',
          'Por favor completa todos los campos para continuar.');
      return;
    }

    try {
      await Provider.of<AuthProvider>(context, listen: false).register(
        nombre,
        email,
        lastName,
        password,
        telefono,
      );
      _showCustomDialog(context, 'Registro exitoso',
          'Tu registro fue exitoso. Ahora serás redirigido a la página principal.',
          isError: false);
      await Future.delayed(
          Duration(seconds: 2)); // Espera para mostrar la alerta
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage()),
        (route) => false, // Elimina todas las rutas anteriores
      );
    } catch (error) {
      _showCustomDialog(context, 'Error de autenticación',
          'Ocurrió un error durante el registro. ${error}');
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
                    "Regístrate",
                    style: GoogleFonts.openSans(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 70, 70, 70),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 325,
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 234, 219, 252),
                        labelText: 'Nombre:',
                        labelStyle: GoogleFonts.openSans(
                            color: const Color.fromARGB(255, 86, 86, 86),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        prefixIcon:
                            const Icon(Icons.person, color: Color(0xFF6F35A5)),
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
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 325,
                    child: TextField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 234, 219, 252),
                        labelText: 'Apellido:',
                        labelStyle: GoogleFonts.openSans(
                            color: const Color.fromARGB(255, 86, 86, 86),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        prefixIcon:
                            const Icon(Icons.person, color: Color(0xFF6F35A5)),
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
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 325,
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 234, 219, 252),
                        labelText: 'Correo Electrónico:',
                        labelStyle: GoogleFonts.openSans(
                            color: const Color.fromARGB(255, 86, 86, 86),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        prefixIcon:
                            const Icon(Icons.email, color: Color(0xFF6F35A5)),
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
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 325,
                    child: TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 234, 219, 252),
                        labelText: 'Teléfono:',
                        labelStyle: GoogleFonts.openSans(
                            color: const Color.fromARGB(255, 86, 86, 86),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        prefixIcon:
                            const Icon(Icons.phone, color: Color(0xFF6F35A5)),
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
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 325,
                    child: TextField(
                      controller: passwordController,
                      obscureText: _isObscured,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 234, 219, 252),
                        labelText: 'Contraseña:',
                        labelStyle: GoogleFonts.openSans(
                            color: const Color.fromARGB(255, 86, 86, 86),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        prefixIcon:
                            const Icon(Icons.lock, color: Color(0xFF6F35A5)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFF6F35A5),
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
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
                    onTap: () => _submit(context),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Registrar',
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
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "¿Ya tienes una cuenta?",
                        style: GoogleFonts.openSans(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: Text(
                          "Inicia sesión",
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: Color(0xFF6F35A5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
