import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:harsh/moduls/expenses_page/sub_screen/expenses_add.dart';
import 'package:harsh/moduls/pod_page/pod_controller.dart';
import 'package:harsh/utils/pref.dart';
import 'package:intl/intl.dart';
import '../../app_routes.dart';
import '../../model/dash_board_model/get_general_master.dart';
import '../../model/dash_board_model/location_master.dart';
import '../../model/expenses_model/bank.dart';
import '../../model/expenses_model/expenses_list_model.dart';
import '../../utils/tmsapi_method.dart';
import '../../utils/tmsapp_api.dart';
import '../../widgets/custom_loader.dart';
import '../../widgets/tost.dart';

class ExpensesController extends GetxController {
  TextEditingController vehicleNumberController = TextEditingController(text: "DHR55M5177");
  TextEditingController tripSheetNoController = TextEditingController();
  TextEditingController fromDateController =
      TextEditingController(text: DateFormat('d MMM yyyy').format(DateTime.now().subtract(const Duration(days: 2))));
  TextEditingController toDateController = TextEditingController(text: DateFormat('d MMM yyyy').format(DateTime.now()));
  TextEditingController advancePlaceController = TextEditingController();
  TextEditingController advanceDataController = TextEditingController();
  TextEditingController chequeDateController = TextEditingController();
  TextEditingController bankRemarkController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController thcNumberController = TextEditingController();
  TextEditingController advancePaidByController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController chequeNoController = TextEditingController();
  TextEditingController rtgsNeftNoController = TextEditingController();
  TextEditingController fuelTimeQtyLtrController = TextEditingController();

  RxList<ExpensesList> expensesList = <ExpensesList>[].obs;
  RxList<LocationList> branchList = <LocationList>[].obs;
  RxList<GeneralMaster> paymentMode = <GeneralMaster>[].obs;
  RxList<LedgerMasterList> bankAccountList = <LedgerMasterList>[].obs;
  RxList<LedgerMasterList> cashAccountList = <LedgerMasterList>[].obs;
  RxList<LedgerMasterList> cardNumberList = <LedgerMasterList>[].obs;
  RxList<LedgerMasterList> fuelCardNumberList = <LedgerMasterList>[].obs;

  Rx<ApiStatus> expensesStatus = ApiStatus.none.obs;
  ExpensesScreenEnum expensesScreenEnum = ExpensesScreenEnum.none;

  RxString selectedBranch = ''.obs;
  RxString selectedBankAccount = ''.obs;
  RxString selectedCashAccount = ''.obs;
  RxString selectedCardNo = ''.obs;
  RxString selectedPaymentMode = ''.obs;
  RxString selectedAdvCode = ''.obs;
  RxString bankPaymentType = 'Cheque No.'.obs;

  expensesListApi() async {
    expensesStatus.value = ApiStatus.loading;
    final request = {
      "vehicleno": vehicleNumberController.text,
      "tripNo": tripSheetNoController.text,
      "fromDate": fromDateController.text,
      "toDate": toDateController.text,
      "tripsheetFlag": "FSE",
      "tripType": "T",
      "driver": "",
      "baseLocationCode": Pref().getBaseLocation(),
      "baseCompanyCode": Pref().getCompanyCode(),
      "updClose": "Close"
    };

    final response = await WebService.tmsPostTokenRequest(
      url: ApiService.GetVehicleIssueSlip,
      body: jsonEncode(request),
    );

    final data = jsonDecode(response.data);

    if (response.statusCode == 200) {
      if (data["data"] != null) {
        ExpensesResponse expensesResponse = expensesResponseFromJson(response.data);
        expensesList.value = expensesResponse.expensesList;
        expensesStatus.value = ApiStatus.success;
      } else {
        expensesStatus.value = ApiStatus.error;
      }
    } else {
      expensesStatus.value = ApiStatus.error;
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

  paymentModeApi() async {
    final response = await WebService.tmsGetRequest(ApiService.getGeneralMasterData + "?CodeType=PAYMODE");

    final data = jsonDecode(response.data);

    if (response.statusCode == 200) {
      if (data["data"] != null) {
        GetGeneralMasterData getGeneralMasterData = getGeneralMasterDataFromJson(response.data);
        paymentMode.value = getGeneralMasterData.data;
      }
    }
  }

  bankDetailsApi() async {
    final response = await WebService.tmsGetRequest(ApiService.GetLedgerMasterData + "?CodeType=BANK");

    final data = jsonDecode(response.data);
    if (response.statusCode == 200) {
      if (data["data"] != null) {
        GetLedgerMasterData getLedgerMasterData = getLedgerMasterDataFromJson(response.data);
        bankAccountList.value = getLedgerMasterData.data;
      }
    }
  }

  cashAccountApi() async {
    final response = await WebService.tmsGetRequest(ApiService.GetLedgerMasterData + "?CodeType=CASH");

    final data = jsonDecode(response.data);
    if (response.statusCode == 200) {
      if (data["data"] != null) {
        GetLedgerMasterData getLedgerMasterData = getLedgerMasterDataFromJson(response.data);
        cashAccountList.value = getLedgerMasterData.data;
      }
    }
  }

  cardNumberApi() async {
    final response = await WebService.tmsGetRequest(ApiService.GetLedgerMasterData + "?CodeType=ATM Card");

    final data = jsonDecode(response.data);
    if (response.statusCode == 200) {
      if (data["data"] != null) {
        GetLedgerMasterData getLedgerMasterData = getLedgerMasterDataFromJson(response.data);
        cardNumberList.value = getLedgerMasterData.data;
      }
    }
  }

  expensesSubmitApi({
    String vSlipNo = "",
    String advLoc = "",
    String advDate = "",
    String branchCode = "",
    String paymentMode = "",
    String chequeNo = "",
    String chequeDate = "",
    String advAcccode = "",
    String advAmt = "0",
    int qtyInLtr = 0,
    String remarks = "",
  }) async {
    AppLoader().show();
    final request = {
      "vSlipNo": vSlipNo,
      "baseYearVal": "",
      "baseFinYear": "",
      "baseCompanyCode": Pref().getCompanyCode(),
      "baseUserName": Pref().getUserId(),
      "advList": [
        {
          "vSlipNo": vSlipNo,
          "advLoc": advLoc,
          "advDate": advDate,
          "advAmt": advAmt,
          "branchCode": branchCode,
          "signature": Pref().getUserId(),
          "paymentMode": paymentMode,
          "chequeNo": chequeNo,
          "chequeDate": chequeDate,
          "adv_acccode": advAcccode,
          "thCno": "Without Document",
          "qtyInLtr": qtyInLtr,
          "remarks": remarks
        }
      ]
    };

    jsonEncode(request);

    final response = await WebService.tmsPostTokenRequest(
      url: ApiService.AdvanceandFuleEntrySubmit,
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
