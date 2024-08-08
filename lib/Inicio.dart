import 'package:digitalevent/Login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  bool _isObscured = true;

  String? selectedRole;
  String? selectedMembership;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('https://api-digitalevent.onrender.com/api/users/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'nombre': nameController.text,
          'email': emailController.text,
          'contrasena': passwordController.text,
          'telefono': phoneController.text,
          'last_name': lastNameController.text,
          'rol_id': '3', // Rol predefinido (Cliente)
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Aquí asumimos que el servidor devuelve un JSON en el cuerpo de la respuesta
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201 ||
          responseData['message'] == 'User created successfully') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registrado, por favor ve a login")));
        // Limpiar los campos del formulario
        nameController.clear();
        emailController.clear();
        passwordController.clear();
        lastNameController.clear();
        phoneController.clear();
        setState(() {
          selectedRole = null;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Error al registrar el usuario: ${response.body}'),
              actions: [
                TextButton(
                  child: const Text('Cerrar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Color.fromARGB(255, 114, 53, 171), BlendMode.srcATop),
              child: Image.asset(
                'assets/main_top.png',
                width: size.width * 0.37,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(5.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Registrate",
                      style: GoogleFonts.lato(
                        fontSize: 28.0,
                        color: Color.fromARGB(255, 70, 70, 70),
                        fontWeight: FontWeight.bold,
                      ),
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
                      height: 15,
                    ),
                    Container(
                      width: 310,
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          prefixIcon:
                              Icon(Icons.person, color: Color(0xFF6F35A5)),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 234, 219, 252),
                          labelText: 'Nombre:',
                          labelStyle: GoogleFonts.openSans(
                            color: const Color.fromARGB(255, 86, 86, 86),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              style: BorderStyle.none,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu nombre';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 310,
                      child: TextFormField(
                        controller: lastNameController,
                        decoration: InputDecoration(
                          prefixIcon:
                              Icon(Icons.person, color: Color(0xFF6F35A5)),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 234, 219, 252),
                          labelText: 'Apellido:',
                          labelStyle: GoogleFonts.openSans(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              style: BorderStyle.none,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu apellido';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 310,
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon:
                              Icon(Icons.email, color: Color(0xFF6F35A5)),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 234, 219, 252),
                          labelText: 'Correo Electrónico:',
                          labelStyle: GoogleFonts.openSans(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              style: BorderStyle.none,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu correo electrónico';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 310,
                      child: TextFormField(
                        controller: passwordController,
                        obscuringCharacter: '*',
                        obscureText: _isObscured,
                        decoration: InputDecoration(
                          prefixIcon:
                              Icon(Icons.lock, color: Color(0xFF6F35A5)),
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
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple,
                              style: BorderStyle.none,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu contraseña';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 310,
                      child: TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          prefixIcon:
                              Icon(Icons.phone, color: Color(0xFF6F35A5)),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 234, 219, 252),
                          labelText: 'Teléfono:',
                          labelStyle: GoogleFonts.openSans(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple,
                              style: BorderStyle.none,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu teléfono';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: _registerUser,
                        child: const Text(
                          'Registrarse',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        )),
                    const Text(
                      'O',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Container(
                      width: 305,
                      child: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(Colors.white),
                            shape: MaterialStatePropertyAll<OutlinedBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)))),
                            side: MaterialStatePropertyAll<BorderSide>(
                                BorderSide(
                                    width: 2.0, color: Colors.deepPurple)),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Registrarse Con Google',
                                style: GoogleFonts.openSans(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Image(
                                  image: AssetImage('assets/google.png')),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 40,
                        ),
                        Text(
                          'Ya tienes una Cuenta?',
                          style: GoogleFonts.openSans(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoginPage()));
                          },
                          child: Text(
                            'Inicia Sesión',
                            style: GoogleFonts.openSans(
                                fontSize: 17,
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    )
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
