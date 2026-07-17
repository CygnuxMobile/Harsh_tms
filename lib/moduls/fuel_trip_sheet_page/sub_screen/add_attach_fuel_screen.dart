import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harsh/widgets/tms_button.dart';
import 'package:intl/intl.dart';
import '../../../model/fuel_trip_sheet_model/fuel_trip_sheet_model.dart';
import '../../../utils/tms_color.dart';
import '../fuel_trip_sheet_controller.dart';

class AddAttachFuelScreen extends StatefulWidget {
  const AddAttachFuelScreen({required this.fuelTripSheetController, required this.fuelTripList});

  final FuelTripSheetController fuelTripSheetController;
  final FuelTripList fuelTripList;

  @override
  State<AddAttachFuelScreen> createState() => _AddAttachFuelScreenState();
}

class _AddAttachFuelScreenState extends State<AddAttachFuelScreen> {
  late DateTime _selectedDate;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    try {
      _selectedDate = DateFormat('dd MMMM yyyy').parse(widget.fuelTripSheetController.fuelEntryDateController.text);
    } catch (e) {
      _selectedDate = DateTime.now();
      widget.fuelTripSheetController.fuelEntryDateController.text = DateFormat('dd MMMM yyyy').format(_selectedDate);
    }
    widget.fuelTripSheetController.quantityInLitersController.addListener(_calculateAmount);
    widget.fuelTripSheetController.rateController.addListener(_calculateAmount);
  }

  void _calculateAmount() {
    final double quantity = double.tryParse(widget.fuelTripSheetController.quantityInLitersController.text) ?? 0.0;
    final double rate = double.tryParse(widget.fuelTripSheetController.rateController.text) ?? 0.0;
    final double amount = quantity * rate;
    widget.fuelTripSheetController.amountController.text = amount.toStringAsFixed(2);
  }

  @override
  void dispose() {
    widget.fuelTripSheetController.quantityInLitersController.removeListener(_calculateAmount);
    widget.fuelTripSheetController.rateController.removeListener(_calculateAmount);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Attach Fuel',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff232F34),
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            size: 30,
            color: AppColor.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    enabled: false,
                    controller: TextEditingController(text: "Fuel"),
                    decoration: const InputDecoration(
                      labelText: 'Slip Type',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: widget.fuelTripSheetController.fuelEntryDateController,
                    decoration: const InputDecoration(
                      labelText: 'Fuel Entry Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a fuel entry date';
                      }
                      return null;
                    },
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != _selectedDate) {
                        setState(() {
                          _selectedDate = pickedDate;
                          widget.fuelTripSheetController.fuelEntryDateController.text = DateFormat('dd MMMM yyyy').format(_selectedDate);
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: widget.fuelTripSheetController.fuelVendorController,
                    decoration: const InputDecoration(
                      labelText: 'Fuel Vendor',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a fuel vendor';
                      }
                      return null;
                    },
                    onTap: () {
                      _showFuelVendorBottomSheet(context);
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: widget.fuelTripSheetController.quantityInLitersController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity in Liters',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter quantity';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                    onChanged: (value) => _calculateAmount(),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: widget.fuelTripSheetController.rateController,
                    decoration: const InputDecoration(
                      labelText: 'Rate',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter rate';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                    onChanged: (value) => _calculateAmount(),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    enabled: false,
                    controller: widget.fuelTripSheetController.amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  TmsButton(
                    size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.060),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.fuelTripSheetController.fuelSubmitApi(
                          vSlipNo: widget.fuelTripList.vSlipNo,
                          amount: widget.fuelTripSheetController.amountController.text.isNotEmpty
                              ? double.parse(widget.fuelTripSheetController.amountController.text)
                              : 0,
                          fuelvendor: widget.fuelTripSheetController.fuelVendorCodeController.text,
                          vehicleNo: widget.fuelTripList.vehicleNo,
                          fuelSlipDate: widget.fuelTripSheetController.fuelEntryDateController.text,
                          quantityinliter: widget.fuelTripSheetController.quantityInLitersController.text.isNotEmpty
                              ? double.parse(widget.fuelTripSheetController.quantityInLitersController.text)
                              : 0,
                          rate: widget.fuelTripSheetController.rateController.text.isNotEmpty
                              ? double.parse(widget.fuelTripSheetController.rateController.text)
                              : 0,
                          sliptype: 1,
                        );
                      }
                    },
                    text: 'Submit',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showFuelVendorBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: widget.fuelTripSheetController.fuelVendorSearchController,
                  onChanged: (value) {
                    if (value.length >= 3) {
                      widget.fuelTripSheetController.isLoading.value = true;
                      widget.fuelTripSheetController.fuelVendorListApi(value);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Search Fuel Vendor',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {},
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Obx(() {
                    if (widget.fuelTripSheetController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (widget.fuelTripSheetController.vendorList.isEmpty) {
                      return const Center(child: Text('No vendors found'));
                    }
                    return ListView.builder(
                      itemCount: widget.fuelTripSheetController.vendorList.length,
                      itemBuilder: (context, index) {
                        final vendor = widget.fuelTripSheetController.vendorList[index];
                        return ListTile(
                          title: Text(vendor.vendorname),
                          subtitle: Text(vendor.vendorcode),
                          onTap: () {
                            widget.fuelTripSheetController.fuelVendorController.text = vendor.vendorname;
                            widget.fuelTripSheetController.fuelVendorCodeController.text = vendor.vendorcode;
                            widget.fuelTripSheetController.fuelVendorSearchController.clear();
                            Get.back();
                          },
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      widget.fuelTripSheetController.fuelVendorSearchController.clear();
      widget.fuelTripSheetController.fuelVendors.clear();
      widget.fuelTripSheetController.isLoading.value = false;
    });
  }
}
