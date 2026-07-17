import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../utils/tms_color.dart';
import 'control_tower_controller.dart';
import '../../model/control_tower_model/control_tower_response.dart';

class ControlTowerScreen extends StatelessWidget {
  ControlTowerScreen({super.key});

  final controller = Get.put(ControlTowerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Control Tower",
          style: TextStyle(color: AppColor.white),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: AppColor.white),
        ),
        backgroundColor: const Color(0xff232F34),
        centerTitle: true,

        actions: [
          Obx(
                () => IconButton(
              onPressed: controller.toggleMapType,
              icon: Icon(
                controller.mapType.value == MapType.normal
                    ? Icons.satellite
                    : Icons.map,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SlidingUpPanel(
          controller: controller.panelController,
          minHeight: 220,
          maxHeight: Get.height * 0.87,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          color: Colors.white,

          /// ================= PANEL =================
          panel: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 6),
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10)),
                ),

                /// SEARCH
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    onChanged: (v) => controller.searchText.value = v,
                    decoration: InputDecoration(
                      hintText: "Search vehicle",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                /// VEHICLE LIST
                Expanded(
                  child: Obx(
                        () => ListView.builder(
                      itemCount: controller.searchedVehicles.length,
                      itemBuilder: (_, i) =>
                          _vehicleTile(controller.searchedVehicles[i]),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// ================= MAP =================
          body: Stack(
            children: [
              /// MAP
              Obx(
                    () => GoogleMap(
                  mapType: controller.mapType.value,
                  initialCameraPosition: const CameraPosition(
                      target: LatLng(22.9734, 78.6569), zoom: 5.5),
                  markers: controller.markers.value,
                  zoomControlsEnabled: false,
                  tiltGesturesEnabled: false,
                  onMapCreated: (map) async {
                    controller.mapController = map;
                    controller.currentZoom.value =
                    await map.getZoomLevel();
                    await controller.updateMarkersByZoom(force: true);
                  },
                  onCameraIdle: () async {
                    final z = await controller.mapController?.getZoomLevel();
                    if (z != null) {
                      controller.currentZoom.value = z;
                      await controller.updateMarkersByZoom();
                    }
                  },
                ),
              ),

              /// FILTER CHIPS
              _buildFloatingFilterBar(),



              /// LOADER
              Obx(() {
                if (!controller.isMarkerLoading.value) {
                  return const SizedBox();
                }

                return Container(
                  color: Colors.black.withOpacity(.2),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFloatingFilterBar() {
    return Positioned(
      top: 16,
      left: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
          ],
        ),
        child: Obx(
              () => Row(
            children: [
              _filterChip("All", controller.vehicleList.length,
                  Colors.blueGrey, VehicleFilter.all),

              _filterChip(
                  "Moving",
                  controller.vehicleList.where((v) => v.isMoving).length,
                  Colors.blue,
                  VehicleFilter.moving),

              _filterChip(
                  "Idle",
                  controller.vehicleList
                      .where((v) =>
                  !v.isMoving &&
                      (double.tryParse(v.speed) ?? 0) > 0)
                      .length,
                  Colors.orange,
                  VehicleFilter.idle),

              _filterChip(
                  "Stopped",
                  controller.vehicleList
                      .where((v) =>
                  !v.isMoving &&
                      (double.tryParse(v.speed) ?? 0) == 0)
                      .length,
                  Colors.red,
                  VehicleFilter.stopped),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterChip(
      String label, int count, Color color, VehicleFilter filter) {
    bool isSelected = controller.selectedFilter.value == filter;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.applyFilter(filter),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
              color: isSelected ? color : Colors.transparent,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Text(
                count.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : color,
                    fontSize: 16),
              ),
              Text(label,
                  style: TextStyle(
                      fontSize: 10,
                      color:
                      isSelected ? Colors.white70 : Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _vehicleTile(ControlTower v) {
    final double speed = double.tryParse(v.speed) ?? 0;

    final Color statusColor =
    v.isMoving ? Colors.blue : speed == 0 ? Colors.red : Colors.orange;

    final bool hasLocation =
        v.latitude.isNotEmpty && v.longitude.isNotEmpty;

    final String statusText =
    v.isMoving ? "Moving" : v.isParked ? "Stopped" : "Idle";

    return InkWell(
      onTap: () async {
        if (!hasLocation) return;

        await controller.focusOnVehicle(
            double.parse(v.latitude), double.parse(v.longitude), v);

        controller.panelController.close();
      },
      child: Container(
        margin:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3))
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                  color: statusColor.withOpacity(.15),
                  shape: BoxShape.circle),
              child: Icon(Icons.local_shipping,
                  color: statusColor, size: 22),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(v.vehno,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Text("$statusText • ",
                          style: TextStyle(
                              color: statusColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                      Text("${speed.toStringAsFixed(0)} km/h",
                          style: const TextStyle(fontSize: 13)),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    v.vMainStatus.isNotEmpty
                        ? v.vMainStatus
                        : "Status not available",
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black87),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    hasLocation
                        ? "Lat: ${v.latitude}, Lng: ${v.longitude}"
                        : "Location not available",
                    style: const TextStyle(
                        fontSize: 11.5, color: Colors.black54),
                  ),

                  if (v.driverName.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text("Driver: ${v.driverName}",
                        style: const TextStyle(
                            fontSize: 11.5,
                            color: Colors.black54)),
                  ],
                ],
              ),
            ),

            const Icon(Icons.chevron_right, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}