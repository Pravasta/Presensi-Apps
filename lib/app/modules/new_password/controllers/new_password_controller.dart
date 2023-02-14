import 'package:app_presensi/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPasswordController extends GetxController {
  TextEditingController newPassC = TextEditingController();
  // Karena sudah dipastikan akun sudah berhasil login pada page login

  FirebaseAuth auth = FirebaseAuth.instance;

  void newPassword() async {
    if (newPassC.text.isNotEmpty) {
      // Cek lagi jangan sampai password nya sama dengan password lagi
      if (newPassC.text != 'password') {
        try {
          // Langsung login ke home atau kembali ke login dan mengisi pass baru
          // Kalau mau langsung ke home silahkan simpen dulu email nya
          String email = auth.currentUser!.email!;

          // Current user Sudah pasti ada karena yang masuk new password yang sudah berhasil masuk login
          // jadi otomatis firebase menyimpan password sebelumnya yang ada
          await auth.currentUser!.updatePassword(newPassC.text);

          await auth.signOut();

          await auth.signInWithEmailAndPassword(
            email: email,
            password: newPassC.text,
          );

          Get.offAllNamed(Routes.HOME);
        } on FirebaseAuthException catch (e) {
          if (e.code == '  weak-password') {
            Get.defaultDialog(
                title: 'Terjadi kesalahan',
                middleText: 'Password setidaknya terdiri dari 6 karakter');
          }
        } catch (_) {
          Get.defaultDialog(
            title: 'terjadi kesalahan',
            middleText:
                'Tidak adapat membuat password baru, silahkan hubungi admin atau customer services',
          );
        }
      } else {
        Get.defaultDialog(
          title: 'Terjadi kesalahan',
          middleText: 'Password harus diubah',
        );
      }
    } else {
      Get.snackbar('Terjadi kesalahan', 'Password baru wajib diisi');
    }
  }
}
