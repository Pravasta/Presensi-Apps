import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // async* karena dia mode stream artinya memantau terus menerus
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = auth.currentUser!.uid; //ambil Uid akun yang login

    // Masuk ke collection trus ke doc dengan id lalu get snapshot nya
    // yield* karena diatas stream dan buat memantau secara stream
    yield* firestore.collection('pegawai').doc(uid).snapshots();
  }
}
