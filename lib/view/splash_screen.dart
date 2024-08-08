import 'package:flutter/material.dart';
import 'dart:async';
import 'package:digitalevent/Login.dart';
import 'package:digitalevent/home_page.dart';
import 'package:digitalevent/auth_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();

    Timer(Duration(seconds: 4), () {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuth) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple,
                      Colors.deepPurple,
                      Colors.purpleAccent
                    ],
                    stops: [
                      _controller.value * 0.3,
                      _controller.value * 0.6,
                      _controller.value
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              );
            },
          ),
          Center(
            child: ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'assets/LOGO HUB BLANCO 1.png',
                width: 200,
                height: 200,
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _animation,
              child: Text(
                "Digital Event Hub",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
