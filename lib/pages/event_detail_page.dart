// event_detail_page.dart
import 'package:digitalevent/models/evento.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetailPage extends StatelessWidget {
  final Evento evento;

  EventDetailPage({required this.evento});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(evento.nombreEvento),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(evento.imagenUrl,
                height: 200, width: double.infinity, fit: BoxFit.cover),
            SizedBox(height: 8),
            Text(evento.nombreEvento,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(DateFormat('yyyy-MM-dd – kk:mm').format(evento.fechaInicio),
                style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            Text(evento.ubicacion, style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            Text('Detalles del Evento',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Tipo de Evento: ${evento.tipoEvento}'),
            Text('Organizado por: ${evento.organizadorNombre}'),
            Text('Categoría: ${evento.categoriaNombre}'),
            Text('Estado: ${evento.estado}'),
            Text(
                'Fecha de Autorización: ${DateFormat('yyyy-MM-dd').format(evento.fechaAutorizacion)}'),
            // Agrega más detalles según sea necesario.
          ],
        ),
      ),
    );
  }
}
