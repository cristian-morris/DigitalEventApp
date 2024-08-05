import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// lib/models/evento.dart
class Evento {
  final int eventoId;
  final String nombreEvento;
  final DateTime fechaInicio;
  final DateTime fechaTermino;
  final String hora;
  final String ubicacion;
  final int maxPer;
  final String estado;
  final DateTime fechaAutorizacion;
  final String tipoEvento;
  final String organizadorNombre;
  final String autorizadoNombre;
  final String categoriaNombre;
  final String imagenUrl;

  Evento({
    required this.eventoId,
    required this.nombreEvento,
    required this.fechaInicio,
    required this.fechaTermino,
    required this.hora,
    required this.ubicacion,
    required this.maxPer,
    required this.estado,
    required this.fechaAutorizacion,
    required this.tipoEvento,
    required this.organizadorNombre,
    required this.autorizadoNombre,
    required this.categoriaNombre,
    required this.imagenUrl,
  });

  
}

class RecentEventPage extends StatefulWidget {
  
  const RecentEventPage({super.key});

  @override
  State<RecentEventPage> createState() => _RecentEventPageState();
}

class _RecentEventPageState extends State<RecentEventPage> {
late Future<List<Evento>> _notificacionesFuture; // Futuro para almacenar la lista de pagos

  @override
  void initState() {
    super.initState();
    _notificacionesFuture = _getNoti(); // Inicializa el futuro con la función que obtiene los pagos
  }

  Future<List<Evento>> _getNoti() async {
    var response = await http.get(Uri.https('api-digitalevent.onrender.com', '/api/eventos/events')); 
    var jsonData = jsonDecode(response.body) as List<dynamic>;

    List<Evento> notificaciones = jsonData.map((json) => Evento(
      eventoId: json['evento_id'],
      nombreEvento: json['nombre_evento'],
      fechaInicio: DateTime.parse(json['fecha_inicio']),
      fechaTermino: DateTime.parse(json['fecha_termino']),
      hora: json['hora'],
      ubicacion: json['ubicacion'],
      maxPer: json['max_per'],
      estado: json['estado'],
      fechaAutorizacion: DateTime.parse(json['fecha_autorizacion']),
      tipoEvento: json['tipo_evento'],
      organizadorNombre: json['organizador_nombre'],
      autorizadoNombre: json['autorizado_nombre'],
      categoriaNombre: json['categoria_nombre'],
      imagenUrl: json['imagen_url'],
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
      body: FutureBuilder<List<Evento>>(
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
            List<Evento> notificaciones = snapshot.data!;

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
                      Image.network(
                        notificaciones[index].imagenUrl,
                         height: 100,
                         width: double.infinity,
                          fit: BoxFit.cover,
                          ),
                          Text("Notificacion id: ${notificaciones[index].nombreEvento}"),
                          SizedBox(height: 8),
                          Text("usuario id: ${notificaciones[index].categoriaNombre}"),
                          SizedBox(height: 8),
                          Text("Descripcion: ${notificaciones[index].estado}"),
                          SizedBox(height: 8),
                          Text("fecha: ${notificaciones[index].maxPer}"),
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