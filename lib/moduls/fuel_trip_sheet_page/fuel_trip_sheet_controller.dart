import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:harsh/app_routes.dart';
import 'package:harsh/model/fuel_trip_sheet_model/fuel_trip_sheet_model.dart';
import 'package:harsh/moduls/pod_page/pod_controller.dart';
import 'package:harsh/utils/pref.dart';
import 'package:harsh/utils/tmsapi_method.dart';
import 'package:harsh/widgets/custom_loader.dart';
import 'package:harsh/widgets/tost.dart';
import 'package:intl/intl.dart';
import '../../model/fuel_trip_sheet_model/vendor_list_response.dart';
import '../../utils/date_format.dart';
import '../../utils/tmsapp_api.dart';

class FuelTripSheetController extends GetxController {
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController tripSheetNoController = TextEditingController();
  TextEditingController fromDateController =
      TextEditingController(text: DateFormat('d MMM yyyy').format(DateTime.now().subtract(const Duration(days: 2))));
  TextEditingController toDateController = TextEditingController(text: DateFormat('d MMM yyyy').format(DateTime.now()));
  TextEditingController fuelEntryDateController = TextEditingController(text: DateFormat('dd MMMM yyyy').format(DateTime.now()));
  TextEditingController quantityInLitersController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController vendorSearchController = TextEditingController();
  TextEditingController fuelVendorSearchController = TextEditingController();
  TextEditingController fuelVendorController = TextEditingController();
  TextEditingController fuelVendorCodeController = TextEditingController();
  TextEditingController fuelVendors = TextEditingController();

  RxList<FuelTripList> fuelTripList = <FuelTripList>[].obs;
  RxList<VendorList> vendorList = <VendorList>[].obs;

  Rx<ApiStatus> fuelTripStatus = ApiStatus.loading.obs;
  RxString vendorType = ''.obs;

  RxBool isLoading = false.obs;

  fuelTripSheet() async {
    fuelTripStatus.value = ApiStatus.loading;
    var request = {
      "vehicleno": vehicleNumberController.text,
      "fromDate": fromDateController.text,
      "toDate": toDateController.text,
      "tripSheetNo": tripSheetNoController.text,
      "tripActionType": "FSE",
      "baseLocationCode": Pref().getBaseLocation(),
      "tripFTType": "T",
      "baseCompanyCode": Pref().getCompanyCode()
    };

    final response = await WebService.tmsPostTokenRequest(
      url: ApiService.fuelTripSheet,
      body: jsonEncode(request),
    );

    final data = jsonDecode(response.data);

    try {
      if (response.statusCode == 200) {
        if (data["data"] != null) {
          FuelTripListResponse fuelTripListResponse = fuelTripListResponseFromJson(response.data);
          fuelTripList.value = fuelTripListResponse.fuelTripList;
          fuelTripStatus.value = ApiStatus.success;
        } else {
          fuelTripStatus.value = ApiStatus.error;
        }
      } else {
        fuelTripStatus.value = ApiStatus.error;
      }
    } catch (error) {
      fuelTripStatus.value = ApiStatus.error;
    }
  }

  fuelVendorListApi(value) async {
    isLoading.value = true;
    try {
      final response = await WebService.tmsGetRequest(ApiService.GetVendorList + value);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.data);
        if (data["data"] != null) {
          VendorListResponse vendorListResponse = vendorListResponseFromJson(response.data);
          vendorList.value = vendorListResponse.data;
        }
      } else {
        print("error");
      }
    } catch (e) {
      print("error");
    } finally {
      isLoading.value = false;
    }
  }

  fuelSubmitApi({
    String vSlipNo = "",
    String fuelvendor = "",
    double quantityinliter = 0,
    double rate = 0,
    double amount = 0,
    int sliptype = 0,
    String vehicleNo = "",
    String fuelSlipDate = "",
  }) async {
    AppLoader().show();
    final request = {
      "vSlipNo": vSlipNo,
      "fuelslipno": "",
      "fuelvendor": fuelvendor,
      "quantityinliter": quantityinliter,
      "rate": rate,
      "amount": amount,
      "baseUserName": Pref().getUserId(),
      "baseLocationCode": Pref().getBaseLocation(),
      "vehicleNo": vehicleNo,
      "sliptype": sliptype,
      "baseCompanyCode": Pref().getCompanyCode(),
      "baseYearVal": "",
      "baseFinYear": "",
      "fuelSlipDate": fuelSlipDate,
      "thcno": ""
    };

    jsonEncode(request);

    final response = await WebService.tmsPostTokenRequest(
      url: ApiService.FuelTripSheetSubmitApi,
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
    }else{
      TmsToast.msg("Something went wrong");
    }
  }
}
