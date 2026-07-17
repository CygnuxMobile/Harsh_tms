import 'package:get/get.dart';

import 'loading_controller.dart';

class LoadingBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<LoadingController>(() => LoadingController());
  }
}
