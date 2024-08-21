import 'dart:convert';
import 'package:digitalevent/auth_provider.dart';
import 'package:digitalevent/models/evento.dart';
import 'package:digitalevent/view/comentarios.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class EventDetailPage extends StatelessWidget {
  final Evento evento;

  EventDetailPage({required this.evento});

  Future<String> createPaymentIntent(int amount, String currency, String descripcion, int usuarioid, int eventoid) async {
    try {
      final body = jsonEncode({
        'amount': amount,
        'currency': currency,
        'descripcion': descripcion,
        'usuario_id': usuarioid,
        'evento_id': eventoid,
      });
      final response = await http.post(
        Uri.https('api-digitalevent.onrender.com', '/api/pagos/pagar'),
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final paymentIntentData = jsonDecode(response.body);
        final clientSecret = paymentIntentData['client_secret'] as String;
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
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.userId;
      final paymentIntentClientSecret = await createPaymentIntent(5000, 'USD', evento.eventoNombre, userId, evento.eventoId);

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          style: ThemeMode.light,
          merchantDisplayName: 'ejemplo',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          evento.eventoNombre,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple,
                Colors.purple,
                Colors.purpleAccent,
              ],
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
                child: Image.network(
                  evento.imagenUrl ?? 'default_image_url',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Image.asset(
                      'assets/cancelar.png',
                      height: 200,
                      width: double.infinity,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(evento.eventoNombre,
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
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('Hora: ${evento.hora}',
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
                  Text('Categoría: ${evento.categoria}',
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
                      'Autorizado el: ${DateFormat('yyyy-MM-dd').format(evento.fechaAutorizacion ?? DateTime.now())}',
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.people, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('Máximo de Personas: ${evento.maxPer}',
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.event_seat, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                      'Forma del Escenario: ${evento.formaEscenario ?? "No especificado"}',
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Descripción del Evento',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                evento.descripcion ?? "No hay descripción disponible",
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Selecciona tu Asiento',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                  childAspectRatio: 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: evento.maxPer,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Asiento Seleccionado'),
                          content:
                              Text('Has seleccionado el asiento ${index + 1}'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.purple[100],
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Precio del Evento',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                evento.monto != null ? '\$${evento.monto}' : 'Gratis',
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () => makePayment(context),
                  child: Container(
                    width: 255,
                    height: 53,
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
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.payment,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Comprar Boleto",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.grey),
              const SizedBox(height: 16),
              // Añadir la sección de comentarios aquí
              ComentariosSection(eventoId: evento.eventoId),
            ],
          ),
        ),
      ),
    );
  }
}
