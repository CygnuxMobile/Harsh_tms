import 'package:get/get.dart';
import 'package:harsh/moduls/fuel_trip_sheet_page/fuel_trip_sheet_controller.dart';

class FuelTripSheetBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => FuelTripSheetController());
  }
}
