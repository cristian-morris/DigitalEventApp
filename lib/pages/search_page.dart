import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'event_detail_page.dart';
import 'package:digitalevent/models/evento.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<Evento> _eventos = [];
  List<Evento> _filteredEventos = [];
  bool _isLoading = false;
  List<String> _caracteristicas = [
    'Tecnología',
    'Deportes',
    'Entretenimiento',
    'Educación'
  ];
  List<String> _tiposEvento = ['Publico', 'Privado'];
  String? _selectedCaracteristica;
  String? _selectedTipo;
  RangeValues _priceRange = RangeValues(0, 1000);

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

  void _applyFilter({
    String? caracteristica,
    String? tipoEvento,
    RangeValues? priceRange,
  }) {
    List<Evento> filteredEventos = _eventos.where((event) {
      final matchesNombre = _searchController.text.isEmpty ||
          event.eventoNombre
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
      final matchesCategoria =
          caracteristica == null || event.categoria == caracteristica;
      final matchesTipoEvento =
          tipoEvento == null || event.tipoEvento == tipoEvento;
      final matchesMonto = priceRange == null ||
          (event.monto != null &&
              double.tryParse(event.monto!) != null &&
              double.parse(event.monto!) >= priceRange.start &&
              double.parse(event.monto!) <= priceRange.end);

      return matchesNombre &&
          matchesCategoria &&
          matchesTipoEvento &&
          matchesMonto;
    }).toList();

    setState(() {
      _selectedCaracteristica = caracteristica;
      _selectedTipo = tipoEvento;
      _filteredEventos = filteredEventos;
      _priceRange = priceRange ?? _priceRange;
    });
  }

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: 600,
            height: 600,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                Text(
                  "Selecciona Características",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 7.0,
                  runSpacing: 4.0,
                  children: _caracteristicas.map((String caracteristica) {
                    return ChoiceChip(
                      label: Text(caracteristica),
                      selected: _selectedCaracteristica == caracteristica,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedCaracteristica =
                              selected ? caracteristica : null;
                        });
                        _applyFilter(
                            caracteristica: selected ? caracteristica : null);
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Text(
                  "Selecciona Tipo de Evento",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 7.0,
                  runSpacing: 4.0,
                  children: _tiposEvento.map((String tipo) {
                    return ChoiceChip(
                      label: Text(tipo),
                      selected: _selectedTipo == tipo,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedTipo = selected ? tipo : null;
                        });
                        _applyFilter(tipoEvento: selected ? tipo : null);
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Text(
                  "Selecciona Rango de Precio",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 7.0,
                  children: [
                    ChoiceChip(
                      label: Text('0 - 50'),
                      selected: _priceRange.start == 0 && _priceRange.end == 50,
                      onSelected: (bool selected) {
                        setState(() {
                          _priceRange = RangeValues(0, 50);
                        });
                        _applyFilter(priceRange: _priceRange);
                      },
                    ),
                    ChoiceChip(
                      label: Text('50 - 100'),
                      selected:
                          _priceRange.start == 50 && _priceRange.end == 100,
                      onSelected: (bool selected) {
                        setState(() {
                          _priceRange = RangeValues(50, 100);
                        });
                        _applyFilter(priceRange: _priceRange);
                      },
                    ),
                    ChoiceChip(
                      label: Text('100 - 500'),
                      selected:
                          _priceRange.start == 100 && _priceRange.end == 500,
                      onSelected: (bool selected) {
                        setState(() {
                          _priceRange = RangeValues(100, 500);
                        });
                        _applyFilter(priceRange: _priceRange);
                      },
                    ),
                    ChoiceChip(
                      label: Text('500 - 1000'),
                      selected:
                          _priceRange.start == 500 && _priceRange.end == 1000,
                      onSelected: (bool selected) {
                        setState(() {
                          _priceRange = RangeValues(500, 1000);
                        });
                        _applyFilter(priceRange: _priceRange);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
            _applyFilter();
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
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.grey),
            onPressed: _openFilterModal,
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
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
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
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.place,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      evento.ubicacion,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (evento.monto != null)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.attach_money_outlined,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '${evento.monto}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
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
