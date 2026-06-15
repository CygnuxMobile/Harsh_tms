import 'package:get/get.dart';
import 'package:harsh/moduls/web_view_page/web_view_controller.dart';

class WebViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebViewScreenController>(
        () => WebViewScreenController());
  }
}
