// search_page.dart
import 'dart:convert';
import 'package:digitalevent/models/evento.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'event_detail_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<Evento> _eventos = [];
  List<Evento> _filteredEventos = [];
  bool _isLoading = false;
  List<String> _caracteristicas = ['Tecnología', 'Ciencia', 'Arte'];
  String? _selectedCaracteristica;

  @override
  void initState() {
    super.initState();
    _fetchEventos();
  }

  Future<void> _fetchEventos() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
        Uri.parse('https://api-digitalevent.onrender.com/api/eventos/events'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<Evento> eventos =
          jsonResponse.map((event) => Evento.fromJson(event)).toList();

      setState(() {
        _eventos = eventos;
        _filteredEventos = eventos;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load events');
    }
  }

  void _filterEventos(String query) {
    List<Evento> filteredEventos = _eventos.where((event) {
      return event.nombreEvento.toLowerCase().contains(query.toLowerCase()) &&
          (_selectedCaracteristica == null ||
              event.categoriaNombre == _selectedCaracteristica);
    }).toList();

    setState(() {
      _filteredEventos = filteredEventos;
    });
  }

  void _applyFilter(String? caracteristica) {
    List<Evento> filteredEventos = _eventos.where((event) {
      return (_searchController.text.isEmpty ||
              event.nombreEvento
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase())) &&
          (caracteristica == null || event.categoriaNombre == caracteristica);
    }).toList();

    setState(() {
      _selectedCaracteristica = caracteristica;
      _filteredEventos = filteredEventos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            _filterEventos(value);
          },
          decoration: InputDecoration(
            hintText: 'Buscar eventos...',
            border: InputBorder.none,
            fillColor: Colors.grey[200],
            filled: true,
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list, color: Colors.grey),
            onSelected: _applyFilter,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: null,
                  child: Text('Todas las características'),
                ),
                ..._caracteristicas.map((String caracteristica) {
                  return PopupMenuItem<String>(
                    value: caracteristica,
                    child: Text(caracteristica),
                  );
                }).toList(),
              ];
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _filteredEventos.isEmpty
              ? Center(child: Text('No hay eventos disponibles'))
              : ListView.builder(
                  padding: EdgeInsets.all(18.0),
                  itemCount: _filteredEventos.length,
                  itemBuilder: (context, index) {
                    Evento evento = _filteredEventos[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EventDetailPage(evento: evento),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(evento.imagenUrl,
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  evento.nombreEvento,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  '${evento.fechaInicio.toLocal()}'
                                      .split(' ')[0],
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
                      ),
                    );
                  },
                ),
    );
  }
}
