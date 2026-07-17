import 'dart:convert';

LedgerMasterDataModel ledgerMasterDataModelFromJson(String str) =>
    LedgerMasterDataModel.fromJson(json.decode(str));

String ledgerMasterDataModelToJson(LedgerMasterDataModel data) =>
    json.encode(data.toJson());

class LedgerMasterDataModel {
  LedgerMasterDataModel({
    this.statusCode,
    this.status,
    this.data,
    this.errors,
    this.metaData,
    this.message,
  });

  final int? statusCode;
  final int? status;
  final List<LedgerData>? data;
  final dynamic errors;
  final dynamic metaData;
  final String? message;

  factory LedgerMasterDataModel.fromJson(Map<String, dynamic> json) =>
      LedgerMasterDataModel(
        statusCode: json["statusCode"],
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<LedgerData>.from(
                json["data"]!.map((x) => LedgerData.fromJson(x)),
              ),
        errors: json["errors"],
        metaData: json["metaData"],
        message: json["message"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "status": status,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "errors": errors,
    "metaData": metaData,
    "message": message,
  };
}

class LedgerData {
  LedgerData({this.ledgerCode, this.ledgerName});

  final String? ledgerCode;
  final String? ledgerName;

  factory LedgerData.fromJson(Map<String, dynamic> json) => LedgerData(
    ledgerCode: json["LedgerCode"]?.toString() ?? "",
    ledgerName: json["LedgerName"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "LedgerCode": ledgerCode,
    "LedgerName": ledgerName,
  };
}
