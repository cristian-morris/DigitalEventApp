import 'package:digitalevent/Inicio.dart';
import 'package:digitalevent/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscured = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }


 void _submit(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
       showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Campos vacíos'),
        content: Text('Por favor ingresa tus credenciales'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {});
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
      return;
    }
    try {
      await Provider.of<AuthProvider>(context, listen: false).login(email, password);
    } catch (error) {
      showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error de autenticación'),
        content: Text('Email o contraseña no válidos'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {});
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
      final authProvider = Provider.of<AuthProvider>(context);

    // Verificar si el usuario ya está autenticado y redirigir si es necesario
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authProvider.isAuth) {
        Navigator.of(context).pushReplacementNamed('/main');
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: ColorFiltered(
              colorFilter:
                  ColorFilter.mode(Color(0xFF6F35A5), BlendMode.srcATop),
              child: Image.asset(
                'assets/main_top.png', // Cambia esto a la ruta correcta de tu imagen
                width: size.width * 0.37,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(5.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 130,
                  ),
                  Text(
                    "!Bienvenido, Inicia Sesión!",
                    style: GoogleFonts.openSans(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 70, 70, 70)),
                  ),
                  ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                        Color(0xFF6F35A5), BlendMode.srcATop),
                    child: Image.asset(
                      'assets/LOGO HUB BLANCO 1.png',
                      fit: BoxFit.cover,
                      width: 200,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 310,
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
                        prefixIcon:
                            const Icon(Icons.person, color: Color(0xFF6F35A5)),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              style: BorderStyle.none,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 310,
                    child: TextField(
                      controller: _passwordController,
                      obscuringCharacter: '*',
                      obscureText: _isObscured,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xFF6F35A5),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFF6F35A5),
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 234, 219, 252),
                        labelText: 'Contraseña:',
                        labelStyle: GoogleFonts.openSans(
                            color: const Color.fromARGB(255, 86, 86, 86),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              style: BorderStyle.none,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 270,
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () => _submit(context),
                        style: const ButtonStyle(
                          shape: WidgetStatePropertyAll<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)))),
                          backgroundColor:
                              WidgetStatePropertyAll<Color>(Colors.deepPurple),
                        ),
                        child: Text(
                          'Iniciar Sesión',
                          style: GoogleFonts.openSans(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 30,
                      ),
                      Text(
                        'Olvidastes tu Contraseña?',
                        style: GoogleFonts.openSans(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      TextButton(
                        onPressed: () {
                          // Aquí puedes añadir la lógica que quieres ejecutar al presionar el botón
                        },
                        child: Text(
                          'Restablecer',
                          style: GoogleFonts.openSans(
                              fontSize: 17,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Text(
                    'O',
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: 336,
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll<Color>(Colors.white),
                          shape: WidgetStatePropertyAll<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)))),
                          side: WidgetStatePropertyAll<BorderSide>(
                              BorderSide(width: 2.0, color: Colors.deepPurple)),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Inicia Sesión Con Google',
                              style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Image(image: AssetImage('assets/google.png')),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 70,
                      ),
                      Text(
                        'No tienes cuenta?',
                        style: GoogleFonts.openSans(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      TextButton(
                        onPressed: () {
                          // Aquí puedes añadir la lógica que quieres ejecutar al presionar el botón
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Register(),
                            ),
                          );
                        },
                        child: Text(
                          'Registrate',
                          style: GoogleFonts.openSans(
                              fontSize: 17,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold),
                        ),
                      )
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
