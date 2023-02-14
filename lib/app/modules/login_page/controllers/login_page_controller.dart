import 'package:app_presensi/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPageController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool hidePass = true.obs;
  TextEditingController emailC =
      TextEditingController(text: 'fitrayanaf11@gmail.com');
  TextEditingController passC = TextEditingController(text: 'Cobacoba123');

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      // ketika fungsi dipanggil ubah dulu isLoading nya menjadi true
      isLoading.value = true;

      // Eksekusi
      try {
        UserCredential credential = await auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );

        // Verifikasi apakai email benar sesuai email yang berlaku
        if (credential.user != null) {
          if (credential.user!.emailVerified == true) {
            // Kalau berhasil login, sebelum masuk home kita tanya dulu mau ganti password apa nggak ?
            // dan ubah menjadi false juga untuk isLoading nya
            isLoading.value = false;
            if (passC.text == 'password') {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            Get.defaultDialog(
                title: 'Belum verifikasi',
                middleText:
                    'Kamu belum verifikasi akun ini, lakukan verifikasi di email kamu',
                actions: [
                  OutlinedButton(
                    onPressed: () {
                      isLoading.value = false;
                      Get.back();
                    }, //Bisa kembali dan buat tutup dialog
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // ada kemungkinan error ketika kirim ulang, maka perlu try and catch
                      try {
                        await credential.user!.sendEmailVerification();
                        Get.snackbar(
                            'Berhasil', 'Berhasil mengirim email Verification');
                        isLoading.value =
                            false; //Yang disiini untuk membuat ketika di cancel tulisan loading berubah menjadi login lagi
                      } catch (e) {
                        isLoading.value = false;
                        Get.snackbar('Terjadi kesalahan',
                            'Tidak dapat mengirim email verifikasi. Hubungi admin atau Customer Services');
                      }
                    },
                    child: const Text('Kirim ulang'),
                  ),
                ]);
          }
        }
        // Kalau misal userCredential nya null juga diubah ke false lagi
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        // ketika error juga diubah ke false lagi
        isLoading.value = false;
        if (e.code == 'user-not-found') {
          Get.defaultDialog(
              title: 'Terjadi Kesalahan', middleText: 'Email tidak ditemukan.');
        } else if (e.code == 'wrong-password') {
          Get.defaultDialog(
              title: 'Terjadi kesalahan', middleText: 'Password Salah');
        }
      } catch (_) {
        isLoading.value = false;
        Get.defaultDialog(
            title: 'Terjadi kesalahan', middleText: 'Tidak dapat login');
      }
    } else {
      Get.defaultDialog(
          title: 'Terjadi kesalahan',
          middleText: 'Email dan password wajib diisi');
    }
  }
}
