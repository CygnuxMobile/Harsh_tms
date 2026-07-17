import 'dart:convert';

DriverDetailsModel driverDetailsModelFromJson(String str) => DriverDetailsModel.fromJson(json.decode(str));

String driverDetailsModelToJson(DriverDetailsModel data) => json.encode(data.toJson());

class DriverDetailsModel {
  final int statusCode;
  final int status;
  final List<DriverDetails> data;
  final dynamic errors;
  final dynamic metaData;
  final String message;

  DriverDetailsModel({
    required this.statusCode,
    required this.status,
    required this.data,
    required this.errors,
    required this.metaData,
    required this.message,
  });

  factory DriverDetailsModel.fromJson(Map<String, dynamic> json) => DriverDetailsModel(
        statusCode: json["statusCode"],
        status: json["status"],
        data: List<DriverDetails>.from(json["data"].map((x) => DriverDetails.fromJson(x))),
        errors: json["errors"],
        metaData: json["metaData"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "errors": errors,
        "metaData": metaData,
        "message": message,
      };
}

class DriverDetails {
  final String driverStatus;
  final dynamic driverTypeId;
  final String driverId;
  final String driverName;
  final String licenseNo;
  final String valdityDt;
  final String manualDriverCode;
  final String driverPhoto;
  final dynamic drivingLicFile;
  final num tripCount;
  final String mobileno;
  final num driver1OpBal;
  final String licenceExpired;
  final dynamic valdityTodt;
  final String passportNo;
  final String paNNo;
  final String aadharNo;
  final String vaccineNo;
  final String voterId;
  final String policeVerification;
  final num dieseLQtyCf;
  final num dieseLAmtCf;

  DriverDetails({
    required this.driverStatus,
    required this.driverTypeId,
    required this.driverId,
    required this.driverName,
    required this.licenseNo,
    required this.valdityDt,
    required this.manualDriverCode,
    required this.driverPhoto,
    required this.drivingLicFile,
    required this.tripCount,
    required this.mobileno,
    required this.driver1OpBal,
    required this.licenceExpired,
    required this.valdityTodt,
    required this.passportNo,
    required this.paNNo,
    required this.aadharNo,
    required this.vaccineNo,
    required this.voterId,
    required this.policeVerification,
    required this.dieseLQtyCf,
    required this.dieseLAmtCf,
  });

  factory DriverDetails.fromJson(Map<String, dynamic> json) => DriverDetails(
        driverStatus: json["driver_Status"] ?? "",
        driverTypeId: json["driver_Type_ID"],
        driverId: json["driver_Id"] ?? "",
        driverName: json["driver_Name"] ?? "",
        licenseNo: json["license_No"] ?? "",
        valdityDt: json["valdity_dt"] ?? '',
        manualDriverCode: json["manual_Driver_Code"] ?? "",
        driverPhoto: json["driver_Photo"] ?? "",
        drivingLicFile: json["driving_lic_File"],
        tripCount: json["trip_Count"] ?? 0,
        mobileno: json["mobileno"] ?? "",
        driver1OpBal: json["driver1_Op_Bal"] ?? 0,
        licenceExpired: json["licenceExpired"] ?? "",
        valdityTodt: json["valdity_Todt"],
        passportNo: json["passport_No"] ?? "",
        paNNo: json["paN_No"] ?? "",
        aadharNo: json["aadhar_No"] ?? "",
        vaccineNo: json["vaccine_No"] ?? "",
        voterId: json["voter_Id"] ?? "",
        policeVerification: json["police_Verification"] ?? "",
        dieseLQtyCf: json["dieseL_QTY_CF"] ?? 0,
        dieseLAmtCf: json["dieseL_AMT_CF"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "driver_Status": driverStatus,
        "driver_Type_ID": driverTypeId,
        "driver_Id": driverId,
        "driver_Name": driverName,
        "license_No": licenseNo,
        "valdity_dt": valdityDt,
        "manual_Driver_Code": manualDriverCode,
        "driver_Photo": driverPhoto,
        "driving_lic_File": drivingLicFile,
        "trip_Count": tripCount,
        "mobileno": mobileno,
        "driver1_Op_Bal": driver1OpBal,
        "licenceExpired": licenceExpired,
        "valdity_Todt": valdityTodt,
        "passport_No": passportNo,
        "paN_No": paNNo,
        "aadhar_No": aadharNo,
        "vaccine_No": vaccineNo,
        "voter_Id": voterId,
        "police_Verification": policeVerification,
        "dieseL_QTY_CF": dieseLQtyCf,
        "dieseL_AMT_CF": dieseLAmtCf,
      };
}
