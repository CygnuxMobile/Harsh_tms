import 'dart:convert';

TypeOfMovementModel typeOfMovementModelFromJson(String str) => TypeOfMovementModel.fromJson(json.decode(str));

String typeOfMovementModelToJson(TypeOfMovementModel data) => json.encode(data.toJson());

class TypeOfMovementModel {
  TypeOfMovementModel({
    this.statusCode,
    this.status,
    this.data,
    this.errors,
    this.metaData,
    this.message,
  });

  int? statusCode;
  int? status;
  List<TypeOfMovementData>? data;
  dynamic errors;
  dynamic metaData;
  String? message;

  factory TypeOfMovementModel.fromJson(Map<String, dynamic> json) => TypeOfMovementModel(
    statusCode: json["statusCode"],
    status: json["status"],
    data: json["data"] == null ? [] : List<TypeOfMovementData>.from(json["data"]!.map((x) => TypeOfMovementData.fromJson(x))),
    errors: json["errors"],
    metaData: json["metaData"],
    message: json["message"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "errors": errors,
    "metaData": metaData,
    "message": message,
  };
}

class TypeOfMovementData {
  TypeOfMovementData({
    this.codeType,
    this.codeId,
    this.codeDesc,
    this.codeAccess,
  });

  String? codeType;
  String? codeId;
  String? codeDesc;
  String? codeAccess;

  factory TypeOfMovementData.fromJson(Map<String, dynamic> json) => TypeOfMovementData(
    codeType: json["codeType"]?.toString() ?? "",
    codeId: json["codeId"]?.toString() ?? "",
    codeDesc: json["codeDesc"]?.toString() ?? "",
    codeAccess: json["codeAccess"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "codeType": codeType,
    "codeId": codeId,
    "codeDesc": codeDesc,
    "codeAccess": codeAccess,
  };
}
