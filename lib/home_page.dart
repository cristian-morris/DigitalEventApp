import 'package:digitalevent/pages/event_page.dart';
import 'package:digitalevent/pages/notification_page.dart';
import 'package:digitalevent/pages/recent_event_page.dart';
import 'package:digitalevent/pages/user.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:animations/animations.dart'; // Paquete para animaciones

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _navigateBottonBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    EventosPage(),
    RecentEventPage(),
    NotificationPage(),
    PerfilVer()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (child, animation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple[400],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            onTabChange: _navigateBottonBar,
            selectedIndex: _selectedIndex,
            rippleColor: Colors.white,
            hoverColor: Colors.white,
            gap: 8,
            activeColor: Colors.white,
            iconSize: 24,
            padding: EdgeInsets.all(16),
            duration: Duration(milliseconds: 300),
            tabBackgroundColor: Colors.deepPurple.shade300,
            color: Colors.grey.shade300,
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Eventos',
                iconActiveColor: Colors.orange,
              ),
              GButton(
                icon: Icons.autorenew_rounded,
                text: 'Recientes',
                iconActiveColor: Colors.lightGreen,
              ),
              GButton(
                icon: Icons.notifications,
                text: 'Notificaciones',
                iconActiveColor: Colors.red,
              ),
              GButton(
                icon: Icons.person,
                text: 'Perfil',
                iconActiveColor: Colors.blueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
