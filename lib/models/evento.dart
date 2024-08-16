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
    );
  }
}
