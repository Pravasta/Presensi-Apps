import 'package:app_presensi/app/routes/app_pages.dart';
import 'package:get/get.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  void changePage(int i) {
    print('Click index = $i');

    switch (i) {
      case 1:
        print('absen');
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
}
