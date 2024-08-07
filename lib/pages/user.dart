import 'package:digitalevent/auth_provider.dart';
import 'package:digitalevent/pages/edit_profile.dart';
import 'package:digitalevent/pages/historial_pago.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

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
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    fetchUsuario();
  }

  Future<void> fetchUsuario() async {
    final response = await http
        .get(Uri.parse('https://api-digitalevent.onrender.com/api/users/3'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
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
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: _scrollOffset > 200
                ? LinearGradient(
                    colors: [
                      Colors.deepPurple,
                      Colors.purple,
                      Colors.purpleAccent
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: _scrollOffset > 200 ? 1.0 : 0.0,
          child: Text(
            'Mi cuenta',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: _usuario == null
          ? Center(child: CircularProgressIndicator())
          : NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollUpdateNotification) {
                  setState(() {
                    _scrollOffset = scrollNotification.metrics.pixels;
                  });
                }
                return true;
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.deepPurple,
                                Colors.purple,
                                Colors.purpleAccent
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          width: double.infinity,
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              SizedBox(height: 70),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (_usuario != null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PerfilEditar(
                                                          usuario: _usuario!)),
                                            );
                                          }
                                        },
                                        child: Container(
                                          width: 110.0,
                                          height: 110.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.black,
                                                width: 1.3),
                                            image: DecorationImage(
                                              image: (_usuario!.fotoPerfil
                                                          .isNotEmpty &&
                                                      Uri.tryParse(_usuario!
                                                                  .fotoPerfil)
                                                              ?.hasAbsolutePath ==
                                                          true)
                                                  ? NetworkImage(
                                                      _usuario!.fotoPerfil)
                                                  : AssetImage(
                                                          'assets/images/R.png')
                                                      as ImageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (_usuario != null) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PerfilEditar(
                                                            usuario:
                                                                _usuario!)),
                                              );
                                            }
                                          },
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
                                              Icons.edit_outlined,
                                              size: 15,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                '${_usuario!.nombre} ${_usuario!.lastName}',
                                style: TextStyle(
                                    fontSize: 22.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      child: Column(
                        children: [
                          _buildProfileInfoTile(
                              Icons.person, 'Nombre', _usuario!.nombre),
                          _buildProfileInfoTile(Icons.person_outline,
                              'Apellido', _usuario!.lastName),
                          _buildProfileInfoTile(Icons.email,
                              'Correo Electrónico', _usuario!.email),
                          _buildProfileInfoTile(
                              Icons.phone, 'Teléfono', _usuario!.telefono),
                          Divider(height: 20, thickness: 1),
                          _buildProfileActionTile(context, Icons.history,
                              'Historial de pagos', historialPago()),
                          _buildProfileActionTile(context, Icons.policy,
                              'Política de privacidad', null),
                          _buildProfileActionTile(
                              context, Icons.help, 'Centro de ayuda', null),
                          _buildLogoutTile(context, authProvider),
                          Divider(height: 20, thickness: 1),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  ListTile _buildProfileInfoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple[300]),
      title: Text(title),
      subtitle: Text(subtitle),
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      tileColor: Colors.deepPurple[50],
    );
  }

  ListTile _buildProfileActionTile(
      BuildContext context, IconData icon, String title, Widget? page) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple[300]),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward, color: Colors.deepPurple[300]),
      tileColor: Colors.deepPurple[50],
      onTap: page != null
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
            }
          : null,
    );
  }

  ListTile _buildLogoutTile(BuildContext context, AuthProvider authProvider) {
    return ListTile(
      leading: Icon(Icons.exit_to_app, color: Colors.red),
      title: Text('Cerrar sesión'),
      trailing: Icon(Icons.arrow_forward, color: Colors.red),
      tileColor: Colors.deepPurple[50],
      onTap: () {
        authProvider.logout();
      },
    );
  }
}
