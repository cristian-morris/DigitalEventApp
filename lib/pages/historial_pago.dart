import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentHistory {
  final int pagoId;
  final String monto;
  final DateTime fecha;
  final int tipoPagoId;
  final int usuarioId;
  final int eventoId;
  final DateTime? fInicioEp;
  final DateTime? fFinEp;
  final String numeroTarjeta;
  final DateTime fechaExpiracion;

  PaymentHistory({
    required this.pagoId,
    required this.monto,
    required this.fecha,
    required this.tipoPagoId,
    required this.usuarioId,
    required this.eventoId,
    this.fInicioEp,
    this.fFinEp,
    required this.numeroTarjeta,
    required this.fechaExpiracion,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      pagoId: json['pago_id'],
      monto: json['monto'],
      fecha: DateTime.parse(json['fecha']),
      tipoPagoId: json['tipo_pago_id'],
      usuarioId: json['usuario_id'],
      eventoId: json['evento_id'],
      fInicioEp: json['f_inicio_ep'] != null
          ? DateTime.parse(json['f_inicio_ep'])
          : null,
      fFinEp:
          json['f_FIN_ep'] != null ? DateTime.parse(json['f_FIN_ep']) : null,
      numeroTarjeta: json['numero_tarjeta'],
      fechaExpiracion: DateTime.parse(json['fecha_expiracion']),
    );
  }
}

Future<List<PaymentHistory>> fetchPaymentHistory() async {
  final response = await http.get(
    Uri.parse('https://api-digitalevent.onrender.com/api/pagos/historialpagos'),
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => PaymentHistory.fromJson(json)).toList();
  } else {
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
        backgroundColor: Color.fromARGB(255, 36, 36, 36),
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
                  color: Color.fromARGB(255, 110, 110, 110),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  margin: EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5.0),
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
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          children: [
                            Icon(
                              Icons.event,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              'Fecha: ${formatDate(payment.fecha)}',
                              style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.solidCreditCard,
                              color: Color(0xFFB197FC),
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              'Tipo de Pago: ${payment.tipoPagoId}',
                              style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.solidUser,
                              color: Color(0xFF74C0FC),
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              'Usuario: ${payment.usuarioId}',
                              style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.calendarCheck,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              'Evento: ${payment.eventoId}',
                              style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        if (payment.fInicioEp != null) SizedBox(height: 5.0),
                        if (payment.fInicioEp != null)
                          Row(
                            children: [
                              FaIcon(FontAwesomeIcons.calendarDay),
                              SizedBox(width: 8.0),
                              Text(
                                'Fecha Inicio EP: ${formatDate(payment.fInicioEp!)}',
                                style: GoogleFonts.openSans(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        if (payment.fFinEp != null) SizedBox(height: 5.0),
                        if (payment.fFinEp != null)
                          Row(
                            children: [
                              FaIcon(FontAwesomeIcons.calendarDay),
                              SizedBox(width: 8.0),
                              Text(
                                'Fecha Fin EP: ${formatDate(payment.fFinEp!)}',
                                style: GoogleFonts.openSans(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        SizedBox(height: 5.0),
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.solidCreditCard,
                              color: Color.fromARGB(255, 255, 213, 59),
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              'Número Tarjeta: ${payment.numeroTarjeta}',
                              style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          children: [
                            FaIcon(FontAwesomeIcons.calendar),
                            SizedBox(width: 8.0),
                            Text(
                              'Fecha Expiración: ${formatDate(payment.fechaExpiracion)}',
                              style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontSize: 15,
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
