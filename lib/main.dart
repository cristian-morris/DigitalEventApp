import 'package:digitalevent/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51PXQwjRvOexYqm868BaEds2SOFXYVM32nhnnBCKNUvDiyf14mBpHoFETJYJ7kdLPrQ2VuXHLp5hwgJsHMlYCl6x400OGvYJj9h";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
