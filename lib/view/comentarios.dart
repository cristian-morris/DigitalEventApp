import 'package:digitalevent/auth_provider.dart';
import 'package:digitalevent/models/comentario.dart';
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
      final fetchedComentarios =
          data.map((json) => Comentario.fromJson(json)).toList();

      for (Comentario comentario in fetchedComentarios) {
        await _fetchUserProfile(comentario);
      }

      setState(() {
        comentarios = fetchedComentarios;
      });
    } else {
      print('Error fetching comments');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchUserProfile(Comentario comentario) async {
    final response = await http.get(Uri.parse(
        'https://api-digitalevent.onrender.com/api/users/${comentario.usuarioId}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      comentario.fotoPerfil = data['fotoPerfil'];
    } else {
      print('Error fetching user profile for user ${comentario.usuarioId}');
    }
  }

  Future<void> _addComentario(String comentario) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isAuth) {
      print('User not authenticated. Please log in again.');
      return;
    }

    final userId = authProvider.user?['usuario_id'];

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
      print('Error deleting comment');
    }
  }

  void _showDeleteConfirmationDialog(int comentarioId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar comentario'),
          content: const Text(
              '¿Estás seguro de que quieres eliminar este comentario?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                _deleteComentario(comentarioId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.user?['usuario_id'];
    final userProfileImageUrl = authProvider.user?['fotoPerfil'];

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
              final isCurrentUser = comentario.usuarioId == userId;

              return GestureDetector(
                onLongPress: isCurrentUser
                    ? () =>
                        _showDeleteConfirmationDialog(comentario.comentarioId)
                    : null,
                child: Row(
                    mainAxisAlignment: isCurrentUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      if (!isCurrentUser) ...[
                        CircleAvatar(
                          backgroundImage: comentario.fotoPerfil != null
                              ? NetworkImage(comentario.fotoPerfil!)
                              : AssetImage('assets/default_profile.png')
                                  as ImageProvider,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        decoration: BoxDecoration(
                          color: isCurrentUser
                              ? Colors.blueAccent.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comentario.usuarioNombre,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isCurrentUser
                                    ? Colors.blueAccent
                                    : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(comentario.comentario),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('dd/MM/yyyy HH:mm')
                                  .format(comentario.fecha),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isCurrentUser) ...[
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundImage: userProfileImageUrl != null
                              ? NetworkImage(userProfileImageUrl)
                              : AssetImage('assets/cancelar.png'),
                        ),
                      ]
                    ]),
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
