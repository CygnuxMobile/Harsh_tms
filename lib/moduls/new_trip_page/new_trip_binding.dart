import 'package:get/get.dart';

import 'new_trip_controller.dart';

class NewTripBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => NewTripController());
  }
}
