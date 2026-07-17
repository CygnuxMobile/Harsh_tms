import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harsh/utils/pref.dart';
import 'package:harsh/utils/tmsapi_method.dart';
import 'package:harsh/utils/tmsapp_api.dart';
import 'package:harsh/widgets/tost.dart';
import '../../app_routes.dart';
import '../../model/dash_board_model/location_master.dart';
import '../../utils/logging.dart';
import '../../model/loading_model/ledger_master_data_model.dart';
import '../../model/loading_model/city_route_code_model.dart';
import '../../model/loading_model/vehicle_no_model.dart';
import '../../model/loading_model/freight_type_model.dart';
import '../../model/loading_model/weight_type_model.dart';
import '../../model/loading_model/tripsheet_no_model.dart';
import '../../model/loading_model/driver_details_model.dart';
import '../../model/loading_model/type_of_movement_model.dart';
import 'package:harsh/widgets/custom_loader.dart';
import 'package:intl/intl.dart';

import '../../widgets/submit_alert_dialog.dart';

class LoadingController extends GetxController {
  var isSearchLoading = false.obs;
  var isConsignorSearchLoading = false.obs;
  var isConsigneeSearchLoading = false.obs;
  var isLocationLoading = false.obs;
  var isCityRouteLoading = false.obs;
  var isVehicleLoading = false.obs;
  var isTypeOfMovementLoading = false.obs;
  var isFreightTypeLoading = false.obs;
  var isWeightTypeLoading = false.obs;
  var isTripsheetLoading = false.obs;
  final log = logger;
  RxList<LocationList> location = <LocationList>[].obs;
  FocusNode hideTextFocus = FocusNode();
  final appLoader = AppLoader();

  final formKey = GlobalKey<FormState>();

  // Dropdown lists
  var cityRouteList = <CityRouteData>[].obs;
  var cityRouteNames = <String>[].obs;
  var vehicleList = <VehicleData>[].obs;
  var vehicleNames = <String>[].obs;
  var typeOfMovementList = <String>[].obs;
  var typeOfMovementDataList = <TypeOfMovementData>[].obs;
  var customerList = <String>[].obs;
  var filteredCustomerList = <String>[].obs;
  var filteredConsignorList = <String>[].obs;
  var filteredConsigneeList = <String>[].obs;
  var freightTypeList = <String>[].obs;
  var weightTypeList = <String>[].obs;
  var tripsheetList = <String>[].obs;

  // Selected values
  var selectedEndLocation = "".obs;
  var selectedBilledAtLocation = "".obs;
  var selectedCustomer = "".obs;
  var selectedCityRoute = "".obs;
  var selectedVehicle = "".obs;
  var selectedTypeOfMovement = "".obs;
  var selectedTripsheet = "".obs;
  var selectedFreightType = "".obs;
  var selectedWeightType = "".obs;
  var loadingSlipDate = "Select Date".obs;
  var billingType = "Paid".obs;

  // Search controllers
  final searchCustomerController = TextEditingController();
  final searchConsignorController = TextEditingController();
  final searchConsigneeController = TextEditingController();

  // Radio button values
  var consignorType = 1.obs;
  var consigneeType = 1.obs;

  // Form Controllers
  final consignorNameController = TextEditingController();
  final consignorMobileController = TextEditingController();
  final consignorAddressController = TextEditingController();
  var selectedConsignorCode = "".obs;

  final consigneeNameController = TextEditingController();
  final consigneeMobileController = TextEditingController();
  final consigneeAddressController = TextEditingController();
  var selectedConsigneeCode = "".obs;

  final brokerNameController = TextEditingController();
  final brokerMobileController = TextEditingController();

  final driverNameController = TextEditingController();
  final driverCodeController = TextEditingController();
  final driverMobileController = TextEditingController();
  final driverLicenceController = TextEditingController();
  var licenceValidityDate = "Select Date".obs;

  final weightController = TextEditingController();
  final contractAmountController = TextEditingController(text: "0");
  final balanceController = TextEditingController(text: "0.00");
  final guaranteeController = TextEditingController();
  final advanceController = TextEditingController(text: "0");
  final startingKmReadingController = TextEditingController(text: "0");

  @override
  void onInit() {
    super.onInit();
    initialDataFetch();
    
    contractAmountController.addListener(calculateBalance);
    advanceController.addListener(calculateBalance);
  }

  void calculateBalance() {
    double contractAmount = double.tryParse(contractAmountController.text) ?? 0.0;
    double advance = double.tryParse(advanceController.text) ?? 0.0;

    if (advance > contractAmount) {
      advance = contractAmount;
      String formattedAdvance = advance % 1 == 0 ? advance.toInt().toString() : advance.toString();
      advanceController.value = TextEditingValue(
        text: formattedAdvance,
        selection: TextSelection.collapsed(offset: formattedAdvance.length),
      );
    }

    balanceController.text = (contractAmount - advance).toStringAsFixed(2);
  }

  Future<void> initialDataFetch() async {
    locationMasterDataApi();
    await fetchFreightTypes();
    await fetchWeightTypes();
    await fetchTypeOfMovement();
  }

  Future<void> locationMasterDataApi() async {
    location.clear();
    try {
      isLocationLoading.value = true;
      final dio.Response response = await WebService.tmsGetRequest(
          ApiService.getLocationMasterData + "?UserID=${Pref().getUserId()}");
      if (response.statusCode == 200) {
        dynamic responseData = response.data;
        GetLocationMasterData getLocationMasterData = await getLocationMasterDataFromJson(responseData);
        location.addAll(getLocationMasterData.data);
      }
    } catch (error) {
      log.e(error);
    } finally {
      isLocationLoading.value = false;
    }
  }

  String LocationName(String value) {
    if (value.isEmpty || !value.contains("-")) return value;
    return value.split("-")[0].trim();
  }

  Future<void> filterCustomers(String query) async {
    try {
      isSearchLoading.value = true;
      final response = await WebService.tmsGetRequest("${ApiService.baseUrl}V1/Master/GetCustList?Search=$query");
      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.data);
        if (decoded['data'] != null) {
          List<dynamic> data = decoded['data'];
          filteredCustomerList.value = data.map((e) => "${e['custcd']} - ${e['custnm']}").toList();
        } else {
          filteredCustomerList.clear();
        }
      }
    } catch (e) {
      log.e("Error searching Customers: $e");
    } finally {
      isSearchLoading.value = false;
    }
  }

  Future<void> filterConsignors(String query) async {
    try {
      isConsignorSearchLoading.value = true;
      final response = await WebService.tmsGetRequest("${ApiService.baseUrl}V1/Master/GetCustList?Search=$query");
      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.data);
        if (decoded['data'] != null) {
          List<dynamic> data = decoded['data'];
          filteredConsignorList.value = data.map((e) => "${e['custcd']} - ${e['custnm']}").toList();
        } else {
          filteredConsignorList.clear();
        }
      }
    } catch (e) {
      log.e("Error searching Consignors: $e");
    } finally {
      isConsignorSearchLoading.value = false;
    }
  }

  Future<void> filterConsignees(String query) async {
    try {
      isConsigneeSearchLoading.value = true;
      final response = await WebService.tmsGetRequest("${ApiService.baseUrl}V1/Master/GetCustList?Search=$query");
      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.data);
        if (decoded['data'] != null) {
          List<dynamic> data = decoded['data'];
          filteredConsigneeList.value = data.map((e) => "${e['custcd']} - ${e['custnm']}").toList();
        } else {
          filteredConsigneeList.clear();
        }
      }
    } catch (e) {
      log.e("Error searching Consignees: $e");
    } finally {
      isConsigneeSearchLoading.value = false;
    }
  }

  Future<void> fetchCityRoute({required String toCity}) async {
    try {
      isCityRouteLoading.value = true;
      cityRouteList.clear();
      cityRouteNames.clear();
      final response = await WebService.tmsGetRequest(
        "${ApiService.baseUrl}V1/Operation/GetCityRouteCode?FromCity=${Pref().getBaseLocation()}&ToCity=$toCity",
      );
      if (response.statusCode == 200) {
        CityRouteCodeModel model = cityRouteCodeModelFromJson(response.data);
        if (model.data != null) {
          cityRouteList.addAll(model.data!);
          cityRouteNames.addAll(model.data!.map((e) => e.rutnm ?? ""));
        }
      }
    } catch (e) {
      log.e("Error fetching City Route: $e");
    } finally {
      isCityRouteLoading.value = false;
    }
  }

  Future<void> fetchVehicles({required String city}) async {
    try {
      isVehicleLoading.value = true;
      vehicleList.clear();
      vehicleNames.clear();
      final response = await WebService.tmsGetRequest(
        "${ApiService.baseUrl}V1/Operation/GetVehicleNo?FromCity=$city",
      );
      if (response.statusCode == 200) {
        VehicleNoModel model = vehicleNoModelFromJson(response.data);
        if (model.data != null) {
          vehicleList.addAll(model.data!);
          vehicleNames.addAll(model.data!.map((e) => e.vehno ?? ""));
        }
      }
    } catch (e) {
      log.e("Error fetching Vehicles: $e");
    } finally {
      isVehicleLoading.value = false;
    }
  }

  Future<void> fetchTypeOfMovement() async {
    try {
      isTypeOfMovementLoading.value = true;
      typeOfMovementList.clear();
      typeOfMovementDataList.clear();
      final response = await WebService.tmsGetRequest("${ApiService.getGeneralMasterData}?CodeType=FTLTYP");
      if (response.statusCode == 200) {
        TypeOfMovementModel model = typeOfMovementModelFromJson(response.data);
        if (model.data != null) {
          typeOfMovementDataList.addAll(model.data!);
          typeOfMovementList.addAll(model.data!.map((e) => e.codeDesc ?? "").toList());
        }
      }
    } catch (e) {
      log.e("Error fetching Type of Movement: $e");
    } finally {
      isTypeOfMovementLoading.value = false;
    }
  }

  Future<void> fetchTripsheets(String vehNo) async {
    try {
      isTripsheetLoading.value = true;
      tripsheetList.clear();
      final response = await WebService.tmsGetRequest("${ApiService.baseUrl}V1/Operation/GetTripsheetNo?vehno=$vehNo");
      if (response.statusCode == 200) {
        TripsheetNoModel model = tripsheetNoModelFromJson(response.data);
        if (model.data != null) {
          tripsheetList.addAll(model.data!.map((e) => e.vSlipNo ?? ""));
        }
      }
    } catch (e) {
      log.e("Error fetching Tripsheets: $e");
    } finally {
      isTripsheetLoading.value = false;
    }
  }

  Future<void> fetchVehicleKmReading(String vehNo) async {
    try {
      final response = await WebService.tmsGetRequest("${ApiService.baseUrl}V1/Operation/GetLoadingslipVehicleKmReading?Vehicleno=$vehNo");
      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.data);
        if (decoded['data'] != null && decoded['data'] is List && decoded['data'].isNotEmpty) {
          startingKmReadingController.text = decoded['data'][0]['current_KM_Read']?.toString() ?? "0";
        }
      }
    } catch (e) {
      log.e("Error fetching KM Reading: $e");
    }
  }

  Future<void> fetchDriverDetails(String vSlipNo) async {
    try {
      appLoader.show();
      final response = await WebService.tmsGetRequest("${ApiService.baseUrl}V1/Operation/GetTripSheetDriverDetails?VslipNo=$vSlipNo");
      if (response.statusCode == 200) {
        DriverDetailsModel model = driverDetailsModelFromJson(response.data);
        if (model.data != null && model.data!.isNotEmpty) {
          var driverData = model.data![0];
          driverNameController.text = driverData.driver1 ?? "";
          driverCodeController.text = driverData.driver1ID ?? "";
          driverLicenceController.text = driverData.licno1 ?? "";
          driverMobileController.text = driverData.moB1 ?? "";
          licenceValidityDate.value = driverData.validityDate1 ?? "";
        }
      }
    } catch (e) {
      log.e("Error fetching Driver Details: $e");
    } finally {
      appLoader.hide();
    }
  }

  Future<void> fetchFreightTypes() async {
    try {
      isFreightTypeLoading.value = true;
      freightTypeList.clear();
      final response = await WebService.tmsGetRequest("${ApiService.baseUrl}V1/Operation/GetFreightTypeList");
      if (response.statusCode == 200) {
        FreightTypeModel model = freightTypeModelFromJson(response.data);
        if (model.data != null) freightTypeList.addAll(model.data!.map((e) => e.text ?? ""));
      }
    } catch (e) {
      log.e(e);
    } finally {
      isFreightTypeLoading.value = false;
    }
  }

  Future<void> fetchWeightTypes() async {
    try {
      isWeightTypeLoading.value = true;
      weightTypeList.clear();
      final response = await WebService.tmsGetRequest("${ApiService.baseUrl}V1/Operation/GetWeightTypeList");
      if (response.statusCode == 200) {
        WeightTypeModel model = weightTypeModelFromJson(response.data);
        if (model.data != null) weightTypeList.addAll(model.data!.map((e) => e.text ?? ""));
      }
    } catch (e) {
      log.e(e);
    } finally {
      isWeightTypeLoading.value = false;
    }
  }

  Future<void> getConsignorConsigneeDetails(String selectedValue, bool isConsignor) async {
    String custCode = selectedValue.split(" - ")[0].trim();
    try {
      appLoader.show();
      final response = await WebService.tmsGetRequest("${ApiService.baseUrl}V1/Operation/GetLoadingSlipConsignorConsingnee?Custcode=$custCode");
      appLoader.hide();
      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.data);
        if (decoded['data'] != null && decoded['data'].isNotEmpty) {
          var dataObj = decoded['data'][0];
          if (isConsignor) {
            consignorNameController.text = dataObj['custnm']?.toString() ?? "";
            consignorMobileController.text = dataObj['mobileno']?.toString() ?? "";
            consignorAddressController.text = dataObj['custAddress']?.toString() ?? "";
            selectedConsignorCode.value = selectedValue;
          } else {
            consigneeNameController.text = dataObj['custnm']?.toString() ?? "";
            consigneeMobileController.text = dataObj['mobileno']?.toString() ?? "";
            consigneeAddressController.text = dataObj['custAddress']?.toString() ?? "";
            selectedConsigneeCode.value = selectedValue;
          }
        }
      }
    } catch (e) {
      appLoader.hide();
      log.e(e);
    }
  }

  String _formatToApiDate(String dateStr) {
    try {
      DateFormat inputFormat = DateFormat("dd-MM-yyyy HH:mm");
      DateTime dt = inputFormat.parse(dateStr);
      return dt.toIso8601String();
    } catch (e) {
      return DateTime.now().toIso8601String();
    }
  }

  Future<void> submitLoadingSlip(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    if (loadingSlipDate.value == "Select Date") {
       Get.snackbar("Required", "Please select Loading Slip Date", backgroundColor: Colors.orange, colorText: Colors.white);
       return;
    }

    String successMsg = "";

    try {
      appLoader.show();
      String ftlTypeCode = typeOfMovementDataList.firstWhereOrNull((e) => e.codeDesc == selectedTypeOfMovement.value)?.codeId ?? "";
      String routeCode = cityRouteList.firstWhereOrNull((e) => e.rutnm == selectedCityRoute.value)?.rutcd ?? "";

      Map<String, dynamic> requestData = {
        "objTripOpen": {
          "wfvi": {
            "manual_TripsheetNo": "NA",
            "vSlipDt": _formatToApiDate(loadingSlipDate.value),
            "tripSheet_StartLoc": Pref().getBaseLocation(),
            "tripSheet_EndLoc": LocationName(selectedEndLocation.value),
            "custcode": selectedCustomer.value.split(" - ").first.trim(),
            "ftlType": ftlTypeCode,
            "cityRouteCode": routeCode,
            "from_City": selectedCityRoute.value.split("-").first.trim(),
            "to_City": selectedCityRoute.value.split("-").last.trim(),
            "vehicle_Mode": "05",
            "vehicleNo": selectedVehicle.value,
            "tripSheetNo": selectedTripsheet.value,
            "csgncd" : "",
            "csgnnm" : "",
            "csgnmobile" : "",
            "csgnAddress" : "",
            "csgecd" : "",
            "csgenm" : "",
            "csgemobile" : "",
            "csgeAddress" : "",
            "brokerName" : "",
            "brokerConNo" : "",
            // "csgncd": consignorType.value == 2 ? "8888" : (selectedConsignorCode.value.isNotEmpty ? selectedConsignorCode.value.split(" - ").first.trim() : ""),
            // "csgnnm": consignorNameController.text,
            // "csgnmobile": consignorMobileController.text,
            // "csgnAddress": consignorAddressController.text,
            // "csgecd": consigneeType.value == 2 ? "8888" : (selectedConsigneeCode.value.isNotEmpty ? selectedConsigneeCode.value.split(" - ").first.trim() : ""),
            // "csgenm": consigneeNameController.text,
            // "csgemobile": consigneeMobileController.text,
            // "csgeAddress": consigneeAddressController.text,
            // "brokerName": brokerNameController.text,
            // "brokerConNo": brokerMobileController.text,
            "driver1_Name": driverNameController.text,
            "driver1": driverCodeController.text,
            "driver1_MobileNo": driverMobileController.text,
            "licno1": driverLicenceController.text,
            "validdt1": licenceValidityDate.value != "Select Date" && licenceValidityDate.value != "" ? licenceValidityDate.value : DateTime.now().toIso8601String(),
            "rate": 0,
            "weight": weightController.text.isNotEmpty ? weightController.text : "0",
            "weight_asper_Weighttype": selectedWeightType.value.isNotEmpty ? selectedWeightType.value[0] : "K",
            "weightType": selectedWeightType.value.isNotEmpty ? selectedWeightType.value[0] : "K",
            "guarantee" : "",
            "total_Freight" : 0,
            "driverAdvance" : 0,
            "advanceAmt" : 0,
            "actualFreight" : 0,
            "f_issue_startkm" : 0,
            "billed_at_Location" : "",
            // "guarantee": guaranteeController.text,
            // "total_Freight": double.tryParse(balanceController.text) ?? 0.0,
            // "driverAdvance": double.tryParse(advanceController.text) ?? 0.0,
            // "advanceAmt": double.tryParse(advanceController.text) ?? 0.0,
            // "actualFreight": double.tryParse(contractAmountController.text) ?? 0.0,
            // "f_issue_startkm": double.tryParse(startingKmReadingController.text) ?? 0.0,
            // "billed_at_Location": LocationName(selectedBilledAtLocation.value),
            "entryByLoc": Pref().getBaseLocation(),
            "companY_CODE": Pref().getCompanyCode(),
            "companyCode": Pref().getCompanyCode()
          },
          "baseUserName": Pref().getUserName(),
          "baseLocationCode": Pref().getBaseLocation(),
        }
      };

      final response = await WebService.tmsPostTokenRequest(url: ApiService.fleetLoadingSlip, body: jsonEncode(requestData));

      appLoader.hide();
      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.data);
        if (decoded['status'] == 200 || decoded['statusCode'] == 200) {
          submitAlertDialog(
            context: context,
            isPrintShow: false,
            title: '${decoded['data']['nextDocumentCode']}\nLoadingSlip number create successfully',
            onTap: () {
              clearAllFields();
              Get.toNamed(AppRoutes.dashboardScreen);
            },
            onTapText: 'Done',
            image: 'assets/images/dashboardimages/succes.png',
          );
        } else {
          TmsToast.msg("error ${ decoded['message']?.toString() ?? "Submission failed"}");
        }
      }
    } catch (e) {
      log.e(e);
      TmsToast.msg("Something went wrong");
    }

  }

  void clearAllFields() {
    selectedEndLocation.value = "";
    selectedBilledAtLocation.value = "";
    selectedCustomer.value = "";
    selectedCityRoute.value = "";
    selectedVehicle.value = "";
    selectedTypeOfMovement.value = "";
    selectedTripsheet.value = "";
    selectedFreightType.value = "";
    selectedWeightType.value = "";
    loadingSlipDate.value = "Select Date";
    
    searchCustomerController.clear();
    searchConsignorController.clear();
    searchConsigneeController.clear();
    
    consignorType.value = 1;
    consigneeType.value = 1;
    
    consignorNameController.clear();
    consignorMobileController.clear();
    consignorAddressController.clear();
    selectedConsignorCode.value = "";
    
    consigneeNameController.clear();
    consigneeMobileController.clear();
    consigneeAddressController.clear();
    selectedConsigneeCode.value = "";
    
    brokerNameController.clear();
    brokerMobileController.clear();
    
    driverNameController.clear();
    driverCodeController.clear();
    driverMobileController.clear();
    driverLicenceController.clear();
    licenceValidityDate.value = "Select Date";
    
    weightController.clear();
    contractAmountController.text = "0";
    balanceController.text = "0.00";
    guaranteeController.clear();
    advanceController.text = "0";
    startingKmReadingController.text = "0";
  }

  @override
  void onClose() {
    contractAmountController.removeListener(calculateBalance);
    advanceController.removeListener(calculateBalance);
    super.onClose();
  }
}
