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
 late Future<List<Notificacion>> _notificacionesFuture; // Futuro para almacenar la lista de pagos

  @override
  void initState() {
    super.initState();
    _notificacionesFuture = _getNoti(); // Inicializa el futuro con la función que obtiene los pagos
  }

  Future<List<Notificacion>> _getNoti() async {
    var response = await http.get(Uri.https('api-digitalevent.onrender.com', '/api/notification/getAll')); 
    var jsonData = jsonDecode(response.body) as List<dynamic>;

    List<Notificacion> notificaciones = jsonData.map((json) => Notificacion(
      notificacionid: json['notificacion_id'],
      usuarioid: json['usuario_id'],
      mensaje: json['mensaje'],
      fechaenvio: json['fecha_envio'],
    )).toList();

    return notificaciones;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        elevation: 0,
        title: Text("Digital Event", textAlign: TextAlign.center,),
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
            // Datos disponibles
            List<Notificacion> notificaciones = snapshot.data!;

            return ListView.builder(
              itemCount: notificaciones.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Notificacion id: ${notificaciones[index].notificacionid}"),
                          SizedBox(height: 8),
                          Text("usuario id: ${notificaciones[index].usuarioid}"),
                          SizedBox(height: 8),
                          Text("Descripcion: ${notificaciones[index].mensaje}"),
                          SizedBox(height: 8),
                          Text("fecha: ${notificaciones[index].fechaenvio}"),
                        ],
                      ),
                    ),
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