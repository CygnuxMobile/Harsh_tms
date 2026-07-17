import 'dart:convert';

VehicleNoModel vehicleNoModelFromJson(String str) =>
    VehicleNoModel.fromJson(json.decode(str));

String vehicleNoModelToJson(VehicleNoModel data) => json.encode(data.toJson());

class VehicleNoModel {
  VehicleNoModel({
    this.statusCode,
    this.status,
    this.data,
    this.errors,
    this.metaData,
    this.message,
  });

  final int? statusCode;
  final int? status;
  final List<VehicleData>? data;
  final dynamic errors;
  final dynamic metaData;
  final String? message;

  factory VehicleNoModel.fromJson(Map<String, dynamic> json) => VehicleNoModel(
    statusCode: json["statusCode"],
    status: json["status"],
    data: json["data"] == null
        ? []
        : List<VehicleData>.from(
            json["data"]!.map((x) => VehicleData.fromJson(x)),
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

class VehicleData {
  VehicleData({this.vehno, this.dispVehicle});

  final String? vehno;
  final String? dispVehicle;

  factory VehicleData.fromJson(Map<String, dynamic> json) => VehicleData(
    vehno: json["vehno"]?.toString() ?? "",
    dispVehicle: json["dispVehicle"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {"vehno": vehno, "dispVehicle": dispVehicle};
}
