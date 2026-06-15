import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harsh/moduls/fuel_trip_sheet_page/sub_screen/add_attach_fuel_screen.dart';
import 'package:harsh/widgets/tms_button.dart';
import 'package:intl/intl.dart';
import '../../app_routes.dart';
import '../../utils/tms_color.dart';
import '../pod_page/pod_controller.dart';
import 'fuel_trip_sheet_controller.dart';

class FuelTripSheet extends StatefulWidget {
  const FuelTripSheet({key});

  @override
  State<FuelTripSheet> createState() => _FuelTripSheetState();
}

class _FuelTripSheetState extends State<FuelTripSheet> {
  FuelTripSheetController fuelTripSheetController = Get.put(FuelTripSheetController());

  @override
  void initState() {
    // TODO: implement initState

    Future.delayed(Duration.zero, () {
      fuelTripSheetController.fuelTripSheet();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Fuel Trip List',
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
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  _showFilterBottomSheet(context);
                },
                child: const Icon(
                  Icons.filter_list,
                  size: 25,
                  color: AppColor.white,
                ),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Obx(() {
            if (fuelTripSheetController.fuelTripStatus.value == ApiStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (fuelTripSheetController.fuelTripStatus.value == ApiStatus.error) {
              return const Center(child: Text("No Data Found"));
            } else {
              return ListView.separated(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: fuelTripSheetController.fuelTripList.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (BuildContext context, int index) {
                    var fuelTrip = fuelTripSheetController.fuelTripList[index];
                    return Card(
                      elevation: 2,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                      child: InkWell(
                        onTap: () {
                          Get.to(() => AddAttachFuelScreen(
                                fuelTripSheetController: fuelTripSheetController,
                                fuelTripList: fuelTrip,
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${fuelTrip.vSlipNo}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                              _buildInfoRow("Trip Sheet Date : ", fuelTrip.vSlipDt),
                              const SizedBox(height: 2),
                              _buildInfoRow("Vehicle No : ", fuelTrip.vehicleNo),
                              const SizedBox(height: 2),
                              _buildInfoRow("Driver : ", fuelTrip.driverName),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
          }),
        ));
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(
          width: 3,
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Options',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: fuelTripSheetController.tripSheetNoController,
                    decoration: const InputDecoration(
                      labelText: 'Trip Sheet No.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: fuelTripSheetController.vehicleNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Vehicle No.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: fuelTripSheetController.fromDateController,
                          decoration: const InputDecoration(
                            labelText: 'From Date',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () {
                            _selectDate(context, fuelTripSheetController.fromDateController);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: fuelTripSheetController.toDateController,
                          decoration: const InputDecoration(
                            labelText: 'To Date',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () {
                            _selectDate(context, fuelTripSheetController.toDateController);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TmsButton(
                          onPressed: () {
                            fuelTripSheetController.tripSheetNoController.clear();
                            fuelTripSheetController.vehicleNumberController.clear();
                            Navigator.pop(context);
                          },
                          text: 'Clear',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TmsButton(
                          onPressed: () {
                            fuelTripSheetController.fuelTripSheet();
                            Navigator.pop(context);
                          },
                          text: 'Apply Filter',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('d MMM yyyy').format(picked);
      });
    }
  }
}
