import 'package:app_presensi/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => Get.toNamed(Routes.ADD_PEGAWAI),
              icon: const Icon(Icons.person)),
        ],
      ),
      body: Obx(
        () => Center(
          child: controller.isLoading.isFalse
              ? const Text(
                  'HomeView is working',
                  style: TextStyle(fontSize: 20),
                )
              : const CircularProgressIndicator(
                  color: Colors.black,
                ),
        ),
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed: () async {
            if (controller.isLoading.isFalse) {
              // ketika dipencet ubah ke true,
              controller.isLoading.value = true;
              // lalu logout
              await FirebaseAuth.instance.signOut();
              // Ubah ke false lagi
              controller.isLoading.value = false;
              // baru masuk ke halama login
              Get.offAllNamed(Routes.LOGIN_PAGE);
            }
          },
          child: controller.isLoading.isFalse
              ? const Icon(Icons.logout)
              : const CircularProgressIndicator(
                  color: Colors.white,
                ),
        ),
      ),
    );
  }
}
