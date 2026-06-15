import 'dart:convert';

ExpensesResponse expensesResponseFromJson(String str) => ExpensesResponse.fromJson(json.decode(str));

String expensesResponseToJson(ExpensesResponse data) => json.encode(data.toJson());

class ExpensesResponse {
  final int statusCode;
  final int status;
  final List<ExpensesList> expensesList;
  final dynamic errors;
  final dynamic metaData;
  final String message;

  ExpensesResponse({
    required this.statusCode,
    required this.status,
    required this.expensesList,
    required this.errors,
    required this.metaData,
    required this.message,
  });

  factory ExpensesResponse.fromJson(Map<String, dynamic> json) => ExpensesResponse(
    statusCode: json["statusCode"],
    status: json["status"],
    expensesList: List<ExpensesList>.from(json["data"].map((x) => ExpensesList.fromJson(x))),
    errors: json["errors"],
    metaData: json["metaData"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "status": status,
    "data": List<dynamic>.from(expensesList.map((x) => x.toJson())),
    "errors": errors,
    "metaData": metaData,
    "message": message,
  };
}

class ExpensesList {
  final dynamic tripRouteType;
  final String category;
  final String vSlipNo;
  final dynamic manualTripsheetNo;
  final String vSlipDt;
  final String vehicleNo;
  final String driverName;
  final dynamic tripSheetEndLoc;
  final dynamic licenseNo;
  final dynamic valdityDt;
  final int srNo;
  final dynamic type;

  ExpensesList({
    required this.tripRouteType,
    required this.category,
    required this.vSlipNo,
    required this.manualTripsheetNo,
    required this.vSlipDt,
    required this.vehicleNo,
    required this.driverName,
    required this.tripSheetEndLoc,
    required this.licenseNo,
    required this.valdityDt,
    required this.srNo,
    required this.type,
  });

  factory ExpensesList.fromJson(Map<String, dynamic> json) => ExpensesList(
    tripRouteType: json["trip_route_type"],
    category: json["category"],
    vSlipNo: json["vSlipNo"],
    manualTripsheetNo: json["manual_TripsheetNo"],
    vSlipDt: json["vSlipDt"],
    vehicleNo: json["vehicleNo"],
    driverName: json["driverName"],
    tripSheetEndLoc: json["tripSheet_EndLoc"],
    licenseNo: json["license_No"],
    valdityDt: json["valdity_dt"],
    srNo: json["srNo"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "trip_route_type": tripRouteType,
    "category": category,
    "vSlipNo": vSlipNo,
    "manual_TripsheetNo": manualTripsheetNo,
    "vSlipDt": vSlipDt,
    "vehicleNo": vehicleNo,
    "driverName": driverName,
    "tripSheet_EndLoc": tripSheetEndLoc,
    "license_No": licenseNo,
    "valdity_dt": valdityDt,
    "srNo": srNo,
    "type": type,
  };
}
