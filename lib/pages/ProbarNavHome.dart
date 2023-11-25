import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_certamen/pages/HomeAdmin.dart';
import 'package:flutter_certamen/pages/eventos_finalizados.dart';
import 'package:flutter_certamen/pages/home_page.dart';
import 'package:flutter_certamen/pages/proximos_eventos.dart';
import 'package:flutter_certamen/services/firebase_services.dart';

class NavHomeTest extends StatefulWidget {
  @override
  _NavHomeTestState createState() => _NavHomeTestState();
}

class _NavHomeTestState extends State<NavHomeTest> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget selectedScreen;

    if (_selectedIndex == 0) {
      selectedScreen = ProximosEventos();
    } else if (_selectedIndex == 1) {
      selectedScreen = HomePage();
    } else {
      selectedScreen = EventosFinalizados();
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await FireStoreServices().signInWithGoogle();
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => HomeAdmin()));
        },
        child: Image.asset('assets/googleFlutter.png'),
      ),
      body: Center(
        child: selectedScreen,
      ),
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          FlashyTabBarItem(
            icon: Icon(Icons.event),
            title: Text('Proximos Eventos'),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.home),
            title: Text('Eventos'),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.home),
            title: Text('Finalizados'),
          ),
        ],
      ),
    );
  }
}
