import 'dart:convert';

VendorListResponse vendorListResponseFromJson(String str) => VendorListResponse.fromJson(json.decode(str));

String vendorListResponseToJson(VendorListResponse data) => json.encode(data.toJson());

class VendorListResponse {
  final int statusCode;
  final int status;
  final List<VendorList> data;
  final dynamic errors;
  final dynamic metaData;
  final String message;

  VendorListResponse({
    required this.statusCode,
    required this.status,
    required this.data,
    required this.errors,
    required this.metaData,
    required this.message,
  });

  factory VendorListResponse.fromJson(Map<String, dynamic> json) => VendorListResponse(
    statusCode: json["statusCode"],
    status: json["status"],
    data: List<VendorList>.from(json["data"].map((x) => VendorList.fromJson(x))),
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

class VendorList {
  final String vendorcode;
  final String vendorname;

  VendorList({
    required this.vendorcode,
    required this.vendorname,
  });

  factory VendorList.fromJson(Map<String, dynamic> json) => VendorList(
    vendorcode: json["vendorcode"],
    vendorname: json["vendorname"],
  );

  Map<String, dynamic> toJson() => {
    "vendorcode": vendorcode,
    "vendorname": vendorname,
  };
}
