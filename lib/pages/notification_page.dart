import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Notificacion {
  final int notificacionid;
  final int usuarioid;
  final String mensaje;
  final String fechaenvio;

  Notificacion({
    required this.notificacionid,
    required this.usuarioid,
    required this.mensaje,
    required this.fechaenvio,
  });
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Future<List<Notificacion>> _notificacionesFuture;

  @override
  void initState() {
    super.initState();
    _notificacionesFuture = _getNoti();
  }

  Future<List<Notificacion>> _getNoti() async {
    var response = await http.get(
        Uri.https('api-digitalevent.onrender.com', '/api/notification/getAll'));
    var jsonData = jsonDecode(response.body) as List<dynamic>;

    List<Notificacion> notificaciones = jsonData
        .map((json) => Notificacion(
              notificacionid: json['notificacion_id'],
              usuarioid: json['usuario_id'],
              mensaje: json['mensaje'],
              fechaenvio: json['fecha_envio'],
            ))
        .toList();

    return notificaciones;
  }

  @override
  Widget build(BuildContext context) {
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
        elevation: 0,
        title: const Text(
          "Digital Event",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Notificacion>>(
        future: _notificacionesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los datos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay datos disponibles'));
          } else {
            List<Notificacion> notificaciones = snapshot.data!;

            return ListView.builder(
              itemCount: notificaciones.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 6.0),
                  child: Stack(
                    children: [
                      Container(
                        width: 342,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${notificaciones[index].mensaje}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800]),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Fecha: ${notificaciones[index].fechaenvio}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 14,
                          child: Text(
                            '${notificaciones[index].notificacionid}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
