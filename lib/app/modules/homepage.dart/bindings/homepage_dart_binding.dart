import 'package:get/get.dart';

import '../controllers/homepage_dart_controller.dart';

class HomepageDartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomepageDartController>(
      () => HomepageDartController(),
    );
  }
}
