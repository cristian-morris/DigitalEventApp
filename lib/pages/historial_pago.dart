import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:digitalevent/auth_provider.dart';

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

Map<int, String> tipoPagoMap = {
  1: 'Tarjeta de Crédito',
  2: 'Tarjeta de Débito',
  3: 'Transferencia Bancaria',
  // Agrega más tipos de pago según sea necesario
};

Future<List<PaymentHistory>> fetchPaymentHistory(
    int usuarioId, String token) async {
  try {
    final response = await http.get(
      Uri.parse(
          'https://api-digitalevent.onrender.com/api/pagos/historial/$usuarioId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print("API Response: ${response.body}"); // Muestra la respuesta de la API
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => PaymentHistory.fromJson(json)).toList();
    } else {
      throw Exception('Fallo al obtener sus historial de pagos');
    }
  } catch (e) {
    print('Exception caught: $e');
    throw Exception('Fallo al obtener su historial de pagos');
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
    _initializePaymentHistory();
  }

  Future<void> _initializePaymentHistory() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final usuarioId = authProvider.user?['usuario_id'];
    final token = authProvider.token;

    // Verifica el ID del usuario y el token
    print("Usuario ID: $usuarioId");
    print("Token: $token");

    if (usuarioId != null && token != null) {
      setState(() {
        futurePaymentHistory = fetchPaymentHistory(usuarioId, token);
      });
    } else {
      // Muestra un mensaje de error si no se puede obtener el ID del usuario o el token
      setState(() {
        futurePaymentHistory =
            Future.error('No se pudo obtener el ID del usuario o el token.');
      });
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
        ),
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
      ),
      body: FutureBuilder<List<PaymentHistory>>(
        future: futurePaymentHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay datos disponibles'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var payment = snapshot.data![index];
                return Card(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  margin: const EdgeInsets.all(8.0),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(top: 1.0),
                                child: Image.asset(
                                  'assets/card-bank.jpg',
                                  height: 185.0,
                                  fit: BoxFit.cover,
                                ))
                          ],
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.calendar_month_sharp,
                              size: 22,
                              color: Colors.black,
                            ),
                            Text(
                              payment.fecha != null
                                  ? 'Fecha: ${formatDate(payment.fecha!)}'
                                  : "sin datos",
                              style: GoogleFonts.openSans(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '\$${payment.monto} MXN',
                              style: GoogleFonts.openSans(
                                  color: Colors.green,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Image.asset(
                              'assets/metodoPagos.jpg',
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              'Pago por: ${tipoPagoMap[payment.tipoPagoId] ?? 'Sin datos'}', // Concatenar el texto fijo con el valor descriptivo
                              style: GoogleFonts.openSans(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.creditCard,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              payment.numeroTarjeta != null
                                  ? 'Número de Tarjeta: ${payment.numeroTarjeta}'
                                  : "sin datos",
                              style: GoogleFonts.openSans(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.solidUser,
                              color: Colors.black,
                              size: 22,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              payment.usuarioId != null
                                  ? 'Usuario: ${payment.usuarioId}'
                                  : "sin datos",
                              style: GoogleFonts.openSans(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.circleCheck,
                              color: Colors.green,
                              size: 45,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Pago Completado',
                              style: TextStyle(color: Colors.green),
                            )
                          ],
                        )
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