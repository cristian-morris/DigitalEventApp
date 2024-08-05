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
