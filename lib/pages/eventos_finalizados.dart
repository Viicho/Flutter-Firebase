import 'package:animated_emoji/emoji.dart';
import 'package:animated_emoji/emojis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_certamen/pages/detalle_evento.dart';
import 'package:flutter_certamen/services/firebase_services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EventosFinalizados extends StatefulWidget {
  const EventosFinalizados({super.key});

  @override
  State<EventosFinalizados> createState() => _EventosFinalizadosState();
}

class _EventosFinalizadosState extends State<EventosFinalizados> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FireStoreServices().eventosFinalizados(),
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
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Card(
                    child: ListTile(
                      leading: Icon(MdiIcons.partyPopper),
                      title: Text('${evento['nombre']}'),
                      subtitle: Text('${fecha}'),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
