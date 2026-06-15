import 'package:get/get.dart';
import 'package:harsh/moduls/pod_page/pod_controller.dart';

class PodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PodUploadController>(() => PodUploadController());
  }
}
