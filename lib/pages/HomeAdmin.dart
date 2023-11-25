import 'package:animated_emoji/emoji.dart';
import 'package:animated_emoji/emojis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_certamen/pages/agregar_evento.dart';
import 'package:flutter_certamen/pages/detalle_evento.dart';
import 'package:flutter_certamen/services/firebase_services.dart';
import 'package:flutter_dismissible_tile/flutter_dismissible_tile.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AgregarEvento()));
            },
            child: Icon(MdiIcons.plus),
          ),
          ElevatedButton(
            onPressed: () async {
              await FireStoreServices().logout();
              Navigator.pop(context);
            },
            child: Text("Cerrar sesion"),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text('Administrador'),
      ),
      body: StreamBuilder(
        stream: FireStoreServices().eventosAll(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No hay eventos",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  AnimatedEmoji(
                    AnimatedEmojis.sad,
                    size: 50,
                    repeat: true,
                  ),
                ],
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var evento = snapshot.data!.docs[index];
                Timestamp timestamp = evento['fecha'];
                DateTime fechaEvento = timestamp.toDate();
                String fecha = DateFormat('dd/MM/yyyy').format(fechaEvento);
                return InkWell(
                  onDoubleTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalleEvento(
                            evento: evento.data() as Map<String, dynamic>),
                      ),
                    );
                  },
                  child: DismissibleTile(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      setState(() {
                        FireStoreServices().eventoDelete(evento.id);
                      });
                    },
                    direction: DismissibleTileDirection.rightToLeft,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    delayBeforeResize: const Duration(milliseconds: 500),
                    rtlDismissedColor: Colors.redAccent,
                    rtlOverlay: const Text('Borrar'),
                    rtlOverlayDismissed: const Text('Evento borrado'),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Card(
                        child: ListTile(
                            leading: Icon(MdiIcons.partyPopper),
                            title: Text('${evento['nombre']}'),
                            subtitle: Text('${fecha}')),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
