import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentHistory {
  final int pagoId;
  final String monto;
  final DateTime? fecha;
  final int? tipoPagoId;
  final int? usuarioId;
  final int eventoId;
  final DateTime? fInicioEp;
  final DateTime? fFinEp;
  final String? numeroTarjeta;
  final DateTime? fechaExpiracion;

  PaymentHistory({
    required this.pagoId,
    required this.monto,
    this.fecha,
    this.tipoPagoId,
    this.usuarioId,
    required this.eventoId,
    this.fInicioEp,
    this.fFinEp,
    this.numeroTarjeta,
    this.fechaExpiracion,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      pagoId: json['pago_id'] as int? ?? 0,
      monto: json['monto'] as String? ?? '0.00',
      fecha: json['fecha'] != null ? DateTime.tryParse(json['fecha']) : null,
      tipoPagoId: json['tipo_pago_id'] as int?,
      usuarioId: json['usuario_id'] as int?,
      eventoId: json['evento_id'] as int? ?? 0,
      fInicioEp: json['f_inicio_ep'] != null
          ? DateTime.tryParse(json['f_inicio_ep'])
          : null,
      fFinEp:
          json['f_FIN_ep'] != null ? DateTime.tryParse(json['f_FIN_ep']) : null,
      numeroTarjeta: json['numero_tarjeta'] as String?,
      fechaExpiracion: json['fecha_expiracion'] != null
          ? DateTime.tryParse(json['fecha_expiracion'])
          : null,
    );
  }
}

Future<List<PaymentHistory>> fetchPaymentHistory() async {
  try {
    final response = await http.get(
      Uri.parse(
          'https://api-digitalevent.onrender.com/api/pagos/historialpagos'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => PaymentHistory.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load payment history');
    }
  } catch (e) {
    print('Exception caught: $e');
    throw Exception('Failed to load payment history');
  }
}

class historialPago extends StatefulWidget {
  const historialPago({super.key});

  @override
  State<historialPago> createState() => _historialPagoState();
}

class _historialPagoState extends State<historialPago> {
  late Future<List<PaymentHistory>> futurePaymentHistory;

  @override
  void initState() {
    super.initState();
    futurePaymentHistory = fetchPaymentHistory();
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Historial de Pagos',
            style: TextStyle(color: Colors.white),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<PaymentHistory>>(
        future: futurePaymentHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay datos disponibles'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var payment = snapshot.data![index];
                return Card(
                  color: Colors.deepPurple[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  margin: EdgeInsets.all(10.0),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.attach_money,
                              color: Color(0xFF81e665),
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              'Monto: ${payment.monto} MXN',
                              style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: [
                            Icon(
                              Icons.event,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              payment.fecha != null
                                  ? 'Fecha: ${formatDate(payment.fecha!)}'
                                  : "sin datos",
                              style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.solidCreditCard,
                              color: Colors.purpleAccent,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              payment.tipoPagoId != null
                                  ? 'Tipo de Pago: ${payment.tipoPagoId}'
                                  : "sin datos",
                              style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.solidUser,
                              color: Colors.purpleAccent,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              payment.usuarioId != null
                                  ? 'Usuario: ${payment.usuarioId}'
                                  : "sin datos",
                              style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        if (payment.fInicioEp != null) SizedBox(height: 10.0),
                        if (payment.fInicioEp != null)
                          Row(
                            children: [
                              FaIcon(FontAwesomeIcons.calendarDay),
                              SizedBox(width: 8.0),
                              Text(
                                payment.fInicioEp != null
                                    ? 'Fecha Inicio EP: ${formatDate(payment.fInicioEp!)}'
                                    : "sin datos",
                                style: GoogleFonts.openSans(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        if (payment.fFinEp != null) SizedBox(height: 10.0),
                        if (payment.fFinEp != null)
                          Row(
                            children: [
                              FaIcon(FontAwesomeIcons.calendarDay),
                              SizedBox(width: 8.0),
                              Text(
                                payment.fFinEp != null
                                    ? 'Fecha Fin EP: ${formatDate(payment.fFinEp!)}'
                                    : "sin datos",
                                style: GoogleFonts.openSans(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        SizedBox(height: 10.0),
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.solidCreditCard,
                              color: Colors.yellowAccent,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              payment.numeroTarjeta != null
                                  ? 'Número de Tarjeta: ${payment.numeroTarjeta}'
                                  : "sin datos",
                              style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.calendarDay,
                              color: Colors.yellowAccent,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              payment.fechaExpiracion != null
                                  ? 'Fecha Expiración: ${formatDate(payment.fechaExpiracion!)}'
                                  : "sin datos",
                              style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
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
        },
      ),
    );
  }
}
