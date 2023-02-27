import 'package:app_presensi/app/controllers/page_index_controller.dart';
import 'package:app_presensi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final pageC = Get.find<PageIndexController>();
  HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME'),
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

          // Setelah dapat kan stream builder data maka didapatkan bentuk mapping dari data
          // Cek apakah terdapat data ?
          if (snapshot.hasData) {
            Map<String, dynamic> user =
                snapshot.data!.data()!; //baru gunakan untuk ambil data user
            String defaultImage =
                'https://ui-avatars.com/api/?name=${user['nama']}';
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: Container(
                        width: 75,
                        height: 75,
                        color: Colors.grey[200],
                        child: Image.network(
                          user['profile'] ?? defaultImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 250,
                          child: Text(
                            'Welcome ${user['nama']}',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: 250,
                          child: Text(
                            '${user['address'] ?? 'Belum ada lokasi'}',
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(35),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user['job']}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${user['nip']}',
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${user['nama']}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(35),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: controller.streamTodayPresance(),
                      builder: (context, snapDateToday) {
                        if (snapDateToday.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        Map<String, dynamic>? dateToday =
                            snapDateToday.data?.data();
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  'Masuk',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  dateToday?['masuk'] == null
                                      ? '-'
                                      : DateFormat.jms().format(
                                          DateTime.parse(
                                              dateToday!['masuk']['date']),
                                        ),
                                ),
                              ],
                            ),
                            Container(
                              width: 2,
                              height: 40,
                              color: Colors.grey,
                            ),
                            Column(
                              children: [
                                const Text(
                                  'Keluar',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  dateToday?['keluar'] == null
                                      ? '-'
                                      : DateFormat.jms().format(
                                          DateTime.parse(
                                              dateToday!['keluar']['date']),
                                        ),
                                ),
                              ],
                            )
                          ],
                        );
                      }),
                ),
                const SizedBox(height: 20),
                Divider(
                  color: Colors.grey[300],
                  thickness: 2,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Last 5 days',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.ALL_PRESENSI);
                      },
                      child: const Text('See more'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: controller.streamPresance(),
                    builder: (context, snapPresance) {
                      if (snapPresance.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapPresance.data!.docs.isEmpty ||
                          snapPresance.data?.docs == null) {
                        return const SizedBox(
                          height: 200,
                          child: Center(
                            child: Text(
                              'Belum ada Data Presensi',
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true, //untuk mengabungkan 2 list view
                        itemCount: snapPresance.data?.docs.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          // untuk dapatkan data presensi
                          Map<String, dynamic> data =
                              snapPresance.data!.docs[index].data();
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[200],
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                //Inkwell ada cahaya belakang ketika diklik
                                onTap: () {
                                  Get.toNamed(
                                    Routes.DETAIL_PRESENSI,
                                    arguments:
                                        data, // ketika masuk ke detail membawa data berupa data type Map String dynamic
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      20,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Masuk',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            DateFormat.yMEd().format(
                                                DateTime.parse(data['date'])),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      // Cek apkaah data ada. kalau ada baru masuk dan ubah iso string ke date time lagi
                                      Text(data['masuk']?['date'] == null
                                          ? "-"
                                          : DateFormat.jms().format(
                                              DateTime.parse(
                                                  data['masuk']!['date']))),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Keluar',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(data['keluar']?['date'] == null
                                          ? "-"
                                          : DateFormat.jms().format(
                                              DateTime.parse(
                                                  data['keluar']!['date']))),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    })
              ],
            );
          } else {
            return const Center(
              child: Text('Tidak dapat memuat data user'),
            );
          }
        },
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.fingerprint, title: 'Add'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        initialActiveIndex: pageC.pageIndex.value,
        onTap: (int i) => pageC.changePage(i),
      ),
    );
  }
}
