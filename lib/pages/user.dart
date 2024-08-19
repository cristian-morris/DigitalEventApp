import 'package:digitalevent/auth_provider.dart';
import 'package:digitalevent/pages/edit_profile.dart';
import 'package:digitalevent/pages/historial_pago.dart';
import 'package:digitalevent/view/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PerfilVer extends StatefulWidget {
  const PerfilVer({super.key});

  @override
  State<PerfilVer> createState() => _PerfilVerState();
}

class _PerfilVerState extends State<PerfilVer> {
  double _scrollOffset = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final theme = Theme.of(context);

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
                      // theme.colorScheme.primary,
                      // theme.colorScheme.secondary,
                      // theme.colorScheme.tertiary,
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
              color: theme.colorScheme.onPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: user == null
          ? Center(child: Text('No se ha iniciado sesión.'))
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
                                // theme.colorScheme.primary,
                                // theme.colorScheme.secondary,
                                // theme.colorScheme.tertiary,
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
                                        onTap: () {},
                                        child: Container(
                                          width: 110.0,
                                          height: 110.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color:
                                                    theme.colorScheme.onPrimary,
                                                width: 2.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                                blurRadius: 10,
                                                offset: Offset(0, 5),
                                              ),
                                            ],
                                            image: user['fotoPerfil'] != null
                                                ? DecorationImage(
                                                    image: NetworkImage(
                                                        user['fotoPerfil']),
                                                    fit: BoxFit.cover,
                                                  )
                                                : null,
                                          ),
                                          child: user['fotoPerfil'] == null
                                              ? Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            9.0),
                                                    child: Text(
                                                      "Sin foto de perfil",
                                                      style: TextStyle(
                                                          color: theme
                                                              .colorScheme
                                                              .onPrimary),
                                                    ),
                                                  ),
                                                )
                                              : null,
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: GestureDetector(
                                          onTap: () async {
                                            // Navegar a la página de edición de perfil
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditarPerfil(),
                                              ),
                                            ).then((_) {
                                              // Actualizar el estado cuando vuelvas de la página de edición
                                              setState(() {});
                                            });
                                          },
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color:
                                                  theme.colorScheme.onPrimary,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: theme
                                                    .colorScheme.onSecondary,
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
                                  color: theme.colorScheme.onPrimary,
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
                      color: theme.colorScheme.background,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      child: Column(
                        children: [
                          _buildProfileInfoTile(Icons.person, 'Nombre',
                              '${user['nombre']} ${user['last_name']}', theme),
                          SizedBox(height: 10),
                          _buildProfileInfoTile(Icons.email,
                              'Correo Electrónico', user['email'], theme),
                          SizedBox(height: 10),
                          _buildProfileInfoTile(
                              Icons.phone, 'Teléfono', user['telefono'], theme),
                          Divider(height: 30, thickness: 1),
                          _buildThemeSwitchTile(context, theme),
                          Divider(height: 30, thickness: 1),
                          _buildProfileActionTile(context, Icons.history,
                              'Historial de pagos', historialPago(), theme),
                          SizedBox(height: 10),
                          _buildProfileActionTile(context, Icons.policy,
                              'Política de privacidad', null, theme),
                          SizedBox(height: 10),
                          _buildProfileActionTile(context, Icons.help,
                              'Centro de ayuda', null, theme),
                          Divider(height: 30, thickness: 1),
                          _buildLogoutTile(context, authProvider, theme),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  ListTile _buildProfileInfoTile(
      IconData icon, String title, String subtitle, ThemeData theme) {
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title:
          Text(title, style: TextStyle(color: theme.colorScheme.onBackground)),
      subtitle:
          Text(subtitle, style: TextStyle(color: theme.colorScheme.onSurface)),
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      tileColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  ListTile _buildProfileActionTile(BuildContext context, IconData icon,
      String title, Widget? page, ThemeData theme) {
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title:
          Text(title, style: TextStyle(color: theme.colorScheme.onBackground)),
      trailing: Icon(Icons.arrow_forward, color: theme.colorScheme.primary),
      tileColor: theme.colorScheme.surface,
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

  ListTile _buildLogoutTile(
      BuildContext context, AuthProvider authProvider, ThemeData theme) {
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

  ListTile _buildThemeSwitchTile(BuildContext context, ThemeData theme) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return ListTile(
      leading: Icon(Icons.dark_mode, color: theme.colorScheme.primary),
      title: Text('Modo oscuro',
          style: TextStyle(color: theme.colorScheme.onSurface)),
      trailing: Switch(
        value: themeProvider.isDarkMode,
        onChanged: (value) {
          themeProvider.toggleTheme();
        },
        activeColor: theme.colorScheme.primary,
      ),
      tileColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
