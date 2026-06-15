import 'dart:convert';

FuelTripListResponse fuelTripListResponseFromJson(String str) => FuelTripListResponse.fromJson(json.decode(str));

String fuelTripListResponseToJson(FuelTripListResponse data) => json.encode(data.toJson());

class FuelTripListResponse {
  final int statusCode;
  final int status;
  final List<FuelTripList> fuelTripList;
  final dynamic errors;
  final dynamic metaData;
  final String message;

  FuelTripListResponse({
    required this.statusCode,
    required this.status,
    required this.fuelTripList,
    required this.errors,
    required this.metaData,
    required this.message,
  });

  factory FuelTripListResponse.fromJson(Map<String, dynamic> json) => FuelTripListResponse(
    statusCode: json["statusCode"],
    status: json["status"],
    fuelTripList: List<FuelTripList>.from(json["data"].map((x) => FuelTripList.fromJson(x))),
    errors: json["errors"],
    metaData: json["metaData"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "status": status,
    "data": List<dynamic>.from(fuelTripList.map((x) => x.toJson())),
    "errors": errors,
    "metaData": metaData,
    "message": message,
  };
}

class FuelTripList {
  final String vSlipNo;
  final dynamic manualTripsheetNo;
  final String vSlipDt;
  final String category;
  final dynamic tripRouteType;
  final String vehicleNo;
  final String driverName;
  final String licenseNo;
  final dynamic valdityDt;
  final String operCloseDt;
  final num startKm;
  final num fIssueFill;
  final dynamic tripSheetStartLoc;
  final dynamic tripSheetEndLoc;
  final dynamic marketOwn;
  final dynamic driver1;
  final dynamic ffrList;
  final dynamic ffrModel;
  final dynamic mode;
  final num srNo;
  final num contractAmt;
  final num advanceAmt;
  final num balanceAmt;
  final num pendAdvamt;
  final num disTKm;
  final dynamic thcno;
  final num estimatedCash;
  final num estimatedFuel;
  final num actualFuel;
  final num actualCash;
  final dynamic vSlipDtstr;

  FuelTripList({
    required this.vSlipNo,
    required this.manualTripsheetNo,
    required this.vSlipDt,
    required this.category,
    required this.tripRouteType,
    required this.vehicleNo,
    required this.driverName,
    required this.licenseNo,
    required this.valdityDt,
    required this.operCloseDt,
    required this.startKm,
    required this.fIssueFill,
    required this.tripSheetStartLoc,
    required this.tripSheetEndLoc,
    required this.marketOwn,
    required this.driver1,
    required this.ffrList,
    required this.ffrModel,
    required this.mode,
    required this.srNo,
    required this.contractAmt,
    required this.advanceAmt,
    required this.balanceAmt,
    required this.pendAdvamt,
    required this.disTKm,
    required this.thcno,
    required this.estimatedCash,
    required this.estimatedFuel,
    required this.actualFuel,
    required this.actualCash,
    required this.vSlipDtstr,
  });

  factory FuelTripList.fromJson(Map<String, dynamic> json) => FuelTripList(
    vSlipNo: json["vSlipNo"] ?? '',
    manualTripsheetNo: json["manual_TripsheetNo"],
    vSlipDt: json["vSlipDt"] ?? '',
    category: json["category"] ?? '',
    tripRouteType: json["trip_route_type"],
    vehicleNo: json["vehicleNo"] ?? '',
    driverName: json["driverName"] ?? '',
    licenseNo: json["license_No"] ?? '',
    valdityDt: json["valdity_dt"],
    operCloseDt: json["oper_Close_Dt"] ?? '',
    startKm: json["start_km"] ?? 0,
    fIssueFill: json["f_issue_fill"] ?? 0,
    tripSheetStartLoc: json["tripSheet_StartLoc"],
    tripSheetEndLoc: json["tripSheet_EndLoc"],
    marketOwn: json["market_Own"],
    driver1: json["driver1"],
    ffrList: json["ffrList"],
    ffrModel: json["ffrModel"],
    mode: json["mode"],
    srNo: json["srNo"] ?? 0,
    contractAmt: json["contractAmt"] ?? 0,
    advanceAmt: json["advanceAmt"] ?? 0,
    balanceAmt: json["balanceAmt"] ?? 0,
    pendAdvamt: json["pendAdvamt"] ?? 0,
    disTKm: json["disT_KM"] ?? 0,
    thcno: json["thcno"],
    estimatedCash: json["estimatedCash"] ?? 0,
    estimatedFuel: json["estimatedFuel"] ?? 0,
    actualFuel: json["actualFuel"] ?? 0,
    actualCash: json["actualCash"] ?? 0,
    vSlipDtstr: json["vSlipDtstr"] ?? '',
  );


  Map<String, dynamic> toJson() => {
    "vSlipNo": vSlipNo,
    "manual_TripsheetNo": manualTripsheetNo,
    "vSlipDt": vSlipDt,
    "category": category,
    "trip_route_type": tripRouteType,
    "vehicleNo": vehicleNo,
    "driverName": driverName,
    "license_No": licenseNo,
    "valdity_dt": valdityDt,
    "oper_Close_Dt": operCloseDt,
    "start_km": startKm,
    "f_issue_fill": fIssueFill,
    "tripSheet_StartLoc": tripSheetStartLoc,
    "tripSheet_EndLoc": tripSheetEndLoc,
    "market_Own": marketOwn,
    "driver1": driver1,
    "ffrList": ffrList,
    "ffrModel": ffrModel,
    "mode": mode,
    "srNo": srNo,
    "contractAmt": contractAmt,
    "advanceAmt": advanceAmt,
    "balanceAmt": balanceAmt,
    "pendAdvamt": pendAdvamt,
    "disT_KM": disTKm,
    "thcno": thcno,
    "estimatedCash": estimatedCash,
    "estimatedFuel": estimatedFuel,
    "actualFuel": actualFuel,
    "actualCash": actualCash,
    "vSlipDtstr": vSlipDtstr,
  };
}
