import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_certamen/services/firebase_services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AgregarEvento extends StatefulWidget {
  const AgregarEvento({super.key});

  @override
  State<AgregarEvento> createState() => _AgregarEventoState();
}

class _AgregarEventoState extends State<AgregarEvento> {
  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController lugarCtrl = TextEditingController();
  TextEditingController descripcionCtrl = TextEditingController();
  TextEditingController likesCtrl = TextEditingController();
  TextEditingController fechaCtrl = TextEditingController();
  TextEditingController tipoCtrl = TextEditingController();

  File? imagen;

  DateTime diaEvento = DateTime.now();
  TimeOfDay horaEvento = TimeOfDay.now();
  Timestamp fechaCompleta = Timestamp.now();

  final formKey = GlobalKey<FormState>();
  final formatoFecha = DateFormat('dd/MM/yyyy');
  final formatoHora = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar eventos"),
      ),
      body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(children: [
              TextFormField(
                controller: nombreCtrl,
                decoration: InputDecoration(label: Text("Nombre")),
                validator: (nombre) {
                  if (nombre!.isEmpty) {
                    return "indique el nombre";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: lugarCtrl,
                decoration: InputDecoration(label: Text("Lugar")),
                validator: (lugar) {
                  if (lugar!.isEmpty) {
                    return "indique el lugar";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descripcionCtrl,
                decoration: InputDecoration(label: Text("Descripcion")),
                validator: (descripcion) {
                  if (descripcion!.isEmpty) {
                    return "indique la descripcion";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: tipoCtrl,
                decoration: InputDecoration(label: Text("Tipo")),
                validator: (descripcion) {
                  if (descripcion!.isEmpty) {
                    return "indique el tipo";
                  }
                  return null;
                },
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text(
                    "Fecha Del evento",
                  )),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2030))
                            .then((fecha) {
                          setState(() {
                            diaEvento = fecha ?? diaEvento;
                          });
                        });
                      },
                      child: Icon(MdiIcons.calendar)),
                  ElevatedButton(
                      onPressed: () {
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ).then((hora) {
                          setState(() {
                            horaEvento = hora ?? horaEvento;
                          });
                        });
                      },
                      child: Icon(MdiIcons.clock)),
                ],
              ),
              Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Text(formatoFecha.format(diaEvento))),
                  Text(formatoHora.format(DateTime(
                    2022,
                    1,
                    1,
                    horaEvento.hour,
                    horaEvento.minute,
                  ))),
                ],
              ),
              imagen != null
                  ? Image.file(imagen!)
                  : Container(
                      decoration: BoxDecoration(border: Border.all()),
                      margin: EdgeInsets.only(top: 30),
                      height: 200,
                      width: double.infinity,
                    ),
              IconButton(
                onPressed: () async {
                  final image = await FireStoreServices().getImage();
                  setState(() {
                    imagen = File(image!.path);
                  });
                },
                icon: Row(
                  children: [
                    Icon(MdiIcons.camera),
                    Text(
                      'Seleccione imagen',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                width: double.infinity,
                child: MaterialButton(
                  onPressed: () async {
                    fechaCompleta = Timestamp.fromDate(DateTime(
                      diaEvento.year,
                      diaEvento.month,
                      diaEvento.day,
                      horaEvento.hour,
                      horaEvento.minute,
                    ));

                    if (formKey.currentState!.validate() && imagen != null) {
                      String urlImagen =
                          await FireStoreServices().guardarImagen(imagen!);
                      if (urlImagen != "0") {
                        await FireStoreServices().agregarEvento(
                            nombreCtrl.text.trim(),
                            lugarCtrl.text.trim(),
                            0,
                            fechaCompleta,
                            descripcionCtrl.text.trim(),
                            urlImagen,
                            tipoCtrl.text.trim());
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Text('Agregar Evento'),
                  color: Colors.lightBlue,
                ),
              ),
            ]),
          )),
    );
  }
}
