import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController curPasC = TextEditingController();
  TextEditingController newPasC = TextEditingController();
  TextEditingController conNewPasC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void updatePassword() async {
    if (curPasC.text.isNotEmpty &&
        newPasC.text.isNotEmpty &&
        conNewPasC.text.isNotEmpty) {
      if (newPasC.text == conNewPasC.text) {
        isLoading.value = true;
        try {
          // Cek apakah sudah masuk atau belum
          String emailUser = auth.currentUser!.email!;
          // coba login
          await auth.signInWithEmailAndPassword(
              email: emailUser, password: curPasC.text);
          // Kalau sudah login diatas baru menjalankan Update Pass
          await auth.currentUser!.updatePassword(newPasC.text);

          Get.back();
          Get.snackbar('Berhasil', 'Password Berhasil Diganti');
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
            Get.snackbar('Terjadi Kesalahan', 'Password yang dimasukkan salah');
          } else {
            Get.snackbar('Terjadi Kesalahan', e.code.toLowerCase());
          }
        } catch (e) {
          Get.snackbar(
              'Terjadi Kesalahan', 'Tidak dapa melakukan pembaruan Password');
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar('Terjadi Kesalahan', 'Konfirmasi Password Tidak Sama');
      }
    } else {
      Get.snackbar('Terjadi Kesalahan', "Semua input harus diisi");
    }
  }
}
