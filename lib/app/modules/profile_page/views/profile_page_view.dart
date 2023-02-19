import 'package:app_presensi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_page_controller.dart';

class ProfilePageView extends GetView<ProfilePageController> {
  const ProfilePageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.streamUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // If untuk menghandle error
            if (snapshot.hasData) {
              Map<String, dynamic> user = snapshot.data!.data()!;
              String defaultImage =
                  'https://ui-avatars.com/api/?name=${user['nama']}';
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: Image.network(
                            // Jika user profile != null dan user profile != '' maka isi nya user profile
                            // jikaa null maka isinyaa https ui avatars
                            user['profile'] != null
                                ? user['profile'] != ''
                                    ? user['profile']
                                    : defaultImage
                                : defaultImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    user['nama'].toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    user['email'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    onTap: () => Get.toNamed(Routes.UPDATE_PROFILE,
                        arguments: user), // Mengirim User ke Update profile
                    leading: const Icon(Icons.person),
                    title: const Text('Update Profile'),
                  ),
                  ListTile(
                    onTap: () => Get.toNamed(Routes.UPDATE_PASSWORD),
                    leading: const Icon(Icons.vpn_key),
                    title: const Text('Update Password'),
                  ),
                  if (user['role'] == 'admin')
                    ListTile(
                      onTap: () => Get.toNamed(Routes.ADD_PEGAWAI),
                      leading: const Icon(Icons.person_add),
                      title: const Text('Add Pegawai'),
                    ),
                  ListTile(
                    onTap: () {
                      controller.logOut();
                    },
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text('Tidak dapat memuat data User..'),
              );
            }
          }),
    );
  }
}
