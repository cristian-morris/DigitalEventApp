import 'package:digitalevent/pages/event_page.dart';
import 'package:digitalevent/pages/notification_page.dart';
import 'package:digitalevent/pages/recent_event_page.dart';
import 'package:digitalevent/pages/user.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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

  final List <Widget> _pages = [
    EventosPage(),
    RecentEventPage(),
    NotificationPage(),
    PerfilVer()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: Container(
          color: Colors.deepPurple[400],
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
              padding: EdgeInsets.all(10),
              duration: Duration(milliseconds: 200),
              tabBackgroundColor: Colors.deepPurple.shade300,
              color: Colors.grey.shade300,
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Eventos',
                ),
                GButton(
                  icon: Icons.home,
                  text: 'Recientes',
                ),
                GButton(
                  icon: Icons.home,
                  text: 'Noticaiones',
                ),
                GButton(
                  icon: Icons.home,
                  text: 'Perfil',
                ),
              ],
            ),
          ),
        ),
    );
  }
}