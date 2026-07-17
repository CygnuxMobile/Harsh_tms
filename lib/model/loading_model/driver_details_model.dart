import 'dart:convert';

DriverDetailsModel driverDetailsModelFromJson(String str) => DriverDetailsModel.fromJson(json.decode(str));

class DriverDetailsModel {
    final int? statusCode;
    final int? status;
    final List<DriverData>? data;
    final dynamic errors;
    final dynamic metaData;
    final String? message;

    DriverDetailsModel({
        this.statusCode,
        this.status,
        this.data,
        this.errors,
        this.metaData,
        this.message,
    });

    factory DriverDetailsModel.fromJson(Map<String, dynamic> json) => DriverDetailsModel(
        statusCode: json["statusCode"],
        status: json["status"],
        data: json["data"] == null ? [] : List<DriverData>.from(json["data"].map((x) => DriverData.fromJson(x))),
        errors: json["errors"],
        metaData: json["metaData"],
        message: json["message"],
    );
}

class DriverData {
    final String? vSlipNo;
    final String? driver1;
    final String? driver1ID;
    final String? licno1;
    final String? validityDate1;
    final String? moB1;

    DriverData({
        this.vSlipNo,
        this.driver1,
        this.driver1ID,
        this.licno1,
        this.validityDate1,
        this.moB1,
    });

    factory DriverData.fromJson(Map<String, dynamic> json) => DriverData(
        vSlipNo: json["vSlipNo"],
        driver1: json["driver1"],
        driver1ID: json["driver1_ID"],
        licno1: json["licno1"],
        validityDate1: json["validity_Date1"],
        moB1: json["moB1"],
    );
}
