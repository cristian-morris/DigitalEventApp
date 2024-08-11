import 'package:digitalevent/auth_provider.dart';
import 'package:digitalevent/pages/historial_pago.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PerfilVer extends StatefulWidget {
  const PerfilVer({super.key});

  @override
  State<PerfilVer> createState() => _PerfilVerState();
}

class _PerfilVerState extends State<PerfilVer> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(
          child: Text(
            'Mi cuenta',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: user == null
          ? Center(child: Text('No se ha iniciado sesión.'))
          : SingleChildScrollView(
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
                                        // Navegar a la página de edición de perfil
                                      },
                                      child: Container(
                                        width: 110.0,
                                        height: 110.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.white, width: 2.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              blurRadius: 10,
                                              offset: Offset(0, 5),
                                            ),
                                          ],
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                user['fotoPerfil']),
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
                                          // Navegar a la página de edición de perfil
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
                              '${user['nombre']} ${user['last_name']}',
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
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
                        _buildProfileInfoTile(Icons.person, 'Nombre',
                            '${user['nombre']} ${user['last_name']}'),
                        SizedBox(height: 10),
                        _buildProfileInfoTile(
                            Icons.email, 'Correo Electrónico', user['email']),
                        SizedBox(height: 10),
                        _buildProfileInfoTile(
                            Icons.phone, 'Teléfono', user['telefono']),
                        Divider(height: 30, thickness: 1),
                        _buildProfileActionTile(context, Icons.history,
                            'Historial de pagos', historialPago()),
                        SizedBox(height: 10),
                        _buildProfileActionTile(context, Icons.policy,
                            'Política de privacidad', null),
                        SizedBox(height: 10),
                        _buildProfileActionTile(
                            context, Icons.help, 'Centro de ayuda', null),
                        Divider(height: 30, thickness: 1),
                        _buildLogoutTile(context, authProvider),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  ListTile _buildProfileActionTile(
      BuildContext context, IconData icon, String title, Widget? page) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple[300]),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward, color: Colors.deepPurple[300]),
      tileColor: Colors.deepPurple[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
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
      title: Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
      trailing: Icon(Icons.arrow_forward, color: Colors.red),
      tileColor: Colors.red[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: () {
        authProvider.logout();
        Navigator.of(context).pushReplacementNamed('/login');
      },
    );
  }
}
