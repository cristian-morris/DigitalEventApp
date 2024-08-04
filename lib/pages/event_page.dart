import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'search_page.dart';

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

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
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
    );
  }
}

Future<List<Evento>> fetchEventos() async {
  final response = await http.get(
      Uri.parse('https://api-digitalevent.onrender.com/api/eventos/events'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((event) => Evento.fromJson(event)).toList();
  } else {
    throw Exception('Failed to load events');
  }
}

class EventosPage extends StatefulWidget {
  @override
  _EventosPageState createState() => _EventosPageState();
}

class _EventosPageState extends State<EventosPage> {
  late Future<List<Evento>> futureEventos;

  @override
  void initState() {
    super.initState();
    futureEventos = fetchEventos();
  }

  void _navigateToSearchPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[400],
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  onTap: _navigateToSearchPage,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Buscar',
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Evento>>(
        future: futureEventos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay eventos disponibles'));
          } else {
            List<Evento> eventos = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Eventos Públicos',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 250.0,
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      enableInfiniteScroll: true,
                      viewportFraction: 0.8,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                    ),
                    items: eventos.map((event) {
                      return Builder(
                        builder: (BuildContext context) {
                          return SizedBox(
                            height: 250,
                            child: EventoCard(evento: event),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Eventos Privados',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 250.0,
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      enableInfiniteScroll: true,
                      viewportFraction: 0.8,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                    ),
                    items: eventos.map((event) {
                      return Builder(
                        builder: (BuildContext context) {
                          return SizedBox(
                            height: 250,
                            child: EventoCard(evento: event),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class EventoCard extends StatelessWidget {
  final Evento evento;

  EventoCard({required this.evento});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(evento.imagenUrl,
                height: 100, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                evento.nombreEvento,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '${evento.fechaInicio.toLocal()}'.split(' ')[0],
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                evento.ubicacion,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
