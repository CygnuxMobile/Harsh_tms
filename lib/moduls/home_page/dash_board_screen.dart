import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harsh/app_routes.dart';
import 'package:harsh/environments .dart';
import 'package:harsh/moduls/home_page/dash_board_controller.dart';
import 'package:harsh/moduls/quick_docket_page/quick_docket_controller.dart';
import 'package:harsh/widgets/app_size.dart';
import 'package:harsh/widgets/dashboard_widgets/custom_box.dart';
import 'package:harsh/widgets/tms_button.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:location/location.dart';
import '../../utils/pref.dart';
import '../../widgets/custom_dropdown_search.dart';
import '../../widgets/dashboard_widgets/custom_drawer.dart';
import '../../widgets/tms_normaltext.dart';
import '../../widgets/tost.dart';
import '../attendance_page/attendance_controller.dart';
import '../quick_docket_page/quick_docket_nemu_screen.dart';
import '../trecking_page/tracking_controller.dart';

enum DashBordMenuEnum { manifest, stockUpdate, stockUpdateList, drsList, drsUpdate, none }

DashBordMenuEnum dashBordMenuEnum = DashBordMenuEnum.none;

enum WebViewEnum { manifest, thc, stockUpdate, arrival, none }

WebViewEnum webViewEnum = WebViewEnum.none;

class DashBordScreen extends StatefulWidget {
  const DashBordScreen({Key? key}) : super(key: key);

  @override
  State<DashBordScreen> createState() => _DashBordScreenState();
}

class _DashBordScreenState extends State<DashBordScreen> {
  DashBoardController ctrl = Get.put(DashBoardController());
  AttendanceController attendanceController = Get.put(AttendanceController());
  TrackingController trackingController = Get.put(TrackingController());
  QuickDocketController quickDocketController = Get.put(QuickDocketController());

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    Location location = Location();

    return LoaderOverlay(
      useDefaultLoading: false,
      overlayColor: Colors.black.withOpacity(0.3),
      child: Scaffold(
        key: scaffoldKey,
        drawer: drawer(context),

        appBar: AppBar(
          title: TmsText(text: 'Dashboard', color: Colors.white),
          centerTitle: true,
          backgroundColor: const Color(0xff232F34),
          leading: IconButton(
            icon: const Icon(Icons.dehaze_outlined, color: Colors.white),
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
          ),
        ),

        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

            child: Obx(() {
              if (ctrl.menuStatus.value != MenuStatus.loading) {
                /// USER HAS RIGHTS
                if (ctrl.isAnyMenu.isTrue) {
                  return Column(
                    children: [
                      SizedBox(height: AppSize.size(context).height * 0.02),

                      /// LOCATION DROPDOWN
                      ctrl.location.length > 1
                          ? Obx(
                              () => Dropdown(
                                height: 25.0.obs,
                                image: "assets/images/dashboardimages/To.png".obs,
                                enabled: true.obs,
                                isSize: false,
                                boxDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xFFE9ECEF),
                                  border: Border.all(color: Colors.grey, width: 1),
                                ),
                                text: Pref().getBaseLocation().isEmpty ? '  Select Location '.obs : '  ${Pref().getBaseLocation()}'.obs,
                                list: ctrl.location.map((e) => '${e.locCode} - ${e.locName}').toList(),
                                onChanged: (value) async {
                                  await ctrl.getLocationCode(value!);
                                },
                              ),
                            )
                          : Container(
                              alignment: Alignment.center,
                              height: AppSize.size(context).height * 0.07,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xFFE9ECEF)),
                              child: DropdownSearch(
                                selectedItem: Pref().getBranchCode(),
                                enabled: false,
                                items: [Pref().getBranchCode()],
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    prefix: const Icon(Icons.location_on_outlined, color: Color(0xFF023E8A), size: 25),
                                    border: InputBorder.none,
                                    hintText: Pref().getBranchCode(),
                                  ),
                                ),
                              ),
                            ),

                      const SizedBox(height: 20),

                      /// GRID MENU
                      Flexible(
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          children: [
                            for (var module in ctrl.menuList)
                              if (module == 'Quick Docket')
                                DashBoardContainer(
                                  text: 'Quick Docket',
                                  image: 'assets/images/dashboardimages/Delivery Boy.png',
                                  ontap: () {
                                    quickDocketController.getFromToCityType(locationID: Pref().getBaseLocation());
                                    Get.to(QuickDocketOptionScreen());
                                  },
                                )
                              else if (module == 'GCN')
                                DashBoardContainer(
                                  text: 'GCN',
                                  image: 'assets/images/dashboardimages/gcn.png',
                                  ontap: () {
                                    ctrl.docketNumber.clear();
                                  },
                                )
                              else if (module == 'Manifest')
                                DashBoardContainer(
                                  text: 'Manifest',
                                  image: 'assets/images/dashboardimages/manifest.png',
                                  ontap: () {
                                    Get.toNamed(AppRoutes.manifestScreen);
                                  },
                                )
                              else if (module == 'Arrival')
                                DashBoardContainer(
                                  text: 'Arrival',
                                  image: 'assets/images/dashboardimages/arrived.png',
                                  ontap: () {
                                    customBottomSheetArrival(context);
                                  },
                                )
                              else if (module == 'Stock Update')
                                DashBoardContainer(
                                  text: 'Stock Update',
                                  image: 'assets/images/dashboardimages/Stock Update.png',
                                  ontap: () {
                                    dashBordMenuEnum = DashBordMenuEnum.stockUpdate;
                                    String? baseLocation = Pref().getBaseLocation();
                                    if (baseLocation.isEmpty) {
                                      TmsToast.msg('Please add Location');
                                    } else {
                                      stockUpdateBottomSheetArrival(context);
                                    }
                                  },
                                )
                              else if (module == 'DRS')
                                DashBoardContainer(
                                  text: 'DRS',
                                  image: 'assets/images/dashboardimages/Delivery Boy.png',
                                  ontap: () {
                                    String? baseLocation = Pref().getBaseLocation();
                                    if (baseLocation.isEmpty) {
                                      dashBordMenuEnum = DashBordMenuEnum.drsList;
                                      TmsToast.msg('Please add Location');
                                    } else {
                                      dashBordMenuEnum = DashBordMenuEnum.drsList;
                                      DrsBottomSheetArrival(context);
                                    }
                                  },
                                )
                              else if (module == 'POD')
                                DashBoardContainer(
                                  text: 'POD',
                                  image: 'assets/images/dashboardimages/POD.png',
                                  ontap: () {
                                    Get.toNamed(AppRoutes.podScreen);
                                  },
                                )
                              else if (module == 'Tracking')
                                DashBoardContainer(
                                  text: 'Tracking',
                                  image: 'assets/images/dashboardimages/Tracking.png',
                                  ontap: () {
                                    trackingCustomBottomSheet(context);
                                  },
                                )
                              else if (module == 'Attendance')
                                DashBoardContainer(
                                  text: 'Attendance',
                                  image: 'assets/images/dashboardimages/imgpsh_fullsize_anim.png',
                                  ontap: () async {
                                    bool serviceEnabled = await location.serviceEnabled();

                                    if (!serviceEnabled) {
                                      showGpsDialog(context);
                                    } else {
                                      attendanceController.getAttendance(context);
                                    }
                                  },
                                ),
                            DashBoardContainer(
                              text: 'Control Tower',
                              image: 'assets/images/dashboardimages/imgpsh_fullsize_anim.png',
                              ontap: () {
                                Get.toNamed(AppRoutes.controlTowerScreen);
                              },
                            ),

                                 DashBoardContainer(
                              text: 'Loading',
                              image: 'assets/images/dashboardimages/imgpsh_fullsize_anim.png',
                              ontap: () {
                                Get.toNamed(AppRoutes.loadingScreen);
                              },
                            ),

                          ],
                        ),
                      ),
                    ],
                  );
                }
                /// USER HAS NO RIGHTS
                else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: [
                        DashBoardContainer(
                          text: 'Control Tower',
                          image: 'assets/images/dashboardimages/imgpsh_fullsize_anim.png',
                          ontap: () {
                            Get.toNamed(AppRoutes.controlTowerScreen);
                          },
                        ),
                      ],
                    ),
                  );
                }
              }

              return const Center(child: CircularProgressIndicator(color: Color(0xff232F34)));
            }),
          ),
        ),
      ),
    );
  }

  /// GPS DIALOG
  Future<void> showGpsDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),

          title: const Text('GPS Not Enabled'),

          content: const Text('Please enable GPS to continue.'),

          actions: [
            TmsButton(
              text: "OK",
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
