import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPegawaiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAddPagawai = false.obs;
  TextEditingController nameC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();

  // Jembatan firebase auth
  FirebaseAuth auth = FirebaseAuth.instance;
  // Jembatan firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // pindahkan try and chat dari add pegawai ke sini
  Future<void> prosesAddPegawai() async {
    // untuk menambahkan password
    if (passAdminC.text.isNotEmpty) {
      isLoadingAddPagawai.value = true;
      try {
        // Simpan email admin
        String emailAdmin = auth.currentUser!.email!;

        // Cek apakah admin ini login dengan password yang benar
        // kalau sudah benar lanjut kebawah sampai logout
        UserCredential adminCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAdmin,
          password: passAdminC.text,
        );

        // Membuat akun pegawai baru
        UserCredential credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );
        // Tambahkan ke firebase fire store
        // 1. Panggil uid dan menghandle agar tidak null
        if (credential.user != null) {
          String uid = credential.user!.uid;

          // masuk ke collection / membuat nya lalu pasang await karena harus menunggu juga
          // Ini juga proses pendaftaran akun
          await firestore.collection('pegawai').doc(uid).set({
            'nip': nipC.text,
            'nama': nameC.text,
            'email': emailC.text,
            'uid': uid,
            'createAt': DateTime.now().toIso8601String(),
          });
          // Setelah pendaftaran akun dengan email, kita wajib mengirimkan sebuah email verifikasi agar email tidak diisi sembarangan
          await credential.user!.sendEmailVerification();

          // tujuannya ketika menambahkan akun langsung di logout dan tetap di akun admin, tanpa pindah ke akun baru
          //  dengan catatan harus ditambahkan auto login lagi
          await auth.signOut();

          // Lalu setelah pegawai logut login lagi ke
          UserCredential adminCredential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailAdmin,
            password: passAdminC.text,
          );

          Get.back(); //tutup dialog
          Get.back(); //Balik ke home

          Get.snackbar('Berhasil', 'Berhasil menambahkan pegawai');
          // pass sudah berhasil juga ubah ke false
          isLoadingAddPagawai.value = false;
        }

        print(credential);
      } on FirebaseAuthException catch (e) {
        isLoadingAddPagawai.value = false;
        if (e.code == 'weak-password') {
          Get.defaultDialog(
              title: 'Terjadi kesalahan',
              middleText: 'Password Terlalu singkat');
        } else if (e.code == 'email-already-in-use') {
          Get.defaultDialog(
              title: 'Terjadi kesalahan',
              middleText: 'Pegawai sudah ada, silahkan daftar kan email lain');
        } else if (e.code == 'wrong-password') {
          Get.defaultDialog(
              title: 'Terjadi kesalahan',
              middleText: 'Admin tidak dapat login, password salah');
        } else {
          Get.defaultDialog(title: 'Terjadi kesalahan', middleText: e.code);
        }
      } catch (e) {
        isLoadingAddPagawai.value = false;
        Get.defaultDialog(
            title: 'Terjadi kesalahan',
            middleText: 'Tidak dapat menambahkan pegawai');
      }
    } else {
      isLoading.value = false;
      Get.snackbar('Terjadi Kesalahan',
          'Password wajib diisi untuk keperluan validasi Admin');
    }
  }

  Future<void> addPegawai() async {
    if (nameC.text.isNotEmpty &&
        nipC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      // Ketika mau buka default dialog, bah tulisan add pegawai ke true
      isLoading.value = true;
      // Untuk validasi apakah yang menambhkan pegawai adalah admin atau bukan
      Get.defaultDialog(
          title: 'Validasi Admin',
          content: Column(
            children: [
              const Text('Masukkan password untuk validasi admin'),
              const SizedBox(height: 10),
              TextField(
                controller: passAdminC,
                autocorrect: false,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              )
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                isLoading.value = false;
                Get.back();
              },
              child: const Text('Cancel'),
            ),
            Obx(
              () => ElevatedButton(
                onPressed: () async {
                  if (isLoadingAddPagawai.isFalse) {
                    // diberii asyn agar kita menunggu hingga proses nya selsai
                    await prosesAddPegawai();
                  }
                  isLoading.value = false;
                },
                child: isLoadingAddPagawai.isFalse
                    ? const Text('Add Pegawai')
                    : const Text('Loading'),
              ),
            ),
          ]);
      // Eksekusi
    } else {
      Get.defaultDialog(
          title: 'Terjadi kesalahan',
          middleText: 'Nama , nip, dan email wajib diisi');
    }
  }
}
