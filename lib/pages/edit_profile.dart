import 'package:digitalevent/pages/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PerfilEditar extends StatefulWidget {
  final Usuario usuario;

  const PerfilEditar({super.key, required this.usuario});

  @override
  _PerfilEditarState createState() => _PerfilEditarState();
}

class _PerfilEditarState extends State<PerfilEditar> {
  final _formKey = GlobalKey<FormState>();
  late String _nombre;
  late String _lastName;
  late String _email;
  late String _telefono;
  late String _fotoPerfil;

  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nombre = widget.usuario.nombre;
    _lastName = widget.usuario.lastName;
    _email = widget.usuario.email;
    _telefono = widget.usuario.telefono;
    _fotoPerfil = widget.usuario.fotoPerfil;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _fotoPerfil = pickedFile.path;
      });
    }
  }

  Future<void> _actualizarUsuario() async {
    final response = await http.put(
      Uri.parse(
          'https://api-digitalevent.onrender.com/api/users/${widget.usuario.usuarioId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'nombre': _nombre,
        'last_name': _lastName,
        'email': _email,
        'telefono': _telefono,
        'fotoPerfil': _fotoPerfil,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        widget.usuario.nombre = data['nombre'] ?? '';
        widget.usuario.lastName = data['last_name'] ?? '';
        widget.usuario.email = data['email'] ?? '';
        widget.usuario.telefono = data['telefono'] ?? '';
        widget.usuario.fotoPerfil = data['fotoPerfil'] ?? '';
      });
      Navigator.pop(context, true);
    } else {
      print('Failed to update user. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to update user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Perfil", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple,
                Colors.purple,
                Colors.purpleAccent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : (_fotoPerfil.isNotEmpty &&
                                  Uri.tryParse(_fotoPerfil)?.hasAbsolutePath ==
                                      true)
                              ? NetworkImage(_fotoPerfil)
                              : AssetImage('assets/images/R.png')
                                  as ImageProvider,
                      backgroundColor: Colors.grey,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              _buildTextFormField(
                'Nombre',
                _nombre,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce un nombre';
                  }
                  return null;
                },
                (value) {
                  _nombre = value;
                },
              ),
              SizedBox(height: 10.0),
              _buildTextFormField(
                'Apellido',
                _lastName,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce un apellido';
                  }
                  return null;
                },
                (value) {
                  _lastName = value;
                },
              ),
              SizedBox(height: 10.0),
              _buildTextFormField(
                'Correo Electrónico',
                _email,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce un correo electrónico';
                  }
                  return null;
                },
                (value) {
                  _email = value;
                },
              ),
              SizedBox(height: 10.0),
              _buildTextFormField(
                'Teléfono',
                _telefono,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce un número de teléfono';
                  }
                  return null;
                },
                (value) {
                  _telefono = value;
                },
              ),
              SizedBox(height: 20.0),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _actualizarUsuario();
                    }
                  },
                  child: Text('Guardar Cambios',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
    String label,
    String initialValue,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  ) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.deepPurple[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.deepPurple,
            width: 2.0,
          ),
        ),
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }
}
