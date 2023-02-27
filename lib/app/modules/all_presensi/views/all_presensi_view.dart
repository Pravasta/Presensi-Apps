import 'package:app_presensi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../controllers/all_presensi_controller.dart';

class AllPresensiView extends GetView<AllPresensiController> {
  const AllPresensiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Presensi'),
        centerTitle: true,
      ),
      body: GetBuilder<AllPresensiController>(
        builder: (controller) =>
            FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: controller.getAllPresance(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snap.data!.docs.isEmpty || snap.data?.docs == null) {
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
              padding: const EdgeInsets.all(20),
              itemCount: snap.data?.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data = snap.data!.docs[index].data();
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Masuk',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  DateFormat.yMEd()
                                      .format(DateTime.parse(data['date'])),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            // Cek apkaah data ada. kalau ada baru masuk dan ubah iso string ke date time lagi
                            Text(data['masuk']?['date'] == null
                                ? "-"
                                : DateFormat.jms().format(
                                    DateTime.parse(data['masuk']!['date']))),
                            const SizedBox(height: 10),
                            const Text(
                              'Keluar',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(data['keluar']?['date'] == null
                                ? "-"
                                : DateFormat.jms().format(
                                    DateTime.parse(data['keluar']!['date']))),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // syncffusion date picker
          // get dialog agar bisa diberi widget didalam sebuah onpress
          Get.dialog(
            Dialog(
              child: Container(
                padding: const EdgeInsets.all(20),
                height: 400,
                child: SfDateRangePicker(
                  monthViewSettings:
                      const DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                  selectionMode: DateRangePickerSelectionMode.range,
                  showNavigationArrow: true,
                  showTodayButton: true,
                  showActionButtons: true,
                  onCancel: () => Get.back(),
                  onSubmit: (p0) {
                    if ((p0 as PickerDateRange).endDate != null) {
                      controller.pickDate(p0.startDate!, p0.endDate!);
                    }
                  },
                ),
              ),
            ),
          );
        },
        child: const Icon(
          Icons.format_list_bulleted_rounded,
        ),
      ),
    );
  }
}
