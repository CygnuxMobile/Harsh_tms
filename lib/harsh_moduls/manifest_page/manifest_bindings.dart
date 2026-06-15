import 'package:get/get.dart';

import 'manifest_controller.dart';

class HarshManifestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HarshManifestController>(() => HarshManifestController());
  }
}
