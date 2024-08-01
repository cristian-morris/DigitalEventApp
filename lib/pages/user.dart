import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // Para usar File
import 'package:image_picker/image_picker.dart'; // Para elegir imágenes

class Usuario {
  final int usuarioId;
  String nombre;
  String email;
  String telefono;
  String lastName;
  String fotoPerfil;

  Usuario({
    required this.usuarioId,
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.lastName,
    required this.fotoPerfil,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      usuarioId: json['usuario_id'] ?? 0,
      nombre: json['nombre'] ?? '',
      email: json['email'] ?? '',
      telefono: json['telefono'] ?? '',
      lastName: json['last_name'] ?? '',
      fotoPerfil: json['fotoPerfil'] ?? '',
    );
  }
}

class PerfilVer extends StatefulWidget {
  const PerfilVer({super.key});

  @override
  State<PerfilVer> createState() => _PerfilVerState();
}

class _PerfilVerState extends State<PerfilVer> {
  Usuario? _usuario;

  @override
  void initState() {
    super.initState();
    fetchUsuario();
  }

  Future<void> fetchUsuario() async {
    final response = await http.get(Uri.parse('https://api-digitalevent.onrender.com/api/users/3')); // Cambia el ID según sea necesario

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data); // Verifica la respuesta en la consola
      setState(() {
        _usuario = Usuario.fromJson(data);
      });
    } else {
      print('Failed to load user. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        title: Text(
          "Perfil",
          style: TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              if (_usuario != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PerfilEditar(usuario: _usuario!)),
                );
              }
            },
          ),
        ],
      ),
      body: _usuario == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  color: Colors.deepPurple[300],
                  width: double.infinity,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40.0,
                        backgroundImage: (_usuario!.fotoPerfil.isNotEmpty && Uri.tryParse(_usuario!.fotoPerfil)?.hasAbsolutePath == true)
                            ? NetworkImage(_usuario!.fotoPerfil)
                            : AssetImage('assets/images/R.png') as ImageProvider,
                        backgroundColor: Colors.grey,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Usuario: ${_usuario!.nombre} ${_usuario!.lastName}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: ListView(
                      children: [
                        ListTile(
                          leading: Icon(Icons.person, color: Colors.black),
                          title: Text('Nombre: ${_usuario!.nombre}'),
                          tileColor: Colors.purple,
                        ),
                        ListTile(
                          leading: Icon(Icons.person_outline, color: Colors.black),
                          title: Text('Apellido: ${_usuario!.lastName}'),
                          tileColor: Colors.purple,
                        ),
                        ListTile(
                          leading: Icon(Icons.email, color: Colors.black),
                          title: Text('Gmail: ${_usuario!.email}'),
                          tileColor: Colors.purple,
                        ),
                        ListTile(
                          leading: Icon(Icons.phone, color: Colors.black),
                          title: Text('Teléfono: ${_usuario!.telefono}'),
                          tileColor: Colors.purple,
                        ),
                        
                        ListTile(
                          title: Text('Historial de pagos'),
                          trailing: Icon(Icons.history, color: Colors.black),
                          tileColor: Colors.purple,
                          onTap: () {
                            // Navegar a la política de privacidad
                          },
                        ),
                        
                        ListTile(
                          title: Text('Política de privacidad'),
                          trailing: Icon(Icons.policy, color: Colors.black),
                          tileColor: Colors.purple,
                          onTap: () {
                            // Navegar a la política de privacidad
                          },
                        ),
                        ListTile(
                          title: Text('Centro de ayuda'),
                          trailing: Icon(Icons.help, color: Colors.black),
                          tileColor: Colors.purple,
                          onTap: () {
                            // Navegar al centro de ayuda
                          },
                        ),
                        ListTile(
                          title: Text('Cerrar sesión'),
                          trailing: Icon(Icons.exit_to_app, color: Colors.black),
                          tileColor: Colors.purple,
                          onTap: () {
                            // Manejar cierre de sesión
                          },
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
        _fotoPerfil = pickedFile.path; // Puedes subir el archivo o usarlo localmente
      });
    }
  }

  Future<void> _actualizarUsuario() async {
    final response = await http.put(
      Uri.parse('https://api-digitalevent.onrender.com/api/users/${widget.usuario.usuarioId}'),
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
      Navigator.pop(context, true); // Retorna true para indicar que se actualizaron los datos
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
        title: Text(
          "Editar Perfil",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Cambia el color de la flecha a blanco
        ),
        backgroundColor: Colors.deepPurple[300],
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
                      radius: 60.0,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : (_fotoPerfil.isNotEmpty && Uri.tryParse(_fotoPerfil)?.hasAbsolutePath == true)
                              ? NetworkImage(_fotoPerfil)
                              : AssetImage('assets/images/R.png') as ImageProvider,
                      backgroundColor: Colors.grey,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.camera_alt, color: Colors.white, size: 30),
                        onPressed: _pickImage,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                initialValue: _nombre,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce un nombre';
                  }
                  return null;
                },
                onChanged: (value) {
                  _nombre = value;
                },
              ),
              TextFormField(
                initialValue: _lastName,
                decoration: InputDecoration(labelText: 'Apellido'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce un apellido';
                  }
                  return null;
                },
                onChanged: (value) {
                  _lastName = value;
                },
              ),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(labelText: 'Correo Electrónico'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce un correo electrónico';
                  }
                  return null;
                },
                onChanged: (value) {
                  _email = value;
                },
              ),
              TextFormField(
                initialValue: _telefono,
                decoration: InputDecoration(labelText: 'Teléfono'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce un número de teléfono';
                  }
                  return null;
                },
                onChanged: (value) {
                  _telefono = value;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _actualizarUsuario();
                  }
                },
                child: Text(
                  'Guardar Cambios',
                  style: TextStyle(color: Colors.white), // Cambia el color del texto a blanco
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[300], // Cambia el color de fondo del botón si es necesario
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
