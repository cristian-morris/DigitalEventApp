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

  String? selectedRole;
  String? selectedMembership;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

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
        'rol_id': selectedRole,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    // Aquí asumimos que el servidor devuelve un JSON en el cuerpo de la respuesta
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 201 || responseData['message'] == 'User created successfully') {
       ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Registrado, por favor ve a login")));
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
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/login.png'),
                fit: BoxFit.cover,
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
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Crea tu cuenta ahora mismo',
                      style:
                          GoogleFonts.roboto(color: Colors.white, fontSize: 17),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: 310,
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(225, 185, 166, 224),
                          labelText: 'Nombre:',
                          labelStyle: GoogleFonts.openSans(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w700),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
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
                          filled: true,
                          fillColor: const Color.fromARGB(225, 185, 166, 224),
                          labelText: 'Apellido:',
                          labelStyle: GoogleFonts.openSans(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple,
                              style: BorderStyle.solid,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
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
                          filled: true,
                          fillColor: const Color.fromARGB(225, 185, 166, 224),
                          labelText: 'Correo Electrónico:',
                          labelStyle: GoogleFonts.openSans(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple,
                              style: BorderStyle.solid,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
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
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(225, 185, 166, 224),
                          labelText: 'Contraseña:',
                          labelStyle: GoogleFonts.openSans(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple,
                              style: BorderStyle.solid,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
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
                          filled: true,
                          fillColor: const Color.fromARGB(225, 185, 166, 224),
                          labelText: 'Teléfono:',
                          labelStyle: GoogleFonts.openSans(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple,
                              style: BorderStyle.solid,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
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
                    Container(
                      width: 310,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(225, 185, 166, 224),
                          labelText: 'Rol:',
                          labelStyle: GoogleFonts.openSans(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple,
                              style: BorderStyle.solid,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                        value: selectedRole,
                        items: const [
                          DropdownMenuItem(
                              value: '2', child: Text('Organizador')),
                          DropdownMenuItem(value: '3', child: Text('Cliente')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor selecciona un rol';
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
                                builder: (context) =>  LoginPage()));
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
