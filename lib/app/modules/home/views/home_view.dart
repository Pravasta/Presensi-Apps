import 'package:app_presensi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
            onPressed: () => Get.toNamed(Routes.PROFILE_PAGE),
            icon: const Icon(Icons.person),
          ),
          // // Stream builder ntuk memantau data yang ada di firestore secara terus menerus
          // // StreamBuilder<Object>(
          // // Kenaoa diganti karena agar streamRole() berubah dari type object ke Document snapshot
          // StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          //     stream: controller.streamRole(),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return const SizedBox();
          //       }
          //       // Ambil dulu role nya
          //       String role = snapshot.data!.data()!['role'];
          //       if (role == 'admin') {
          //         // ini admin
          //         return Row(
          //           children: [
          //             IconButton(
          //               onPressed: () => Get.toNamed(Routes.ADD_PEGAWAI),
          //               icon: const Icon(Icons.addchart),
          //             ),

          //           ],
          //         );
          //       } else {
          //         return IconButton(
          //           onPressed: () => Get.toNamed(Routes.PROFILE_PAGE),
          //           icon: const Icon(Icons.person),
          //         );
          //       }
          //     }),
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
      // floatingActionButton: Obx(
      //   () => FloatingActionButton(
      //     onPressed: () async {
      //       if (controller.isLoading.isFalse) {
      //         // ketika dipencet ubah ke true,
      //         controller.isLoading.value = true;
      //         // lalu logout
      //         await FirebaseAuth.instance.signOut();
      //         // Ubah ke false lagi
      //         controller.isLoading.value = false;
      //         // baru masuk ke halama login
      //         Get.offAllNamed(Routes.LOGIN_PAGE);
      //       }
      //     },
      //     child: controller.isLoading.isFalse
      //         ? const Icon(Icons.logout)
      //         : const CircularProgressIndicator(
      //             color: Colors.white,
      //           ),
      //   ),
      // ),
    );
  }
}
