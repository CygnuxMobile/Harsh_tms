import 'dart:convert';

List<ControlTower> controlTowerFromJson(String str) =>
    List<ControlTower>.from(
        json.decode(str).map((x) => ControlTower.fromJson(x)));

class ControlTower {
  final String vehno;
  final String conrtlBranch;
  final String vehicleMainStatus;
  final String vMainStatus;
  final String vehicleSubStatus;
  final String vehicleSubStatus1;
  final String vSubStatus;
  final String vSubStatus1;
  final String vehicleArea;
  final String vehicleRemark;
  final String statusSince;
  final String location;
  final dynamic lastThc;
  final String mainStatusSince;
  final String docType;
  final String docEvent;
  final String docNo;
  final String routeName;
  final String tripNo;
  final String docDt;
  final num underManumenance;
  final String latitude;
  final String longitude;
  final String nearBranch;
  final bool movingNearBranch;
  final bool isLate;
  final bool offJob;
  final String speed;
  final num calculatedSpeed;
  final String distanceTravelled;
  final bool isAvailable;
  final bool onJob;
  final bool isParked;
  final bool isMoving;
  final bool isEmptyRun;
  final bool gpsEnabled;
  final String driverName;
  final String driverMobile;
  final String vehicleMake;
  final String vehicleModel;
  final String updateDateTime;
  final String typeName;
  final String statusUpdatedDate;
  final String billingParty;
  final String fromToCity;
  final String ewbno;
  final String eWayBillExpiredDate;
  final dynamic fastTag;
  final dynamic tollTxn;
  final dynamic fuel;
  final dynamic fuelSlip;
  final dynamic enroute;
  final dynamic distance;
  final dynamic averageSpeed;
  final String eta;
  final String ata;
  final String sta;
  final num pendingKm;
  final String runningStatus;
  final String lateBy;
  final String driverId;
  final num totalKm;
  final String destArea;
  final String eWayBillInvoiceDate;
  final String reportdate;
  final String stoppageStart;
  final String stoppageEnd;
  final String stoppageDurationFormatted;
  final String cityRouteCd;
  final String lateEarly;
  final String runningStatus1;
  final String releasDate;
  final String fromLoc;
  final String toLoc;
  final String ftlType;
  final String workingLocation;

  ControlTower({
    required this.vehno,
    required this.conrtlBranch,
    required this.vehicleMainStatus,
    required this.vMainStatus,
    required this.vehicleSubStatus,
    required this.vehicleSubStatus1,
    required this.vSubStatus,
    required this.vSubStatus1,
    required this.vehicleArea,
    required this.vehicleRemark,
    required this.statusSince,
    required this.location,
    required this.lastThc,
    required this.mainStatusSince,
    required this.docType,
    required this.docEvent,
    required this.docNo,
    required this.routeName,
    required this.tripNo,
    required this.docDt,
    required this.underManumenance,
    required this.latitude,
    required this.longitude,
    required this.nearBranch,
    required this.movingNearBranch,
    required this.isLate,
    required this.offJob,
    required this.speed,
    required this.calculatedSpeed,
    required this.distanceTravelled,
    required this.isAvailable,
    required this.onJob,
    required this.isParked,
    required this.isMoving,
    required this.isEmptyRun,
    required this.gpsEnabled,
    required this.driverName,
    required this.driverMobile,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.updateDateTime,
    required this.typeName,
    required this.statusUpdatedDate,
    required this.billingParty,
    required this.fromToCity,
    required this.ewbno,
    required this.eWayBillExpiredDate,
    required this.fastTag,
    required this.tollTxn,
    required this.fuel,
    required this.fuelSlip,
    required this.enroute,
    required this.distance,
    required this.averageSpeed,
    required this.eta,
    required this.ata,
    required this.sta,
    required this.pendingKm,
    required this.runningStatus,
    required this.lateBy,
    required this.driverId,
    required this.totalKm,
    required this.destArea,
    required this.eWayBillInvoiceDate,
    required this.reportdate,
    required this.stoppageStart,
    required this.stoppageEnd,
    required this.stoppageDurationFormatted,
    required this.cityRouteCd,
    required this.lateEarly,
    required this.runningStatus1,
    required this.releasDate,
    required this.fromLoc,
    required this.toLoc,
    required this.ftlType,
    required this.workingLocation,
  });

  factory ControlTower.fromJson(Map<String, dynamic> json) => ControlTower(
    vehno: json["VEHNO"] ?? "",
    conrtlBranch: json["Conrtl_branch"] ?? "",
    vehicleMainStatus: json["VehicleMainStatus"]?.toString() ?? "",
    vMainStatus: json["VMainStatus"] ?? "",
    vehicleSubStatus: json["VehicleSubStatus"] ?? "",
    vehicleSubStatus1: json["VehicleSubStatus1"] ?? "",
    vSubStatus: json["VSubStatus"] ?? "",
    vSubStatus1: json["VSubStatus1"] ?? "",
    vehicleArea: json["VehicleArea"] ?? "",
    vehicleRemark: json["VehicleRemark"] ?? "",
    statusSince: json["StatusSince"] ?? "",
    location: json["Location"] ?? "",
    lastThc: json["LastTHC"],
    mainStatusSince: json["MainStatusSince"] ?? "",
    docType: json["DocType"] ?? "",
    docEvent: json["DocEvent"] ?? "",
    docNo: json["DocNo"] ?? "",
    routeName: json["RouteName"] ?? "",
    tripNo: json["TripNo"] ?? "",
    docDt: json["DocDt"] ?? "",
    underManumenance: json["UnderManumenance"] ?? 0,
    latitude: json["latitude"]?.toString() ?? "",
    longitude: json["longitude"]?.toString() ?? "",
    nearBranch: json["NearBranch"] ?? "",
    movingNearBranch: json["MovingNearBranch"] ?? false,
    isLate: json["IsLate"] ?? false,
    offJob: json["OffJob"] ?? false,
    speed: json["speed"]?.toString() ?? "0",
    calculatedSpeed: json["CalculatedSpeed"] ?? 0,
    distanceTravelled: json["DistanceTravelled"] ?? "",
    isAvailable: json["IsAvailable"] ?? false,
    onJob: json["OnJob"] ?? false,
    isParked: json["IsParked"] ?? false,
    isMoving: json["IsMoving"] ?? false,
    isEmptyRun: json["IsEmptyRun"] ?? false,
    gpsEnabled: json["GPSEnabled"] ?? false,
    driverName: json["DriverName"] ?? "",
    driverMobile: json["DriverMobile"] ?? "",
    vehicleMake: json["VehicleMake"] ?? "",
    vehicleModel: json["VehicleModel"] ?? "",
    updateDateTime: json["UpdateDateTime"] ?? "",
    typeName: json["Type_name"] ?? "",
    statusUpdatedDate: json["StatusUpdatedDate"] ?? "",
    billingParty: json["Billing_Party"] ?? "",
    fromToCity: json["From_To_City"] ?? "",
    ewbno: json["EWBNO"] ?? "",
    eWayBillExpiredDate: json["EWayBillExpiredDate"] ?? "",
    fastTag: json["FastTag"],
    tollTxn: json["TollTxn"],
    fuel: json["Fuel"],
    fuelSlip: json["FuelSlip"],
    enroute: json["Enroute"],
    distance: json["Distance"],
    averageSpeed: json["AverageSpeed"],
    eta: json["ETA"] ?? "",
    ata: json["ATA"] ?? "",
    sta: json["STA"] ?? "",
    pendingKm: json["PendingKM"] ?? 0,
    runningStatus: json["RunningStatus"] ?? "",
    lateBy: json["LateBy"] ?? "",
    driverId: json["driverId"]?.toString() ?? "",
    totalKm: json["TotalKM"] ?? 0,
    destArea: json["Dest_Area"] ?? "",
    eWayBillInvoiceDate: json["EWayBillInvoiceDate"] ?? "",
    reportdate: json["Reportdate"] ?? "",
    stoppageStart: json["StoppageStart"] ?? "",
    stoppageEnd: json["StoppageEnd"] ?? "",
    stoppageDurationFormatted:
    json["StoppageDurationFormatted"] ?? "",
    cityRouteCd: json["CityRouteCD"] ?? "",
    lateEarly: json["LateEarly"] ?? "",
    runningStatus1: json["RunningStatus1"] ?? "",
    releasDate: json["ReleasDate"] ?? "",
    fromLoc: json["FromLoc"] ?? "",
    toLoc: json["ToLoc"] ?? "",
    ftlType: json["FTLType"] ?? "",
    workingLocation: json["WorkingLocation"] ?? "",
  );
}
