import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:harsh/widgets/app_size.dart';
import 'package:harsh/widgets/tms_button.dart';
import 'package:harsh/widgets/tms_normaltext.dart';
import '../../app_routes.dart';
import '../../utils/tms_color.dart';
import 'new_trip_controller.dart';

class NewTripScreen extends StatefulWidget {
  NewTripScreen({key});

  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  NewTripController newTripController = Get.find<NewTripController>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    newTripController.vehicleDetailsApi();
    newTripController.driverDetailsApi();
    newTripController.locationMasterDataApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Open Trip',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff232F34),
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.toNamed(AppRoutes.dashboardScreen);
          },
          child: const Icon(
            Icons.arrow_back,
            size: 25,
            color: AppColor.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: DropdownSearch<String>(
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                            ),
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Select Start Location',
                                labelText: 'Start Location',
                              ),
                            ),
                            selectedItem: newTripController.selectedStartLocation.isEmpty
                                ? 'Select Start Location'
                                : newTripController.selectedStartLocation.value,
                            items: newTripController.branchList.map((element) => element.locCode).toList(),
                            onChanged: (value) async {
                              newTripController.selectedStartLocation.value = value!;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty || value == 'Select Start Location') {
                                return 'Please select a start location';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: DropdownSearch<String>(
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                            ),
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Select End Location',
                                labelText: 'End Location',
                              ),
                            ),
                            selectedItem:
                                newTripController.selectedEndLocation.isEmpty ? 'Select End Location' : newTripController.selectedEndLocation.value,
                            items: newTripController.branchList.map((element) => element.locCode).toList(),
                            onChanged: (value) async {
                              newTripController.selectedEndLocation.value = value!;
                              for (var data in newTripController.branchList) {
                                if (data.locCode == value) {
                                  newTripController.selectedEndNameLocation.value = data.locName;
                                }
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty || value == 'Select End Location') {
                                return 'Please select a end location';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: TextEditingController(text: "Internal Usage"),
                        enabled: true,
                        decoration: const InputDecoration(
                          labelText: 'Century',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.none,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: TextEditingController(text: "Own"),
                        enabled: true,
                        decoration: const InputDecoration(
                          labelText: 'Market\\Own',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.none,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: TextEditingController(text: "Own"),
                        enabled: true,
                        decoration: const InputDecoration(
                          labelText: 'Vehicle Mode',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.none,
                      ),
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: DropdownSearch<String>(
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                            ),
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Select Vehicle No',
                                labelText: 'Vehicle No',
                              ),
                            ),
                            selectedItem: newTripController.selectedVehicle.isEmpty ? 'Select Vehicle No' : newTripController.selectedVehicle.value,
                            items: newTripController.vehicleDetailsList.map((element) => element.vehno).toList(),
                            onChanged: (value) async {
                              newTripController.selectedVehicle.value = value!;
                              for (var data in newTripController.vehicleDetailsList) {
                                if (data.vehno == value) {
                                  newTripController.startKmController.text = data.currenTKmRead.toString();
                                }
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty || value == 'Select Vehicle No') {
                                return 'Please select a Vehicle No';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: newTripController.startKmController,
                        enabled: true,
                        decoration: const InputDecoration(
                          labelText: 'Start Km',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.none,
                      ),
                      const SizedBox(height: 10),
                      Center(child: TmsText(text: "Driver Details", fontSize: 25, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: DropdownSearch<String>(
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                            ),
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Select Driver',
                                labelText: 'Driver',
                              ),
                            ),
                            selectedItem: newTripController.selectedDriver.isEmpty ? 'Select Driver' : newTripController.selectedDriver.value,
                            items: newTripController.driverDetails.map((element) => element.driverName).toList(),
                            onChanged: (value) async {
                              newTripController.selectedDriver.value = value!;
                              for (var data in newTripController.driverDetails) {
                                if (data.driverName == value) {
                                  newTripController.selectedDriver = data.driverId.obs;
                                  newTripController.driverNameController.text = data.driverName;
                                  newTripController.driverLicenseNoController.text = data.licenseNo;
                                  newTripController.driverLicenseValidUpToController.text = data.valdityDt;
                                  newTripController.mobileNoController.text = data.mobileno;
                                }
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty || value == 'Select Driver') {
                                return 'Please select driver';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: newTripController.driverNameController,
                        enabled: true,
                        decoration: const InputDecoration(
                          labelText: 'Driver Name',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.none,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: newTripController.driverLicenseNoController,
                        enabled: true,
                        decoration: const InputDecoration(
                          labelText: 'Driver License No',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.none,
                      ),
                      const SizedBox(height: 20),
                      TmsButton(
                        size: Size(double.infinity, AppSize.size(context).height * 0.065),
                        text: "Submit",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            newTripController.newTripSubmitApi(
                              vehicleNo: newTripController.selectedVehicle.value,
                              startLocation: newTripController.selectedStartLocation.value,
                              endLocation: newTripController.selectedEndLocation.value,
                              endLocationName: newTripController.selectedEndNameLocation.value,
                              driver: newTripController.selectedDriver.value,
                              driverName: newTripController.driverNameController.text,
                              driverMobileNo: newTripController.mobileNoController.text,
                              startKm: double.parse(newTripController.startKmController.text),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
