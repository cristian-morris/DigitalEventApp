import 'dart:io';
import 'package:digitalevent/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditarPerfil extends StatefulWidget {
  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  final _formKey = GlobalKey<FormState>();
  String? _nombre;
  String? _apellido;
  String? _telefono;
  XFile? _fotoPerfil;

  // Future<void> _actualizarPerfil(String userId, String token) async {
  //   try {
  //     // 1. Actualizar los datos del usuario
  //     final url = 'https://api-digitalevent.onrender.com/api/users/$userId';
  //     final response = await http.put(
  //       Uri.parse(url),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: jsonEncode({
  //         'nombre': _nombre,
  //         'last_name': _apellido,
  //         'telefono': _telefono,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       print('Datos del usuario actualizados correctamente');

  //       // Actualizar el user en AuthProvider
  //       final updatedUser = jsonDecode(response.body);
  //       Provider.of<AuthProvider>(context, listen: false).setUser(updatedUser);
  //     } else {
  //       print(
  //           'Error al actualizar los datos del usuario: ${response.statusCode}');
  //     }

  //     // 2. Subir la imagen de perfil si se seleccionó una nueva
  //     if (_nuevaFotoPerfil != null) {
  //       final imageUploadUrl =
  //           'https://api-digitalevent.onrender.com/api/imagenes/upload/$userId';
  //       final request =
  //           http.MultipartRequest('POST', Uri.parse(imageUploadUrl));
  //       request.headers['Authorization'] = 'Bearer $token';

  //       request.files.add(await http.MultipartFile.fromPath(
  //         'imagen',
  //         _nuevaFotoPerfil!.path,
  //       ));

  //       final imageResponse = await request.send();

  //       if (imageResponse.statusCode == 200) {
  //         print('Imagen de perfil subida correctamente');
  //       } else {
  //         print(
  //             'Error al subir la imagen de perfil: ${imageResponse.statusCode}');
  //       }
  //     }
  //   } catch (e) {
  //     print('Error al actualizar el perfil: $e');
  //   }
  // }
  Future<void> _actualizarPerfil(String userId, String token) async {
    try {
      // 1. Actualizar los datos del usuario
      final url = 'https://api-digitalevent.onrender.com/api/users/$userId';
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'nombre': _nombre,
          'last_name': _apellido,
          'telefono': _telefono,
        }),
      );

      if (response.statusCode == 200) {
        print('Datos del usuario actualizados correctamente');

        // Actualizar el user en AuthProvider
        if (mounted) {
          final updatedUser = jsonDecode(response.body);
          Provider.of<AuthProvider>(context, listen: false)
              .setUser(updatedUser);

          // Actualizar el estado del widget
          setState(() {});
        }
      } else {
        print(
            'Error al actualizar los datos del usuario: ${response.statusCode}');
      }

      // 2. Subir la imagen de perfil si se seleccionó una nueva
      if (_fotoPerfil != null) {
        final imageUploadUrl =
            'https://api-digitalevent.onrender.com/api/imagenes/upload/$userId';
        final request =
            http.MultipartRequest('POST', Uri.parse(imageUploadUrl));
        request.headers['Authorization'] = 'Bearer $token';

        request.files.add(await http.MultipartFile.fromPath(
          'imagen',
          _fotoPerfil!.path,
        ));

        final imageResponse = await request.send();

        if (imageResponse.statusCode == 200) {
          print('Imagen de perfil subida correctamente');
        } else {
          print(
              'Error al subir la imagen de perfil: ${imageResponse.statusCode}');
        }
      }
    } catch (e) {
      print('Error al actualizar el perfil: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final token = authProvider
        .token; // Suponiendo que tienes el token disponible en AuthProvider
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Editar Perfil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final picker = ImagePicker();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    _fotoPerfil = pickedFile;
                  });
                },
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _fotoPerfil != null
                          ? FileImage(File(_fotoPerfil!.path))
                          : user?['fotoPerfil'] != null
                              ? NetworkImage(user?['fotoPerfil'])
                              : null,
                      child: _fotoPerfil == null && user?['fotoPerfil'] == null
                          ? Icon(Icons.person, size: 60, color: Colors.grey)
                          : null,
                    ),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: theme.colorScheme.primary,
                      child: Icon(
                        Icons.camera_alt,
                        size: 18,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              _buildTextField(
                label: 'Nombre',
                initialValue: user?['nombre'],
                icon: Icons.person,
                onSaved: (value) => _nombre = value,
              ),
              SizedBox(height: 20),
              _buildTextField(
                label: 'Apellido',
                initialValue: user?['last_name'],
                icon: Icons.person_outline,
                onSaved: (value) => _apellido = value,
              ),
              SizedBox(height: 20),
              _buildTextField(
                label: 'Teléfono',
                initialValue: user?['telefono'],
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                onSaved: (value) => _telefono = value,
              ),
              SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _actualizarPerfil(user!['usuario_id'].toString(), token!);
                    Navigator.pop(context, true);
                  }
                },
                icon: Icon(Icons.save),
                label: Text('Guardar Cambios'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String? initialValue,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required Function(String?) onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese su $label';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }
}
