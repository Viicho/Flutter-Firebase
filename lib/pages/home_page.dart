import 'package:animated_emoji/emoji.dart';
import 'package:animated_emoji/emojis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_certamen/pages/detalle_evento.dart';
import 'package:flutter_certamen/services/firebase_services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var estadosLikes = <int>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FireStoreServices().eventosNoFinalizados(),
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
              bool leDioLike = estadosLikes.contains(index);
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
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (leDioLike) {
                                  print(estadosLikes);
                                  estadosLikes.remove(index);
                                  FireStoreServices().dislike(evento.id);
                                } else {
                                  estadosLikes.add(index);
                                  FireStoreServices().like(evento.id);
                                }
                              });
                            },
                            child: Icon(
                              MdiIcons.heart,
                              color: leDioLike ? Colors.red : null,
                            ),
                          ),
                          Text('${evento['likes']}')
                        ],
                      ),
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
