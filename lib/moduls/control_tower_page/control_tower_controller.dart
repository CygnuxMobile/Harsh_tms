import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harsh/moduls/control_tower_page/sub_screen/vehicle_track.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../utils/tmsapi_method.dart';
import '../../model/control_tower_model/control_tower_response.dart';

enum VehicleFilter { all, moving, idle, stopped }

class ControlTowerController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isMarkerLoading = false.obs;
  RxBool isSingleFocusMode = false.obs;

  RxList<ControlTower> vehicleList = <ControlTower>[].obs;
  Rx<VehicleFilter> selectedFilter = VehicleFilter.all.obs;
  RxSet<Marker> markers = <Marker>{}.obs;

  GoogleMapController? mapController;

  RxDouble currentZoom = 5.5.obs;
  int _lastZoomBucket = -1;

  RxString searchText = "".obs;

  final PanelController panelController = PanelController();

  ui.Image? _cachedTruckIcon;
  BitmapDescriptor? _simpleTruckIconDescriptor;

  final Map<String, BitmapDescriptor> _markerCache = {};

  Rx<MapType> mapType = MapType.normal.obs;

  @override
  void onInit() {
    super.onInit();
    _loadResources();
    getControlTowerData();
  }

  void toggleMapType() {
    mapType.value = mapType.value == MapType.normal ? MapType.satellite : MapType.normal;
  }

  /// LOAD ICON
  Future<void> _loadResources() async {
    if (_cachedTruckIcon != null) return;

    try {
      final data = await rootBundle.load('assets/images/truck_icon.png');
      final bytes = data.buffer.asUint8List();

      final codec = await ui.instantiateImageCodec(bytes, targetWidth: 150);
      final frame = await codec.getNextFrame();

      _cachedTruckIcon = frame.image;

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.drawImage(_cachedTruckIcon!, const Offset(0, 0), Paint());
      final img = await recorder.endRecording().toImage(150, 150);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      _simpleTruckIconDescriptor = BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
    } catch (e) {
      debugPrint("Error loading truck icon: $e");
    }
  }

  /// ================= API =================
  Future<void> getControlTowerData() async {
    try {
      isLoading.value = true;

      final response = await WebService.tmsPostRequest(url: "https://deliveryapi.cygnux.in/api/Master/GetDynamicList?ReportID=284", body: "{}");

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.data);

        vehicleList.assignAll(data.map((e) => ControlTower.fromJson(e)).toList());

        await updateMarkersByZoom(force: true);
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// ================= FILTER =================
  List<ControlTower> get filteredVehicles {
    final baseList = vehicleList.where((e) {
      final lat = double.tryParse(e.latitude);
      final lng = double.tryParse(e.longitude);
      return lat != null && lng != null;
    });

    switch (selectedFilter.value) {
      case VehicleFilter.moving:
        return baseList.where((e) => e.isMoving).toList();

      case VehicleFilter.idle:
        return baseList.where((e) => !e.isMoving && (double.tryParse(e.speed) ?? 0) > 0).toList();

      case VehicleFilter.stopped:
        return baseList.where((e) => !e.isMoving && (double.tryParse(e.speed) ?? 0) == 0).toList();

      default:
        return baseList.toList();
    }
  }

  List<ControlTower> get searchedVehicles {
    final list = filteredVehicles;

    if (searchText.value.isEmpty) return list;

    return list.where((e) => e.vehno.toLowerCase().contains(searchText.value.toLowerCase())).toList();
  }

  /// ================= ZOOM =================
  Future<void> updateMarkersByZoom({bool force = false}) async {
    if (isSingleFocusMode.value && currentZoom.value < 13) {
      isSingleFocusMode.value = false;
      _lastZoomBucket = -1;
    }

    if (isSingleFocusMode.value) return;

    int zoomInt = currentZoom.value.floor();

    if (!force && (_lastZoomBucket - zoomInt).abs() < 1) return;

    _lastZoomBucket = zoomInt;

    // "Full Zoom" hide numbers for performance as requested
    if (zoomInt >= 17) {
      await _vehicleMarkers();
    } else {
      double precision;

      // Adjusted precision to expand 15-20 trucks more aggressively
      if (zoomInt <= 5) {
        precision = 2.0;
      } else if (zoomInt <= 7) {
        precision = 0.8;
      } else if (zoomInt <= 9) {
        precision = 0.3;
      } else if (zoomInt <= 11) {
        precision = 0.08;
      } else if (zoomInt <= 13) {
        precision = 0.02;
      } else if (zoomInt <= 15) {
        precision = 0.005;
      } else {
        precision = 0.001;
      }

      await _gridMarkers(precision);
    }
  }

  /// ================= SINGLE VEHICLE =================
  Future<void> focusOnVehicle(double lat, double lng, ControlTower vehicle) async {
    try {
      isMarkerLoading.value = true;
      isSingleFocusMode.value = true;
      _lastZoomBucket = -1;
      currentZoom.value = 15;

      // Always show annotation when focusing on a single vehicle
      final icon = await _dotWithText(text: vehicle.vehno, fontSize: 18, isCluster: false);

      markers.assignAll({
        Marker(
          markerId: MarkerId(vehicle.vehno),
          position: LatLng(lat, lng),
          icon: icon,
          onTap: () => Get.to(() => VehicleTrackScreen(data: vehicle)),
        ),
      });

      isMarkerLoading.value = false;

      await mapController?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15));
    } catch (e) {
      isMarkerLoading.value = false;
    }
  }

  /// ================= GRID CLUSTER =================
  Future<void> _gridMarkers(double precision) async {
    final Map<String, List<ControlTower>> grid = {};

    for (final v in filteredVehicles) {
      final lat = double.tryParse(v.latitude);
      final lng = double.tryParse(v.longitude);

      if (lat == null || lng == null) continue;

      final key = "${(lat / precision).floor()}_${(lng / precision).floor()}";
      grid.putIfAbsent(key, () => []).add(v);
    }

    final List<Marker> newMarkers = [];

    for (final e in grid.entries) {
      final list = e.value;

      final avgLat = list.map((e) => double.parse(e.latitude)).reduce((a, b) => a + b) / list.length;
      final avgLng = list.map((e) => double.parse(e.longitude)).reduce((a, b) => a + b) / list.length;

      BitmapDescriptor icon;

      if (list.length == 1) {
        // Show annotation for individual vehicles in the grid
        icon = await _dotWithText(text: list.first.vehno, fontSize: 18, isCluster: false);
      } else {
        icon = await _dotWithText(text: list.length.toString(), fontSize: 24, isCluster: true);
      }

      newMarkers.add(
        Marker(
          markerId: MarkerId(e.key),
          position: LatLng(avgLat, avgLng),
          icon: icon,
          onTap: list.length == 1
              ? () => Get.to(() => VehicleTrackScreen(data: list.first))
              : () {
                  mapController?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(avgLat, avgLng), currentZoom.value + 2));
                },
        ),
      );
    }

    if (!isSingleFocusMode.value) {
      markers.assignAll(newMarkers);
    }
  }

  /// ================= VEHICLE MARKERS (FULL ZOOM) =================
  /// Hides numbers and uses a simple cached icon for maximum performance
  Future<void> _vehicleMarkers() async {
    if (_simpleTruckIconDescriptor == null) await _loadResources();

    final List<Marker> newMarkers = [];
    final icon = _simpleTruckIconDescriptor!;

    for (final v in filteredVehicles) {
      final lat = double.tryParse(v.latitude);
      final lng = double.tryParse(v.longitude);

      if (lat == null || lng == null) continue;

      newMarkers.add(
        Marker(
          markerId: MarkerId(v.vehno),
          position: LatLng(lat, lng),
          icon: icon,
          anchor: const Offset(0.5, 0.5),
          onTap: () => Get.to(() => VehicleTrackScreen(data: v)),
        ),
      );
    }

    if (!isSingleFocusMode.value) {
      markers.assignAll(newMarkers);
    }
  }

  /// ================= FILTER APPLY =================
  void applyFilter(VehicleFilter filter) async {
    selectedFilter.value = filter;
    isSingleFocusMode.value = false;
    isMarkerLoading.value = true;
    _lastZoomBucket = -1;
    _markerCache.clear();

    if (mapController != null) {
      await mapController!.animateCamera(CameraUpdate.newLatLngZoom(const LatLng(22.9734, 78.6569), 5.5));
    }

    currentZoom.value = 5.5;
    await updateMarkersByZoom(force: true);
    isMarkerLoading.value = false;
  }

  /// ================= MARKER DESIGN =================
  Future<BitmapDescriptor> _dotWithText({
    required String text,
    required double fontSize,
    required bool isCluster,
    double size = 300, // Increased size to prevent clipping for larger icon
  }) async {
    final cacheKey = "${text}_${isCluster}_$fontSize";

    if (_markerCache.containsKey(cacheKey)) {
      return _markerCache[cacheKey]!;
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();

    if (isCluster) {
      final double radius = 35;
      final center = Offset(size / 2, size / 2);

      paint.color = Colors.blue.withOpacity(0.3);
      canvas.drawCircle(center, radius + 10, paint);

      paint.color = Colors.blue.shade700;
      canvas.drawCircle(center, radius, paint);

      paint.style = PaintingStyle.stroke;
      paint.color = Colors.white;
      paint.strokeWidth = 3;
      canvas.drawCircle(center, radius, paint);

      paint.style = PaintingStyle.fill;

      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
    } else {
      if (_cachedTruckIcon == null) await _loadResources();
      final ui.Image iconImage = _cachedTruckIcon!;

      final centerX = size / 2;
      final centerY = size / 2;

      final truckX = centerX - (iconImage.width / 2);
      final truckY = centerY - (iconImage.height / 2) - 25; // Adjusted for larger size

      canvas.drawImage(iconImage, Offset(truckX, truckY), Paint());

      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout();

      final rectWidth = tp.width + 18;
      final rectHeight = tp.height + 10;
      final rectX = centerX - (rectWidth / 2);
      final rectY = truckY + iconImage.height - 5;

      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(rectX + 1, rectY + 1, rectWidth, rectHeight), const Radius.circular(6)), shadowPaint);

      // Main Plate Background
      final platePaint = Paint()..color = Colors.indigo.shade900;
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(rectX, rectY, rectWidth, rectHeight), const Radius.circular(6)), platePaint);

      // Plate Border
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(rectX, rectY, rectWidth, rectHeight), const Radius.circular(6)),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );

      // Small pointer
      final path = Path();
      path.moveTo(centerX - 8, rectY);
      path.lineTo(centerX + 8, rectY);
      path.lineTo(centerX, rectY - 5);
      path.close();
      canvas.drawPath(path, platePaint);

      tp.paint(canvas, Offset(rectX + 9, rectY + 5));
    }

    final img = await recorder.endRecording().toImage(size.toInt(), size.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final descriptor = BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());

    _markerCache[cacheKey] = descriptor;

    return descriptor;
  }
}
