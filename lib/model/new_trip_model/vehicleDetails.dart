import 'dart:convert';

VehicleDetails vehicleDetailsFromJson(String str) => VehicleDetails.fromJson(json.decode(str));

String vehicleDetailsToJson(VehicleDetails data) => json.encode(data.toJson());

class VehicleDetails {
  final int statusCode;
  final int status;
  final List<VehicleDetailsList> data;
  final dynamic errors;
  final dynamic metaData;
  final String message;

  VehicleDetails({
    required this.statusCode,
    required this.status,
    required this.data,
    required this.errors,
    required this.metaData,
    required this.message,
  });

  factory VehicleDetails.fromJson(Map<String, dynamic> json) => VehicleDetails(
    statusCode: json["statusCode"],
    status: json["status"],
    data: List<VehicleDetailsList>.from(json["data"].map((x) => VehicleDetailsList.fromJson(x))),
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

class VehicleDetailsList {
  final String vehno;
  final num currenTKmRead;
  final String prevTripsVSlipNo;
  final dynamic deliveryBy;

  VehicleDetailsList({
    required this.vehno,
    required this.currenTKmRead,
    required this.prevTripsVSlipNo,
    required this.deliveryBy,
  });

  factory VehicleDetailsList.fromJson(Map<String, dynamic> json) => VehicleDetailsList(
    vehno: json["vehno"] ?? '',
    currenTKmRead: json["currenT_KM_READ"] ?? 0,
    prevTripsVSlipNo: json["prevTrips_VSlipNo"] ?? '',
    deliveryBy: json["deliveryBy"],
  );

  Map<String, dynamic> toJson() => {
    "vehno": vehno,
    "currenT_KM_READ": currenTKmRead,
    "prevTrips_VSlipNo": prevTripsVSlipNo,
    "deliveryBy": deliveryBy,
  };
}
