import 'package:digitalevent/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ComentariosSection extends StatefulWidget {
  final int eventoId;

  const ComentariosSection({Key? key, required this.eventoId})
      : super(key: key);

  @override
  _ComentariosSectionState createState() => _ComentariosSectionState();
}

class _ComentariosSectionState extends State<ComentariosSection> {
  List<Comentario> comentarios = [];
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchComentarios();
  }

  Future<void> _fetchComentarios() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(
        'https://api-digitalevent.onrender.com/api/comentario/list/${widget.eventoId}'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        comentarios = data.map((json) => Comentario.fromJson(json)).toList();
      });
    } else {
      // Handle error
      print('Error fetching comments');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _addComentario(String comentario) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Verifica si el usuario está autenticado
    if (!authProvider.isAuth) {
      print('User not authenticated. Please log in again.');
      return;
    }

    final userId = authProvider.user?['usuario_id']; // Obtén el ID del usuario

    if (userId == null) {
      print('User ID not found. Please log in again.');
      return;
    }

    try {
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(now);

      final response = await http.post(
        Uri.parse(
            'https://api-digitalevent.onrender.com/api/comentario/create'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'evento_id': widget.eventoId,
          'usuario_id': userId,
          'comentario': comentario,
          'fecha': formattedDate,
        }),
      );

      if (response.statusCode == 201) {
        _controller.clear();
        _fetchComentarios();
      } else {
        final responseData = json.decode(response.body);
        print('Error adding comment: ${responseData['message']}');
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error sending comment: $error');
    }
  }

  Future<void> _deleteComentario(int comentarioId) async {
    final response = await http.delete(
      Uri.parse(
          'https://api-digitalevent.onrender.com/api/comentario/delete/$comentarioId'),
    );

    if (response.statusCode == 200) {
      _fetchComentarios();
    } else {
      // Handle error
      print('Error deleting comment');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Comentarios',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: comentarios.length,
            itemBuilder: (context, index) {
              final comentario = comentarios[index];
              return ListTile(
                title: Text(comentario.comentario),
                subtitle: Text('Por ${comentario.usuarioNombre}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteComentario(comentario.comentarioId),
                ),
              );
            },
          ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Añadir un comentario',
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  _addComentario(_controller.text);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

class Comentario {
  final int comentarioId;
  final int usuarioId;
  final int eventoId;
  final String comentario;
  final DateTime fecha;
  final String usuarioNombre;

  Comentario({
    required this.comentarioId,
    required this.usuarioId,
    required this.eventoId,
    required this.comentario,
    required this.fecha,
    required this.usuarioNombre,
  });

  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      comentarioId: json['comentario_id'],
      usuarioId: json['usuario_id'],
      eventoId: json['evento_id'],
      comentario: json['comentario'],
      fecha: DateTime.parse(json['fecha']),
      usuarioNombre: json['usuario_nombre'],
    );
  }
}
