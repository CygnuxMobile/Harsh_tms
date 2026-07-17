import 'package:get/get.dart';

import 'expenses_controller.dart';

class ExpensesBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => ExpensesController());
  }
}
