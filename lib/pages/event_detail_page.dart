// event_detail_page.dart
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
        Uri.https('api-digitalevent.onrender.com', '/api/pagos/pago'), // Asegúrate de usar tu URL correcta
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final paymentIntentData = jsonDecode(response.body);
        final clientSecret = paymentIntentData['client_secret'] as String;
        print(clientSecret); // Asegúrate de que este print sea solo para depuración
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
          merchantDisplayName: 'ejemplo'
        ),
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
        title: Text(evento.nombreEvento),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(evento.imagenUrl,
                height: 200, width: double.infinity, fit: BoxFit.cover),
            SizedBox(height: 8),
            Text(evento.nombreEvento,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(DateFormat('yyyy-MM-dd – kk:mm').format(evento.fechaInicio),
                style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            Text(evento.ubicacion, style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            Text('Detalles del Evento',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Tipo de Evento: ${evento.tipoEvento}'),
            Text('Organizado por: ${evento.organizadorNombre}'),
            Text('Categoría: ${evento.categoriaNombre}'),
            Text('Estado: ${evento.estado}'),
            Text(
                'Fecha de Autorización: ${DateFormat('yyyy-MM-dd').format(evento.fechaAutorizacion)}'),
            ElevatedButton(
              onPressed: () => makePayment(context),
              child: Text("Comprar Boleto"),
            )
          ],
        ),
          )
        ],
      ),
    );
  }
}
