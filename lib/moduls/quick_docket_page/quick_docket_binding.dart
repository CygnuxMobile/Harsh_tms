import 'package:get/get.dart';
import 'package:harsh/moduls/quick_docket_page/quick_docket_controller.dart';

class QuickDocketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuickDocketController>(() => QuickDocketController());
  }
}
