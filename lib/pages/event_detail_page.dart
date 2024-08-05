import 'dart:convert';
import 'package:digitalevent/models/evento.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class EventDetailPage extends StatelessWidget {
  Future<String> createPaymentIntent(int amount, String currency) async {
    try {
      final body = jsonEncode({
        'amount': amount,
        'currency': currency,
      });
      final response = await http.post(
        Uri.https('api-digitalevent.onrender.com', '/api/pagos/pago'),
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final paymentIntentData = jsonDecode(response.body);
        final clientSecret = paymentIntentData['client_secret'] as String;
        print(clientSecret);
        return clientSecret;
      } else {
        throw Exception('Failed to create payment intent');
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      throw Exception('Failed to create payment intent');
    }
  }

  Future<void> makePayment(BuildContext context) async {
    try {
      final paymentIntentClientSecret = await createPaymentIntent(5000, 'USD');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentClientSecret,
            style: ThemeMode.light,
            merchantDisplayName: 'ejemplo'),
      );

      await displayPaymentSheet(context);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> displayPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Pago exitoso")));
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  final Evento evento;

  EventDetailPage({required this.evento});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          evento.nombreEvento,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(evento.imagenUrl,
                    height: 200, width: double.infinity, fit: BoxFit.cover),
              ),
              const SizedBox(height: 16),
              Text(evento.nombreEvento,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('yyyy-MM-dd – kk:mm').format(evento.fechaInicio),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(evento.ubicacion,
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Detalles del Evento',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.category, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('Categoría: ${evento.categoriaNombre}',
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.event, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('Tipo de Evento: ${evento.tipoEvento}',
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('Organizado por: ${evento.organizadorNombre}',
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.info, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('Estado: ${evento.estado}',
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                      'Autorizado el: ${DateFormat('yyyy-MM-dd').format(evento.fechaAutorizacion)}',
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.purple,
                        Colors.deepPurple,
                        Colors.purpleAccent
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => makePayment(context),
                    icon: const Icon(Icons.payment),
                    label: const Text("Comprar Boleto"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
