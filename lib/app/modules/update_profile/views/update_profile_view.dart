import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  UpdateProfileView({Key? key}) : super(key: key);

  // Terima data arguments
  final Map<String, dynamic> user = Get.arguments;
  @override
  Widget build(BuildContext context) {
    // ubah value dari controller
    controller.nipC.text = user['nip'];
    controller.nameC.text = user['nama'];
    controller.emailC.text = user['email'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            readOnly: true,
            autocorrect: false,
            controller: controller.nipC,
            decoration: const InputDecoration(
              labelText: 'NIP',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            readOnly: true,
            autocorrect: false,
            controller: controller.emailC,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: controller.nameC,
            decoration: const InputDecoration(
              labelText: 'Nama',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Photo Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Masih ada permasalahan di bagian stream karena disini menggunakan Get.Arguments, maka nanti akan ada perubahan
              GetBuilder<UpdateProfileController>(
                builder: (c) {
                  // kalau image ada maka dia menampilkan foto terakhir saja
                  if (c.image != null) {
                    return ClipOval(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.file(
                          File(c.image!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  } else {
                    // jika null maka tanya lagi
                    // jika profile user nya tidak null maka menampilkan foto dari user profile
                    if (user['profile'] != null) {
                      return Column(
                        children: [
                          ClipOval(
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.network(
                                user['profile'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              controller.deleteProfile(user['uid']);
                            },
                            child: const Text('delete'),
                          ),
                        ],
                      );
                    } else {
                      return const Text('no image');
                    }
                  }
                },
              ),
              TextButton(
                onPressed: () {
                  controller.pickImage();
                },
                child: const Text('choosen'),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Obx(
            () => ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  await controller.updateProfile(user[
                      'uid']); //Uid sudah didapatkan juga di user, jadi tidak perlu tambahkan lagi FirebaseAuth di controller
                }
              },
              child: controller.isLoading.isFalse
                  ? const Text('UPDATE PROFILE')
                  : const Text('Loading'),
            ),
          ),
        ],
      ),
    );
  }
}
