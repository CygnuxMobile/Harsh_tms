import 'dart:convert';

FreightTypeModel freightTypeModelFromJson(String str) =>
    FreightTypeModel.fromJson(json.decode(str));

String freightTypeModelToJson(FreightTypeModel data) =>
    json.encode(data.toJson());

class FreightTypeModel {
  FreightTypeModel({
    this.statusCode,
    this.status,
    this.data,
    this.errors,
    this.metaData,
    this.message,
  });

  final int? statusCode;
  final int? status;
  final List<FreightTypeData>? data;
  final dynamic errors;
  final dynamic metaData;
  final String? message;

  factory FreightTypeModel.fromJson(Map<String, dynamic> json) =>
      FreightTypeModel(
        statusCode: json["statusCode"],
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<FreightTypeData>.from(
                json["data"]!.map((x) => FreightTypeData.fromJson(x)),
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

class FreightTypeData {
  FreightTypeData({this.text, this.value});

  final String? text;
  final String? value;

  factory FreightTypeData.fromJson(Map<String, dynamic> json) =>
      FreightTypeData(
        text: json["text"]?.toString() ?? "",
        value: json["value"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {"text": text, "value": value};
}
