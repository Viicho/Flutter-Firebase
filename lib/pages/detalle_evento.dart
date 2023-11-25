import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetalleEvento extends StatelessWidget {
  final Map<String, dynamic> evento;

  const DetalleEvento({required this.evento});

  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = evento['fecha'];
    DateTime fechaEvento = timestamp.toDate();

    String fecha = DateFormat('dd/MM/yyyy HH:mm:ss').format(fechaEvento);
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del evento'),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Card(
              child: Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                height: 200,
                child: Image.network(evento["imagen"]),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    "Nombre del evento: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(child: Text("${evento["nombre"]}"))
                ]),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    "Fecha del evento: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(child: Text("${fecha}"))
                ]),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    "Descripcion: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(child: Text("${evento["descripcion"]}"))
                ]),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    "Tipo: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(child: Text("${evento["tipo"]}"))
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
