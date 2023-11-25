import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireStoreServices {
  Stream<QuerySnapshot> eventosAll() {
    return FirebaseFirestore.instance.collection('Eventos').snapshots();
  }

  Stream<QuerySnapshot> eventosNoFinalizados() {
    DateTime fechaAhora = DateTime.now().subtract(Duration(hours: 3));
    return FirebaseFirestore.instance
        .collection('Eventos')
        .where("fecha", isGreaterThanOrEqualTo: fechaAhora)
        .snapshots();
  }

  Stream<QuerySnapshot> eventosFinalizados() {
    DateTime fechaAhora = DateTime.now().subtract(Duration(hours: 3));
    return FirebaseFirestore.instance
        .collection('Eventos')
        .where("fecha", isLessThanOrEqualTo: fechaAhora)
        .snapshots();
  }

  Future<void> like(String id) async {
    var res = FirebaseFirestore.instance.collection('Eventos').doc(id);
    await res.update({
      'likes': FieldValue.increment(1),
    });
  }

  Future<void> dislike(String id) async {
    var res = FirebaseFirestore.instance.collection('Eventos').doc(id);
    await res.update({
      'likes': FieldValue.increment(-1),
    });
  }

  Stream<QuerySnapshot> proximosEventos() {
    DateTime fechaAhora = DateTime.now().subtract(Duration(hours: 3));
    DateTime fechaLimite = fechaAhora.add(Duration(days: 3));
    print(DateTime.now().timeZoneName);
    return FirebaseFirestore.instance
        .collection("Eventos")
        .where("fecha",
            isGreaterThan: fechaAhora, isLessThanOrEqualTo: fechaLimite)
        .snapshots();
  }

  Future<void> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    auth.signInWithCredential(credential);
  }

  Future<void> logout() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  Future<void> eventoDelete(String eventoId) async {
    return FirebaseFirestore.instance
        .collection("Eventos")
        .doc(eventoId)
        .delete();
  }

  Future<void> agregarEvento(
      String nombre,
      String lugar,
      int likes,
      Timestamp fecha,
      String descripcion,
      String imagenUrl,
      String tipo) async {
    return FirebaseFirestore.instance.collection('Eventos').doc().set({
      'nombre': nombre,
      'lugar': lugar,
      'likes': likes,
      'fecha': fecha,
      'descripcion': descripcion,
      'imagen': imagenUrl,
      'tipo': tipo
    });
  }

  Future<XFile?> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<String> guardarImagen(File image) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final String nombreFile = image.path.split("/").last;
    Reference direccion = storage.ref().child("imagenes").child(nombreFile);
    final UploadTask uploadTask = direccion.putFile(image);
    final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);

    final String url = await snapshot.ref.getDownloadURL();

    if (snapshot.state == TaskState.success) {
      return url;
    } else {
      return "0";
    }
  }
}
