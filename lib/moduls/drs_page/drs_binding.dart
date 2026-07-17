import 'package:get/get.dart';
import 'package:harsh/moduls/drs_page/drs_controller.dart';


class DRSBinding extends Bindings {


  @override
  void dependencies() {
    Get.lazyPut<DRSController>(() => DRSController());
  }
}
