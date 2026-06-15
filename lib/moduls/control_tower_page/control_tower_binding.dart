import 'package:get/get.dart';
import 'package:harsh/moduls/control_tower_page/control_tower_controller.dart';

class ControlTowerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControlTowerController());
  }
}
