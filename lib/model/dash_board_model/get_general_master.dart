import 'dart:convert';

GetGeneralMasterData getGeneralMasterDataFromJson(String str) => GetGeneralMasterData.fromJson(json.decode(str));

String getGeneralMasterDataToJson(GetGeneralMasterData data) => json.encode(data.toJson());

class GetGeneralMasterData {
  final int statusCode;
  final int status;
  final List<GeneralMaster> data;
  final dynamic errors;
  final dynamic metaData;
  final String message;

  GetGeneralMasterData({
    required this.statusCode,
    required this.status,
    required this.data,
    required this.errors,
    required this.metaData,
    required this.message,
  });

  factory GetGeneralMasterData.fromJson(Map<String, dynamic> json) => GetGeneralMasterData(
    statusCode: json["statusCode"],
    status: json["status"],
    data: List<GeneralMaster>.from(json["data"].map((x) => GeneralMaster.fromJson(x))),
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

class GeneralMaster {
  final String codeType;
  final String codeId;
  final String codeDesc;
  final String codeAccess;

  GeneralMaster({
    required this.codeType,
    required this.codeId,
    required this.codeDesc,
    required this.codeAccess,
  });

  factory GeneralMaster.fromJson(Map<String, dynamic> json) => GeneralMaster(
    codeType: json["codeType"] ?? '',
    codeId: json["codeId"] ?? '',
    codeDesc: json["codeDesc"] ?? '',
    codeAccess: json["codeAccess"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "codeType": codeType,
    "codeId": codeId,
    "codeDesc": codeDesc,
    "codeAccess": codeAccess,
  };
}
