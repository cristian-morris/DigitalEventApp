class Evento {
  final int eventoId;
  final String eventoNombre;
  final DateTime fechaInicio;
  final DateTime fechaTermino;
  final String hora;
  final String tipoEvento;
  final String categoria;
  final String ubicacion;
  final int maxPer;
  final String estado;
  final int? autorizadoPor;
  final DateTime? fechaAutorizacion;
  final int? validacionId;
  final String? imagenUrl;
  final String? monto;
  final String? formaEscenario;
  final String? descripcion;
  // final List<Comentario> comentarios;

  Evento({
    required this.eventoId,
    required this.eventoNombre,
    required this.fechaInicio,
    required this.fechaTermino,
    required this.hora,
    required this.tipoEvento,
    required this.categoria,
    required this.ubicacion,
    required this.maxPer,
    required this.estado,
    this.autorizadoPor,
    this.fechaAutorizacion,
    this.validacionId,
    this.imagenUrl,
    this.monto,
    this.formaEscenario,
    this.descripcion,
    // required this.comentarios,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      eventoId: json['evento_id'],
      eventoNombre: json['evento_nombre'],
      fechaInicio: DateTime.parse(json['fecha_inicio']),
      fechaTermino: DateTime.parse(json['fecha_termino']),
      hora: json['hora'],
      tipoEvento: json['tipo_evento'],
      categoria: json['categoria'],
      ubicacion: json['ubicacion'],
      maxPer: json['max_per'],
      estado: json['estado'],
      autorizadoPor: json['autorizado_por'],
      fechaAutorizacion: json['fecha_autorizacion'] != null
          ? DateTime.parse(json['fecha_autorizacion'])
          : null,
      validacionId: json['validacion_id'],
      imagenUrl: json['imagen_url'],
      monto: json['monto'],
      formaEscenario: json['forma_escenario'],
      descripcion: json['descripcion'],
      // comentarios: (json['comentarios'] as List)
      //     .map((data) => Comentario.fromJson(data))
      //     .toList(),
    );
  }
}

// class Comentario {
//   final int comentarioId;
//   final int usuarioId;
//   final int eventoId;
//   final String comentario;
//   final DateTime fecha;
//   final String usuarioNombre;

//   Comentario({
//     required this.comentarioId,
//     required this.usuarioId,
//     required this.eventoId,
//     required this.comentario,
//     required this.fecha,
//     required this.usuarioNombre,
//   });

//   factory Comentario.fromJson(Map<String, dynamic> json) {
//     return Comentario(
//         comentarioId: json['comentario_id'],
//         usuarioId: json['usuario_id'],
//         eventoId: json['evento_id'],
//         comentario: json['comentario'],
//         fecha: DateTime.parse(json['fecha']),
//         usuarioNombre: json['usuario_nombre']);
//   }
// }
