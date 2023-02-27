import 'package:app_presensi/app/controllers/page_index_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  DetailPresensiView({Key? key}) : super(key: key);

  // tangkap arguments dari page routes nya
  final Map<String, dynamic> data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    print(data);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Presensi'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[200],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    DateFormat.yMEd()
                        .format(DateTime.parse(data['date']))
                        .replaceAll('/', '-'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                const Text(
                  'Masuk',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                    'Jam : ${DateFormat.jms().format(DateTime.parse(data['masuk']['date']))}'),
                Text(
                    'Posisi : ${data['masuk']['lat']} , ${data['masuk']['long']}'),
                Text('Status : ${data['masuk']['status']}'),
                Text(
                    'Distance : ${data['masuk']!['distance'].toString().split('.').first} meter'),
                Text('Address : ${data['masuk']!['address']}'),
                const SizedBox(height: 20),
                const Text(
                  'Keluar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(data['keluar']?['date'] == null
                    ? 'Jam : -'
                    : 'Jam : ${DateFormat.jms().format(DateTime.parse(data['keluar']!['date']))}'),
                Text(data['keluar']?['lat'] == null &&
                        data['keluar']?['long'] == null
                    ? 'Posisi : -'
                    : 'Posisi : ${data['keluar']!['lat']}, ${data['keluar']!['long']}'),
                Text(data['keluar']?['status'] == null
                    ? 'Status : -'
                    : 'Status : ${data['keluar']!['status']}'),
                Text(data['keluar']?['distance'] == null
                    ? 'Distance : -'
                    : 'Distance : ${data['keluar']!['distance'].toString().split('.').first} meter'),
                Text(data['keluar']?['address'] == null
                    ? 'Address : -'
                    : 'Address : ${data['keluar']!['address']}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
