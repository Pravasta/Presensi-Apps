import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // String uid digunakan menangkap data darii Uid yang didapat darii view, jadi tidak perlu lagi menggunakan firebaseauth
  Future<void> updateProfile(String uid) async {
    // Pastikan dulu data tidak kosong
    if (nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        nipC.text.isNotEmpty) {
      isLoading.value = true;
      // Jangan lpa try and ctach untuk menjaga agar tidak terjadi error
      try {
        await firestore.collection('pegawai').doc(uid).update({
          'nama': nameC.text,
        });
        Get.snackbar('Berhasil', 'Berhasil melakukan update Profile');
      } catch (e) {
        Get.snackbar(
            'Terjadi Kesalahan', 'Tidak dapat melakukan update Profile');
      } finally {
        isLoading.value = true;
      }
    }
  }
}
