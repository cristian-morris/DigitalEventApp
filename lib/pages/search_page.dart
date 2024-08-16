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
        Uri.parse('https://api-digitalevent.onrender.com/api/events/get/img'));

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
      return event.eventoNombre.toLowerCase().contains(query.toLowerCase()) &&
          (_selectedCaracteristica == null ||
              event.categoria == _selectedCaracteristica);
    }).toList();

    setState(() {
      _filteredEventos = filteredEventos;
    });
  }

  void _applyFilter(String? caracteristica) {
    List<Evento> filteredEventos = _eventos.where((event) {
      return (_searchController.text.isEmpty ||
              event.eventoNombre
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase())) &&
          (caracteristica == null || event.categoria == caracteristica);
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
        toolbarHeight: 74,
        title: TextField(
          cursorWidth: 1,
          controller: _searchController,
          onChanged: (value) {
            _filterEventos(value);
          },
          decoration: InputDecoration(
            hintText: 'Buscar eventos...',
            border: InputBorder.none,
            filled: true,
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Colors.purpleAccent,
              ),
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
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.purpleAccent,
              ),
            )
          : _filteredEventos.isEmpty
              ? Center(
                  child: Text(
                    'No hay eventos disponibles',
                    style: TextStyle(color: Colors.purpleAccent),
                  ),
                )
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
                        elevation: 5,
                        shadowColor: Colors.black38,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Image.network(
                                    evento.imagenUrl ?? 'default_image_url',
                                    height: 145,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Image.asset(
                                        'assets/cancelar.png',
                                        height: 145,
                                        width: double.infinity,
                                      );
                                    },
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    left: 0,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                        color: Colors.purple,
                                        borderRadius: BorderRadius.horizontal(
                                          left: Radius.zero,
                                          right: Radius.elliptical(50.0, 20.0),
                                        ),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          evento.categoria,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 10.0,
                                                color: Colors.black26,
                                                offset: Offset(2.0, 2.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  evento.eventoNombre,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.date_range,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '${evento.fechaInicio.toLocal()}'
                                          .split(' ')[0],
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        evento.ubicacion,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
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
