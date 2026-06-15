import 'package:get/get.dart';
import 'package:harsh/moduls/docket_page/docket_controller.dart';



class DocketBinding extends Bindings {


  @override
  void dependencies() {
    Get.lazyPut<DocketController>(() => DocketController());
  }
}

