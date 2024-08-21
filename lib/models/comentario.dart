class Comentario {
  final int comentarioId;
  final int usuarioId;
  final int eventoId;
  final String comentario;
  final DateTime fecha;
  final String usuarioNombre;
  String? fotoPerfil;

  Comentario({
    required this.comentarioId,
    required this.usuarioId,
    required this.eventoId,
    required this.comentario,
    required this.fecha,
    required this.usuarioNombre,
    this.fotoPerfil,
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
