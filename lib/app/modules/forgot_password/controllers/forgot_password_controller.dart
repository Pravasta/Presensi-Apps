import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void resetEmail() async {
    if (emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await auth.sendPasswordResetEmail(email: emailC.text);
        Get.defaultDialog(
            title: 'Berhasil',
            middleText:
                'Kami telah mengirimkan email reset password ke email anda, silahkan cek email anda');
      } catch (e) {
        Get.defaultDialog(
            title: 'Terjadi Kesalahan',
            middleText: 'Gagal mengirimkan email reset password..');
      } finally {
        isLoading.value = false;
      }
    }
  }
}
