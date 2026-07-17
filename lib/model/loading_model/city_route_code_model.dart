import 'dart:convert';

CityRouteCodeModel cityRouteCodeModelFromJson(String str) =>
    CityRouteCodeModel.fromJson(json.decode(str));

String cityRouteCodeModelToJson(CityRouteCodeModel data) =>
    json.encode(data.toJson());

class CityRouteCodeModel {
  CityRouteCodeModel({
    this.statusCode,
    this.status,
    this.data,
    this.errors,
    this.metaData,
    this.message,
  });

  final int? statusCode;
  final int? status;
  final List<CityRouteData>? data;
  final dynamic errors;
  final dynamic metaData;
  final String? message;

  factory CityRouteCodeModel.fromJson(Map<String, dynamic> json) =>
      CityRouteCodeModel(
        statusCode: json["statusCode"],
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<CityRouteData>.from(
                json["data"]!.map((x) => CityRouteData.fromJson(x)),
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

class CityRouteData {
  CityRouteData({this.rutcd, this.rutnm});

  final String? rutcd;
  final String? rutnm;

  factory CityRouteData.fromJson(Map<String, dynamic> json) => CityRouteData(
    rutcd: json["rutcd"]?.toString() ?? "",
    rutnm: json["rutnm"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {"rutcd": rutcd, "rutnm": rutnm};
}
