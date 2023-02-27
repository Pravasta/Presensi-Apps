import 'package:app_presensi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changePage(int i) async {
    print('Click index = $i');

    switch (i) {
      case 1:
        print('absen');
        // Karena tipe position maka bisa diubah ke Var Postition
        Map<String, dynamic> dataResponse = await _determinePosition();
        // cek apakah data response nya error
        if (dataResponse['error'] != true) {
          //Bisa juga !dataRespones['error']
          Position position = dataResponse['position'];
          // Convert ke lokasi kita
          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);

          String address =
              '${placemarks[0].name}, ${placemarks[0].subLocality}, ${placemarks[0].locality}';
          // Tambahkan position kita saat ini
          await updatePosition(position, address);

          // cek jarak terlebih dahulu dari kantor ke tempat absen
          double distance = Geolocator.distanceBetween(
              -7.5560692, 110.8516778, position.latitude, position.longitude);

          // Jangan lupa tambahkan absensi nya
          await presensi(position, address, distance);

          // Print lokasi kita saat ini
          // print('${position.latitude}, ${position.longitude}');
        } else {
          Get.defaultDialog(
              title: 'Terjadi Kesalahan.',
              middleText: '${dataResponse['message']}');
        }
        break;
      case 2:
        // Set index nya di i
        pageIndex.value = i;
        Get.offAllNamed(Routes.PROFILE_PAGE);
        break;
      default:
        // Set index nya di i
        pageIndex.value = i;
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> presensi(
      Position position, String address, double distance) async {
    String uid = await auth.currentUser!.uid;

    // membuat collection presence di setiap uid
    CollectionReference<Map<String, dynamic>> colPresence =
        await firestore.collection('pegawai').doc(uid).collection('presance');

    // Membuat doc disetiap collec uid baru
    QuerySnapshot<Map<String, dynamic>> snapPresence = await colPresence.get();

    // print(snapPresence.docs.length);
    DateTime now = DateTime.now();
    String todayDocUid = DateFormat.yMd().format(now).replaceAll('/', '-');

    // logic distance
    String status = 'Di Luar Area';
    if (distance <= 2000) {
      status = 'Di Dalam Area';
    }

    // cek 2 kondisi ada atau tidak
    if (snapPresence.docs.isEmpty) {
      // Tampilkan dialog untuk validasi lakukan absen
      await Get.defaultDialog(
          title: 'Validasi Presensi',
          middleText:
              'Apakah kamu yakin melakukan presensi ( MASUK ) sekarang ? ',
          actions: [
            OutlinedButton(
                onPressed: () => Get.back(), child: const Text('CANCEL')),
            ElevatedButton(
                onPressed: () async {
                  // Belum pernah absen
                  await colPresence.doc(todayDocUid).set(
                    {
                      'date': now.toIso8601String(), //Ini untuk order by
                      'masuk': {
                        'date': now.toIso8601String(),
                        'lat': position.latitude,
                        'long': position.longitude,
                        'address': address,
                        'status': status,
                        'distance': '$distance meter'
                      }
                    },
                  );
                  Get.back();
                  Get.snackbar(
                      'Berhasil', 'Anda telah berhasil melakukan Presensi');
                },
                child: const Text('YES')),
          ]);
    } else {
      // sudah pernah absen masuk / keluar belum hari ini ?
      // 1. Get data terlebih dahulu
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await colPresence.doc(todayDocUid).get();

      // Cek apakah ada data absensi pada hari ini
      if (todayDoc.exists) {
        // tinggal absen keluar atau sudah absen masuk dan keluar (informasi)
        // Ambil data terlebih dahulu
        Map<String, dynamic>? mapTodayData = todayDoc.data();
        if (mapTodayData?['keluar'] != null) {
          // tinggal info saja sudah keluar atau belum
          String informasi = 'Informasi Penting';
          Get.snackbar(informasi,
              'Anda sudah melakukan absensi masuk dan keluar hari ini. Tidak bisa mengubah data kembali.');
        } else {
          await Get.defaultDialog(
              title: 'Validasi Presensi',
              middleText:
                  'Apakah kamu yakin melakukan presensi ( KELUAR ) sekarang ? ',
              actions: [
                OutlinedButton(
                    onPressed: () => Get.back(), child: const Text('CANCEL')),
                ElevatedButton(
                    onPressed: () async {
                      // Belum pernah absen
                      // absen keluar
                      await colPresence.doc(todayDocUid).update({
                        'keluar': {
                          'date': now.toIso8601String(),
                          'lat': position.latitude,
                          'long': position.longitude,
                          'address': address,
                          'status': status,
                          'distance': '$distance meter'
                        }
                      });
                      Get.back();
                      Get.snackbar(
                          'Berhasil', 'Anda telah berhasil melakukan Presensi');
                    },
                    child: const Text('YES')),
              ]);
        }
      } else {
        // kalau belum ada berarti langsung masuk absen pertama pada hari ini
        // Belum pernah absen / absen masuk hari ini
        await Get.defaultDialog(
          title: 'Validasi Presensi',
          middleText:
              'Apakah kamu yakin melakukan presensi ( MASUK ) sekarang ? ',
          actions: [
            OutlinedButton(
                onPressed: () => Get.back(), child: const Text('CANCEL')),
            ElevatedButton(
                onPressed: () async {
                  await colPresence.doc(todayDocUid).set(
                    {
                      'date': now.toIso8601String(), //Ini untuk order by
                      'masuk': {
                        'date': now.toIso8601String(),
                        'lat': position.latitude,
                        'long': position.longitude,
                        'address': address,
                        'status': status,
                        'distance': '$distance meter'
                      }
                    },
                  );
                  Get.back();
                  Get.snackbar(
                      'Berhasil', 'Anda telah berhasil melakukan Presensi');
                },
                child: const Text('YES')),
          ],
        );
      }
    }
  }

  // Setelah kita dapat position => Kita harus membuat lokasi terakhir kita juga
  Future<void> updatePosition(Position position, String address) async {
    // Ambil uid user saat ini
    String uid = await auth.currentUser!.uid;
    // Masuk ke firestore
    firestore.collection('pegawai').doc(uid).update({
      'position': {
        'lat': position.latitude,
        'long': position.longitude,
      },
      'address': address,
    });
  }

  Future<Map<String, dynamic>> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // return Future.error('Location services are disabled.');
      return {
        'message': 'GPS tidak menyala, silahkan nyalakan GPS anda',
        'error': true,
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // return Future.error('Location permissions are denied');
        return {
          'message': 'Izin mengakses GPS ditolak',
          'error': true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        'message': 'Izin akses GPS ditolak permanent',
        'error': true,
      };
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return {
      'message': 'Berhasil mendapatkan posisi device',
      'position': position,
      'error': false,
    };
  }
}
