import 'package:digitalevent/register.dart';
import 'package:digitalevent/login.dart';
import 'package:digitalevent/auth_provider.dart';
import 'package:digitalevent/home_page.dart';
import 'package:digitalevent/view/splash_screen.dart';
import 'package:digitalevent/view/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51PXQwjRvOexYqm868BaEds2SOFXYVM32nhnnBCKNUvDiyf14mBpHoFETJYJ7kdLPrQ2VuXHLp5hwgJsHMlYCl6x400OGvYJj9h";
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    // Mostrar el SplashScreen por 5 segundos.
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _showSplash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return ChangeNotifierProvider(
      create: (ctx) => AuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: Consumer<AuthProvider>(
          builder: (ctx, auth, _) => _showSplash
              ? SplashScreen()
              : auth.isAuth
                  ? const HomePage()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) {
                        if (authResultSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const WaitingScreen();
                        } else {
                          return LoginPage();
                        }
                      },
                    ),
        ),
        routes: {
          '/login': (ctx) => LoginPage(),
          '/main': (ctx) => const HomePage(),
          '/register': (ctx) => Register(),
        },
      ),
    );
  }
}

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
