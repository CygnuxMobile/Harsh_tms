import 'dart:convert';

WeightTypeModel weightTypeModelFromJson(String str) =>
    WeightTypeModel.fromJson(json.decode(str));

String weightTypeModelToJson(WeightTypeModel data) =>
    json.encode(data.toJson());

class WeightTypeModel {
  WeightTypeModel({
    this.statusCode,
    this.status,
    this.data,
    this.errors,
    this.metaData,
    this.message,
  });

  final int? statusCode;
  final int? status;
  final List<WeightTypeData>? data;
  final dynamic errors;
  final dynamic metaData;
  final String? message;

  factory WeightTypeModel.fromJson(Map<String, dynamic> json) =>
      WeightTypeModel(
        statusCode: json["statusCode"],
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<WeightTypeData>.from(
                json["data"]!.map((x) => WeightTypeData.fromJson(x)),
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

class WeightTypeData {
  WeightTypeData({this.text, this.value});

  final String? text;
  final String? value;

  factory WeightTypeData.fromJson(Map<String, dynamic> json) => WeightTypeData(
    text: json["text"]?.toString() ?? "",
    value: json["value"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {"text": text, "value": value};
}
