import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:harsh/model/new_trip_model/driverDetails.dart';
import 'package:harsh/utils/pref.dart';
import 'package:harsh/utils/tmsapi_method.dart';
import 'package:harsh/utils/tmsapp_api.dart';
import '../../app_routes.dart';
import '../../model/dash_board_model/location_master.dart';
import '../../model/new_trip_model/vehicleDetails.dart';
import '../../widgets/custom_loader.dart';
import '../../widgets/tost.dart';

class NewTripController extends GetxController {
  RxList<VehicleDetailsList> vehicleDetailsList = <VehicleDetailsList>[].obs;
  RxList<DriverDetails> driverDetails = <DriverDetails>[].obs;
  RxList<LocationList> branchList = <LocationList>[].obs;

  RxString selectedVehicle = ''.obs;
  RxString selectedStartLocation = ''.obs;
  RxString selectedEndLocation = ''.obs;
  RxString selectedEndNameLocation = ''.obs;
  RxString selectedDriver = ''.obs;

  TextEditingController driverNameController = TextEditingController();
  TextEditingController driverLicenseNoController = TextEditingController();
  TextEditingController driverLicenseValidUpToController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController startKmController = TextEditingController();

  vehicleDetailsApi() async {
    final request = {
      "vehno": "",
      "brcd": Pref().getBaseLocation(),
      "vendortype": "05",
    };

    final response = await WebService.tmsPostTokenRequest(
      url: ApiService.TripVehicleDetails,
      body: jsonEncode(request),
    );

    final data = jsonDecode(response.data);

    if (response.statusCode == 200) {
      if (data["data"] != null) {
        VehicleDetails vehicleDetails = vehicleDetailsFromJson(response.data);
        vehicleDetailsList.value = vehicleDetails.data;
      }
    }
  }

  driverDetailsApi() async {
    final request = {"brcd": Pref().getBaseLocation(), "vehicle_No": ""};

    final response = await WebService.tmsPostTokenRequest(
      url: ApiService.TripDriverDetails,
      body: jsonEncode(request),
    );

    final data = jsonDecode(response.data);

    if (response.statusCode == 200) {
      if (data["data"] != null) {
        DriverDetailsModel driverDetailsModel = driverDetailsModelFromJson(response.data);
        driverDetails.value = driverDetailsModel.data;
      }
    }
  }

  Future<void> locationMasterDataApi() async {
    try {
      final response = await WebService.tmsGetRequest(ApiService.getLocationMasterData + "?UserID=${Pref().getUserId()}");
      if (response.statusCode == 200) {
        dynamic responseData = response.data;
        GetLocationMasterData getLocationMasterData = await getLocationMasterDataFromJson(responseData);
        branchList.value = getLocationMasterData.data;
      } else {
        if (response.statusCode == 401) {
        } else {
          print('${response.statusCode} : ${response.data.toString()}');
        }
      }
    } catch (error) {
      print(error);
    }
  }

  newTripSubmitApi({
    String vehicleNo = '',
    String startLocation = '',
    String endLocation = '',
    String endLocationName = '',
    String driver = '',
    String driverName = '',
    String driverMobileNo = '',
    double startKm = 0,
  }) async {
    final request = {
      "userName": Pref().getUserId(),
      "baseLocationCode": Pref().getBaseLocation(),
      "vehicleNo": vehicleNo,
      "startKM": startKm,
      "startLocation": startLocation,
      "endLocation": endLocation,
      "endLocationName": endLocationName,
      "driver1": driver,
      "driver1_Name": driverName,
      "driver1_MobileNo": driverMobileNo,
      "category": "Internal Usage",
      "marketOwn": "Own",
      "vehicle_Mode": "05",
      "finYear": "",
      "yearSuffix": "",
      "companyCode": Pref().getCompanyCode()
    };

    final response = await WebService.tmsPostTokenRequest(
      url: ApiService.AddTripOpen,
      body: jsonEncode(request),
    );

    AppLoader().hide();
    final data = jsonDecode(response.data);
    if (response.statusCode == 200) {
      if (data["data"] != null) {
        TmsToast.msg("Success");
        Get.offNamed(AppRoutes.dashboardScreen);
      } else {
        TmsToast.msg("Something went wrong");
      }
    } else {
      TmsToast.msg("Something went wrong");
    }
  }
}
