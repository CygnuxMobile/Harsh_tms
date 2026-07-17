import 'package:get/get.dart';
import 'package:harsh/moduls/prq_page/prq_controller.dart';

class PrqBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrqController>(() => PrqController());
  }
}
