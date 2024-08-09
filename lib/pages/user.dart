import 'package:digitalevent/auth_provider.dart';
import 'package:digitalevent/pages/edit_profile.dart';
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
        body: Center(
        child: user == null
            ? Text('No se ha iniciado sesión.')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(user['fotoPerfil'], width: double.infinity, height: 200.0,),
                  Text('User ID: ${user['usuario_id']}'),
                  Text('nombre: ${user['nombre']} ${user['last_name']}'),
                  Text('Email: ${user['email']}'),
                  Text('telefono: ${user['telefono']}'),
                   ElevatedButton(
                    onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => historialPago(),));
                    },
                    child: Text('historial pago'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authProvider.logout();
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    child: Text('Cerrar sesión'),
                  ),
                ],
              ),
      ),
    );
  }
}
