import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:harsh/moduls/loading_page/loading_controller.dart';
import 'package:harsh/widgets/tms_normaltext.dart';
import '../../utils/pref.dart';
import '../../widgets/custom_dropdown_search.dart';
import '../../widgets/tms_button.dart';

class LoadingScreen extends StatelessWidget {
  LoadingScreen({super.key});

  final LoadingController ctrl = Get.find<LoadingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TmsText(text: 'Loading Slip', fontSize: 18, color: Colors.white),
        centerTitle: true,
        backgroundColor: const Color(0xff232F34),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: ctrl.formKey,
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Start Location'),
                  _buildTextField('Start Location', TextEditingController(text: Pref().getBaseLocation()), isReadOnly: true),
        
                  _buildLabel('End Location'),
                  FormField<String>(
                    validator: (value) => (ctrl.selectedEndLocation.value.isEmpty || ctrl.selectedEndLocation.value.contains("Select")) ? "End Location Required" : null,
                    builder: (state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => ctrl.isLocationLoading.value
                            ? Container(
                                height: 50,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: state.hasError ? Colors.red : const Color(0xff232F34).withOpacity(0.5), width: state.hasError ? 1.5 : 1.0),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(ctrl.selectedEndLocation.value.isEmpty ? 'Select To Location' : ctrl.selectedEndLocation.value, style: TextStyle(color: ctrl.selectedEndLocation.value.isEmpty ? Colors.grey : Colors.black, fontSize: 14)),
                                    const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Color(0xff232F34), strokeWidth: 2)),
                                  ],
                                ),
                              )
                            : Dropdown(
                                image: "assets/images/dashboardimages/Form.png".obs,
                                enabled: true.obs,
                                isSize: false,
                                text: ctrl.selectedEndLocation.value.isEmpty ? 'Select To Location'.obs : ctrl.selectedEndLocation.value.obs,
                                list: ctrl.location.map((element) => '${element.locCode} - ${element.locName}').toList(),
                                onChanged: (value) async {
                                  ctrl.selectedEndLocation.value = value!;
                                  state.didChange(value);
                                  ctrl.selectedCityRoute.value = "";
                                  ctrl.fetchCityRoute(toCity: ctrl.LocationName(value));
                                },
                                boxDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: state.hasError ? Colors.red : const Color(0xff232F34).withOpacity(0.5), width: state.hasError ? 1.5 : 1.0),
                                  color: Colors.white,
                                ),
                              ),
                          ),
                          if (state.hasError)
                            Padding(padding: const EdgeInsets.only(top: 5, left: 5), child: Text(state.errorText!, style: const TextStyle(color: Colors.red, fontSize: 12))),
                        ],
                      );
                    },
                  ),
        
                  // _buildLabel('Basic Details', isHeader: true),
                  
                  _buildLabel('Enter Customer Code'),
                  _buildSearchField(
                    hint: "Search Customer",
                    value: ctrl.selectedCustomer.value,
                    onTap: () => _showSearchBottomSheet(context, "Customer"),
                    validator: (value) => (ctrl.selectedCustomer.value.isEmpty || ctrl.selectedCustomer.value.contains("Search")) ? "Customer Code Required" : null,
                  ),
        
                  _buildLabel('City Route code'),
                  _buildDropdown('Route Name', ctrl.cityRouteNames, ctrl.selectedCityRoute, (val) {
                    if (val != null) {
                      ctrl.selectedVehicle.value = "";
                      ctrl.fetchVehicles(city: ctrl.LocationName(val));
                    }
                  }, validator: (value) => (value == null || value.isEmpty || value.contains("Route")) ? "Route Name Required" : null, isLoading: ctrl.isCityRouteLoading),
        
                  _buildLabel('Loading Slip Date'),
                  _buildDatePicker(
                    context,
                    ctrl.loadingSlipDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 1)),
                    lastDate: DateTime.now(),
                    includeTime: true,
                    validator: (value) => (ctrl.loadingSlipDate.value == "Select Date") ? "Loading Slip Date Required" : null,
                  ),
        
                  _buildLabel('Type of Movement'),
                  _buildDropdown('Select Type of Movement', ctrl.typeOfMovementList, ctrl.selectedTypeOfMovement, (val) {},
                      validator: (value) => (value == null || value.isEmpty || value.contains("Select")) ? "Type of Movement Required" : null, isLoading: ctrl.isTypeOfMovementLoading),
        
                  _buildLabel('Vehicle No'),
                  _buildDropdown('Select Vehicle No', ctrl.vehicleNames, ctrl.selectedVehicle, (val) {
                    if (val != null) {
                      ctrl.selectedTripsheet.value = "";
                      ctrl.fetchTripsheets(val);
                      ctrl.fetchVehicleKmReading(val);
                    }
                  }, validator: (value) => (value == null || value.isEmpty || value.contains("Select")) ? "Vehicle No Required" : null, isLoading: ctrl.isVehicleLoading),
        
                  _buildLabel('Tripsheet No.'),
                  _buildDropdown('Select Tripsheet No.', ctrl.tripsheetList, ctrl.selectedTripsheet, (val) {
                    if (val != null) ctrl.fetchDriverDetails(val);
                  }, validator: (value) => (value == null || value.isEmpty || value.contains("Select")) ? "Tripsheet No Required" : null, isLoading: ctrl.isTripsheetLoading),
        
                  // const SizedBox(height: 20),
                  // _buildLabel('Consignor Details', isHeader: true),
                  // _buildConsignorConsigneeRadio(ctrl.consignorType, () {
                  //   ctrl.consignorNameController.clear();
                  //   ctrl.consignorMobileController.clear();
                  //   ctrl.consignorAddressController.clear();
                  //   ctrl.selectedConsignorCode.value = "";
                  // }),
                  // if (ctrl.consignorType.value == 1)
                  //   _buildSearchField(
                  //     hint: "Search Consignor Code",
                  //     value: ctrl.selectedConsignorCode.value,
                  //     onTap: () => _showSearchBottomSheet(context, "Consignor"),
                  //     validator: (value) => (ctrl.selectedConsignorCode.value.isEmpty) ? "Consignor Code Required" : null,
                  //   ),
                  // _buildLabel('Consignor Name'),
                  // _buildTextField('Consignor Name', ctrl.consignorNameController, isReadOnly: ctrl.consignorType.value == 1, isRequired: true),
                  // _buildLabel('Mobile No'),
                  // _buildTextField('Mobile No', ctrl.consignorMobileController, isReadOnly: ctrl.consignorType.value == 1, isRequired: true, isMobile: true),
                  // _buildLabel('Consignor Address'),
                  // _buildTextField('Consignor Address', ctrl.consignorAddressController, isReadOnly: ctrl.consignorType.value == 1, isRequired: true),
                  //
                  // const SizedBox(height: 20),
                  // _buildLabel('Consignee Details', isHeader: true),
                  // _buildConsignorConsigneeRadio(ctrl.consigneeType, () {
                  //   ctrl.consigneeNameController.clear();
                  //   ctrl.consigneeMobileController.clear();
                  //   ctrl.consigneeAddressController.clear();
                  //   ctrl.selectedConsigneeCode.value = "";
                  // }),
                  // if (ctrl.consigneeType.value == 1)
                  //   _buildSearchField(
                  //     hint: "Search Consignee Code",
                  //     value: ctrl.selectedConsigneeCode.value,
                  //     onTap: () => _showSearchBottomSheet(context, "Consignee"),
                  //     validator: (value) => (ctrl.selectedConsigneeCode.value.isEmpty) ? "Consignee Code Required" : null,
                  //   ),
                  // _buildLabel('Consignee Name'),
                  // _buildTextField('Consignee Name', ctrl.consigneeNameController, isReadOnly: ctrl.consigneeType.value == 1, isRequired: true),
                  // _buildLabel('Mobile No'),
                  // _buildTextField('Mobile No', ctrl.consigneeMobileController, isReadOnly: ctrl.consigneeType.value == 1, isRequired: true, isMobile: true ,),
                  // _buildLabel('Consignee Address'),
                  // _buildTextField('Consignee Address', ctrl.consigneeAddressController, isReadOnly: ctrl.consigneeType.value == 1, isRequired: true),
                  //
                  // const SizedBox(height: 20),
                  // _buildLabel('Broker\'s Details', isHeader: true),
                  // _buildLabel('Broker\'s Name'),
                  // _buildTextField('Broker\'s Name', ctrl.brokerNameController),
                  // _buildLabel('Broker\'s Mobile No'),
                  // _buildTextField('Broker\'s Mobile No', ctrl.brokerMobileController, isMobile: true),
                  //
                  // const SizedBox(height: 20),
                  // _buildLabel('Driver 1 Details', isHeader: true),
                  // _buildLabel('Driver Name'),
                  // _buildTextField('Driver Name', ctrl.driverNameController, isReadOnly: true, isRequired: true),
                  // _buildLabel('Mobile No'),
                  // _buildTextField('Mobile No', ctrl.driverMobileController, isReadOnly: true, isRequired: true, isMobile: true),
                  // _buildLabel('Licence No'),
                  // _buildTextField('Licence No', ctrl.driverLicenceController, isReadOnly: true, isRequired: true),
                  // _buildLabel('Licence Validity Date'),
                  // _buildDatePicker(context, ctrl.licenceValidityDate, isReadOnly: true, isRequired: true, label: 'Licence Validity Date'),
        
                  // const SizedBox(height: 20),
                  // _buildLabel('Loading Details', isHeader: true),
                  // _buildLabel('Freight Type'),
                  // _buildDropdown('Select Freight Type', ctrl.freightTypeList, ctrl.selectedFreightType, (val) {},
                  //     validator: (value) => (value == null || value.isEmpty) ? "Freight Type Required" : null, isLoading: ctrl.isFreightTypeLoading),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [_buildLabel('Weight'), _buildTextField('Weight', ctrl.weightController, isRequired: true, isNumber: true)],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Unit'),
                            _buildDropdown('Unit', ctrl.weightTypeList, ctrl.selectedWeightType, (val) {},
                                validator: (value) => (value == null || value.isEmpty) ? "Unit Required" : null, isLoading: ctrl.isWeightTypeLoading)
                          ],
                        ),
                      ),
                    ],
                  ),
                  // _buildLabel('Guarantee'),
                  // _buildTextField('Guarantee', ctrl.guaranteeController, isRequired: true, isNumber: true),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           _buildLabel('Contract Amount'),
                  //           _buildTextField('0', ctrl.contractAmountController, isRequired: true, isAmount: true)
                  //         ],
                  //       ),
                  //     ),
                  //     const SizedBox(width: 15),
                  //     Expanded(
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [_buildLabel('Advance'), _buildTextField('0', ctrl.advanceController, isRequired: true, isNumber: true)],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [_buildLabel('Balance'), _buildTextField('0', ctrl.balanceController, isReadOnly: true)],
                  //       ),
                  //     ),
                  //     const SizedBox(width: 15),
                  //     Expanded(
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [_buildLabel('Starting Km. Reading'), _buildTextField('0', ctrl.startingKmReadingController, isReadOnly: true)],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // _buildLabel('Billed at Location'),
                  // FormField<String>(
                  //   validator: (value) => (ctrl.selectedBilledAtLocation.value.isEmpty || ctrl.selectedBilledAtLocation.value.contains("Select")) ? "Billed at Location Required" : null,
                  //   builder: (state) {
                  //     return Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Obx(() => ctrl.isLocationLoading.value
                  //           ? Container(
                  //               height: 50,
                  //               alignment: Alignment.center,
                  //               padding: const EdgeInsets.symmetric(horizontal: 15),
                  //               decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(10),
                  //                 border: Border.all(color: state.hasError ? Colors.red : const Color(0xff232F34).withOpacity(0.5), width: state.hasError ? 1.5 : 1.0),
                  //                 color: Colors.white,
                  //               ),
                  //               child: Row(
                  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                 children: [
                  //                   Text(ctrl.selectedBilledAtLocation.value.isEmpty ? 'Select Billed At' : ctrl.selectedBilledAtLocation.value, style: TextStyle(color: ctrl.selectedBilledAtLocation.value.isEmpty ? Colors.grey : Colors.black, fontSize: 14)),
                  //                   const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Color(0xff232F34), strokeWidth: 2)),
                  //                 ],
                  //               ),
                  //             )
                  //           : Dropdown(
                  //               image: "assets/images/dashboardimages/Form.png".obs,
                  //               enabled: true.obs,
                  //               isSize: false,
                  //               text: ctrl.selectedBilledAtLocation.value.isEmpty ? 'Select Billed At'.obs : ctrl.selectedBilledAtLocation.value.obs,
                  //               list: ctrl.location.map((element) => '${element.locCode} - ${element.locName}').toList(),
                  //               onChanged: (value) async {
                  //                 ctrl.selectedBilledAtLocation.value = value!;
                  //                 state.didChange(value);
                  //               },
                  //               boxDecoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(10),
                  //                 border: Border.all(color: state.hasError ? Colors.red : const Color(0xff232F34).withOpacity(0.5), width: state.hasError ? 1.5 : 1.0),
                  //                 color: Colors.white,
                  //               ),
                  //             ),
                  //         ),
                  //         if (state.hasError)
                  //           Padding(padding: const EdgeInsets.only(top: 5, left: 5), child: Text(state.errorText!, style: const TextStyle(color: Colors.red, fontSize: 12))),
                  //       ],
                  //     );
                  //   },
                  // ),
                  const SizedBox(height: 30),
                  TmsButton(
                    text: 'Submit',
                    onPressed: () {
                      ctrl.submitLoadingSlip(context);
                    },
                    size: const Size(double.infinity, 45),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildConsignorConsigneeRadio(RxInt type, VoidCallback onClear) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Radio(value: 1, groupValue: type.value, onChanged: (val) { type.value = val as int; onClear(); }, activeColor: const Color(0xff232F34)),
        TmsText(text: "From Master", fontSize: 14),
        Radio(value: 2, groupValue: type.value, onChanged: (val) { type.value = val as int; onClear(); }, activeColor: const Color(0xff232F34)),
        TmsText(text: "Walk-In", fontSize: 14),
      ],
    );
  }

  Widget _buildSearchField({required String hint, required String value, required VoidCallback onTap, String? Function(String?)? validator}) {
    return FormField<String>(
      validator: validator,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: state.hasError ? Colors.red : const Color(0xff232F34).withOpacity(0.5), width: state.hasError ? 1.5 : 1.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: TmsText(text: value.isEmpty ? hint : value, fontSize: 14, color: value.isEmpty ? Colors.grey : Colors.black, textAlign: TextAlign.start)),
                    const Icon(Icons.search, color: Color(0xff232F34)),
                  ],
                ),
              ),
            ),
            if (state.hasError) Padding(padding: const EdgeInsets.only(top: 5, left: 5), child: Text(state.errorText!, style: const TextStyle(color: Colors.red, fontSize: 12))),
          ],
        );
      },
    );
  }

  Widget _buildLabel(String text, {bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.only(top: isHeader ? 15 : 10, bottom: 5),
      child: TmsText(
        text: text,
        fontSize: isHeader ? 16 : 14,
        fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        color: isHeader ? const Color(0xff232F34) : const Color(0xff646D72),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildDropdown(String hint, List<String> items, RxString selectedValue, Function(String?) onChanged, {String? Function(String?)? validator, RxBool? isLoading}) {
    return FormField<String>(
      validator: (val) {
        if (validator != null) {
          // We can just use the provided validator, but we evaluate on selectedValue.value
          return validator(selectedValue.value);
        }
        return null;
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => (isLoading?.value ?? false)
              ? Container(
                  height: 50,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: state.hasError ? Colors.red : const Color(0xff232F34).withOpacity(0.5), width: state.hasError ? 1.5 : 1.0),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(selectedValue.value.isEmpty ? hint : selectedValue.value, style: TextStyle(color: selectedValue.value.isEmpty ? Colors.grey : Colors.black, fontSize: 14)),
                      const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Color(0xff232F34), strokeWidth: 2)),
                    ],
                  ),
                )
              : Dropdown(
                  text: hint.obs,
                  list: items,
                  selectedItem: selectedValue.value.isEmpty ? null : selectedValue,
                  enabled: true.obs,
                  isSize: true,
                  onChanged: (val) {
                    selectedValue.value = val ?? "";
                    state.didChange(val);
                    onChanged(val);
                  },
                  boxDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: state.hasError ? Colors.red : const Color(0xff232F34).withOpacity(0.5), width: state.hasError ? 1.5 : 1.0),
                    color: Colors.white,
                  ),
                ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 5),
                child: Text(state.errorText!, style: const TextStyle(color: Colors.red, fontSize: 12)),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {bool isReadOnly = false, bool isRequired = false, bool isMobile = false, bool isAmount = false, bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: isReadOnly,
        inputFormatters: isMobile ? [LengthLimitingTextInputFormatter(10)] : null,
        keyboardType: (isMobile || isAmount || isNumber) ? TextInputType.number : TextInputType.text,
        style: const TextStyle(fontSize: 15),
        validator: (value) {
          if (isRequired && (value == null || value.trim().isEmpty)) return "$hint Required";
          if (value != null && value.trim().isNotEmpty) {
            if (isAmount && (double.tryParse(value) ?? 0) <= 0) return "Must be > 0";
            if (isMobile && value.length < 10) return "Invalid Mobile";
          }
          return null;
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          filled: true,
          fillColor: isReadOnly ? Colors.grey[100] : Colors.white,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: const Color(0xff232F34).withOpacity(0.5))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: const Color(0xff232F34).withOpacity(0.5))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xff232F34))),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red, width: 1.5)),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, RxString dateValue, {bool isReadOnly = false, DateTime? firstDate, DateTime? lastDate, bool includeTime = false, bool isRequired = false, String? label, String? Function(String?)? validator}) {
    return FormField<String>(
      validator: (val) {
        if (validator != null) return validator(dateValue.value);
        if (isRequired && dateValue.value == "Select Date") return "${label ?? 'Date'} Required";
        return null;
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: isReadOnly ? null : () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: (lastDate != null && DateTime.now().isAfter(lastDate)) ? lastDate : DateTime.now(),
                  firstDate: firstDate ?? DateTime(2000),
                  lastDate: lastDate ?? DateTime(2101),
                );
                if (picked != null) {
                  if (includeTime) {
                    final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                    if (pickedTime != null) {
                      dateValue.value = "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year} ${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                      state.didChange(dateValue.value);
                    }
                  } else {
                    dateValue.value = "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
                    state.didChange(dateValue.value);
                  }
                }
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: state.hasError ? Colors.red : const Color(0xff232F34).withOpacity(0.5), width: state.hasError ? 1.5 : 1.0),
                  color: isReadOnly ? Colors.grey[100] : Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TmsText(text: dateValue.value, fontSize: 14, color: dateValue.value == "Select Date" ? Colors.grey : Colors.black),
                    const Icon(Icons.calendar_month_outlined, color: Color(0xff232F34), size: 20),
                  ],
                ),
              ),
            ),
            if (state.hasError) Padding(padding: const EdgeInsets.only(top: 5, left: 5), child: Text(state.errorText!, style: const TextStyle(color: Colors.red, fontSize: 12))),
          ],
        );
      },
    );
  }

  void _showSearchBottomSheet(BuildContext context, String type) {
    final searchController = type == "Customer" ? ctrl.searchCustomerController : (type == "Consignor" ? ctrl.searchConsignorController : ctrl.searchConsigneeController);
    searchController.clear();
    if(type == "Customer") ctrl.filterCustomers("");
    else if(type == "Consignor") ctrl.filterConsignors("");
    else ctrl.filterConsignees("");

    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TmsText(text: "Select $type", fontSize: 18, fontWeight: FontWeight.bold),
            const SizedBox(height: 15),
            TextField(
              controller: searchController,
              onChanged: (val) {
                if(type == "Customer") ctrl.filterCustomers(val);
                else if(type == "Consignor") ctrl.filterConsignors(val);
                else ctrl.filterConsignees(val);
              },
              decoration: InputDecoration(hintText: "Search here...", prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Obx(() {
                final isLoading = type == "Customer" ? ctrl.isSearchLoading.value : (type == "Consignor" ? ctrl.isConsignorSearchLoading.value : ctrl.isConsigneeSearchLoading.value);
                final list = type == "Customer" ? ctrl.filteredCustomerList : (type == "Consignor" ? ctrl.filteredConsignorList : ctrl.filteredConsigneeList);
                if (isLoading) return const Center(child: CircularProgressIndicator(color: Color(0xff232F34)));
                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: TmsText(text: list[index], fontSize: 14, textAlign: TextAlign.start),
                      onTap: () {
                        if(type == "Customer") { ctrl.selectedCustomer.value = list[index]; }
                        else if(type == "Consignor") { ctrl.getConsignorConsigneeDetails(list[index], true); }
                        else { ctrl.getConsignorConsigneeDetails(list[index], false); }
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
      isScrollControlled: true,
    );
  }
}
