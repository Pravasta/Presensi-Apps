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
            return Center(
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
                          user['profile'] != null
                              ? user['profile']
                              : defaultImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Welcome',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text('Belum ada lokasi'),
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '${user['nip']}',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${user['nama']}',
                        style: TextStyle(fontSize: 18),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text('Masuk'),
                          Text('-'),
                        ],
                      ),
                      Container(
                        width: 2,
                        height: 40,
                        color: Colors.grey,
                      ),
                      Column(
                        children: [
                          Text('Keluar'),
                          Text('-'),
                        ],
                      )
                    ],
                  ),
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
                    Text(
                      'Last 5 days',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.ALL_PRESENSI);
                      },
                      child: Text('See more'),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true, //untuk mengabungkan 2 list view
                  itemCount: 5,

                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200],
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          //Inkwell ada cahaya belakang ketika diklik
                          onTap: () {
                            Get.toNamed(Routes.DETAIL_PRESENSI);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Masuk',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${DateFormat.yMMMEd().format(DateTime.now())}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Text(
                                    '${DateFormat.jms().format(DateTime.now())}'),
                                SizedBox(height: 10),
                                Text('Keluar'),
                                Text(
                                    '${DateFormat.jms().format(DateTime.now())}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            );
          } else {
            return Center(
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
