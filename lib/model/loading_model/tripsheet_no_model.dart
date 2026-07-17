import 'dart:convert';

TripsheetNoModel tripsheetNoModelFromJson(String str) =>
    TripsheetNoModel.fromJson(json.decode(str));

String tripsheetNoModelToJson(TripsheetNoModel data) =>
    json.encode(data.toJson());

class TripsheetNoModel {
  TripsheetNoModel({
    this.statusCode,
    this.status,
    this.data,
    this.errors,
    this.metaData,
    this.message,
  });

  final int? statusCode;
  final int? status;
  final List<TripsheetData>? data;
  final dynamic errors;
  final dynamic metaData;
  final String? message;

  factory TripsheetNoModel.fromJson(Map<String, dynamic> json) =>
      TripsheetNoModel(
        statusCode: json["statusCode"],
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<TripsheetData>.from(
                json["data"]!.map((x) => TripsheetData.fromJson(x)),
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

class TripsheetData {
  TripsheetData({this.vSlipNo});

  final String? vSlipNo;

  factory TripsheetData.fromJson(Map<String, dynamic> json) =>
      TripsheetData(vSlipNo: json["vSlipNo"]?.toString() ?? "");

  Map<String, dynamic> toJson() => {"vSlipNo": vSlipNo};
}
