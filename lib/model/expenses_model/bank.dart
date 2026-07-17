import 'dart:convert';

GetLedgerMasterData getLedgerMasterDataFromJson(String str) => GetLedgerMasterData.fromJson(json.decode(str));

String getLedgerMasterDataToJson(GetLedgerMasterData data) => json.encode(data.toJson());

class GetLedgerMasterData {
  final int statusCode;
  final int status;
  final List<LedgerMasterList> data;
  final dynamic errors;
  final dynamic metaData;
  final String message;

  GetLedgerMasterData({
    required this.statusCode,
    required this.status,
    required this.data,
    required this.errors,
    required this.metaData,
    required this.message,
  });

  factory GetLedgerMasterData.fromJson(Map<String, dynamic> json) => GetLedgerMasterData(
    statusCode: json["statusCode"],
    status: json["status"],
    data: List<LedgerMasterList>.from(json["data"].map((x) => LedgerMasterList.fromJson(x))),
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

class LedgerMasterList {
  final String codeId;
  final String codeDesc;

  LedgerMasterList({
    required this.codeId,
    required this.codeDesc,
  });

  factory LedgerMasterList.fromJson(Map<String, dynamic> json) => LedgerMasterList(
    codeId: json["codeId"],
    codeDesc: json["codeDesc"],
  );

  Map<String, dynamic> toJson() => {
    "codeId": codeId,
    "codeDesc": codeDesc,
  };
}
