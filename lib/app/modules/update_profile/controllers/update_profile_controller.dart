import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  FirebaseStorage storage = FirebaseStorage.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final ImagePicker picker = ImagePicker();

  // Ketika fungsi pick image dijalan kan dia akan memasukkan image kedalam bentuk XFile ini
  XFile? image;

  void pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    // cek null
    if (image != null) {
      print(image!.name);
      print(image!.path);
      print(image!.name.split('.').last);
    } else {
      print(image);
    }
    update();
  }

  // String uid digunakan menangkap data darii Uid yang didapat darii view, jadi tidak perlu lagi menggunakan firebaseauth
  Future<void> updateProfile(String uid) async {
    // Pastikan dulu data tidak kosong
    if (nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        nipC.text.isNotEmpty) {
      isLoading.value = true;
      // Jangan lpa try and ctach untuk menjaga agar tidak terjadi error
      try {
        Map<String, dynamic> data = {
          'nama': nameC.text,
        };
        // cek dulu apakah ada foto atau nggak
        if (image != null) {
          // proses upload email ke firebase storage

          // Bisa pakai path provider bisa tidak juga karena sudah mendapatkan Image.path diatas
          /*
          INI DIGUNAKAN JIKA MENGGUNAKAN PACKAGE PATH PROVIDER
          Directory appDocDir = await getApplicationDocumentsDirectory();
          String filePath = '${appDocDir.absolute}/file-to-upload.png';
          */

          // uid agar id sama dengan curr user
          File file = File(image!.path);
          // Untuk mendapatkan extension file
          String ext = image!.name.split('.').last;
          // Memasukkan file picker ke firebase storage
          await storage.ref('$uid/profile.$ext').putFile(file);
          // Menadaptkan link url foto untuk ditambahkan ke firebase firestore
          String urlImage =
              await storage.ref('$uid/profile.$ext').getDownloadURL();
          // Tambahkan / update profile ke dalam firebase firestore
          data.addAll({
            'profile': urlImage,
          });
        }
        await firestore.collection('pegawai').doc(uid).update(data);
        image = null;
        Get.back();
        Get.snackbar('Berhasil', 'Berhasil melakukan update Profile');
      } catch (e) {
        Get.snackbar(
            'Terjadi Kesalahan', 'Tidak dapat melakukan update Profile');
      } finally {
        isLoading.value = true;
      }
    }
  }

  // String uid untuk masuk ke curr user
  void deleteProfile(String uid) async {
    try {
      await firestore.collection('pegawai').doc(uid).update({
        'profile': FieldValue.delete(),
      });
      Get.back();
      Get.snackbar('Berhasil', 'Profile Picture berhasil dihapus');
    } catch (e) {
      Get.snackbar(
        'Terjadi Kesalahan',
        'Tidak dapat melakukan delete Profile Picture',
      );
    }
  }
}
