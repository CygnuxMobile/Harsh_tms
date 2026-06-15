import 'dart:convert';

List<DestinationResponse> destinationResponseFromJson(String str) =>
    List<DestinationResponse>.from(json.decode(str).map((x) => DestinationResponse.fromJson(x)));

String destinationResponseToJson(List<DestinationResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DestinationResponse {
  final String locCode;
  final String locName;
  final String city;

  DestinationResponse({
    required this.locCode,
    required this.locName,
    required this.city,
  });

  factory DestinationResponse.fromJson(Map<String, dynamic> json) => DestinationResponse(
        locCode: json["LocCode"],
        locName: json["LocName"],
        city: json["city"],
      );

  Map<String, dynamic> toJson() => {
        "LocCode": locCode,
        "LocName": locName,
        "city": city,
      };
}
