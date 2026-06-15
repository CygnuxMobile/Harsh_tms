import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harsh/moduls/expenses_page/expenses_controller.dart';
import 'package:harsh/moduls/expenses_page/sub_screen/expenses_add.dart';
import 'package:harsh/moduls/pod_page/pod_controller.dart';
import 'package:harsh/widgets/tms_button.dart';
import 'package:intl/intl.dart';

class ExpensesScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  const ExpensesScreen({key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  ExpensesController expensesController = Get.put(ExpensesController());

  @override
  void initState() {
    // TODO: implement initState
    expensesController.locationMasterDataApi();
    expensesController.expensesListApi();
    expensesController.paymentModeApi();
    expensesController.bankDetailsApi();
    expensesController.cashAccountApi();
    expensesController.cardNumberApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  _showFilterBottomSheet(context);
                },
                icon: const Icon(
                  Icons.filter_list,
                ),
              ),
            )
          ],
          title: const Text(
            'Expenses',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff232F34),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: SafeArea(
          child: () {
            switch (expensesController.expensesStatus.value) {
              case ApiStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case ApiStatus.error:
                return const Center(child: Text("Something went wrong"));
              case ApiStatus.success:
                if (expensesController.expensesList.isEmpty) {
                  return const Center(child: Text("No Expenses Found"));
                }
                return ListView.builder(
                  itemCount: expensesController.expensesList.length,
                  itemBuilder: (context, index) {
                    final expense = expensesController.expensesList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(expense.vSlipNo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  Text(expense.vSlipDt, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                ],
                              ),
                              const Divider(),
                              _buildInfoRow('Vehicle No : ', expense.vehicleNo),
                              const SizedBox(height: 4),
                              _buildInfoRow('Driver : ', expense.driverName),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        expensesController.expensesScreenEnum = ExpensesScreenEnum.advance;
                                        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${expensesController.expensesScreenEnum}");
                                        Get.to(() => ExpensesAdd(
                                              expensesList: expense,
                                            ));
                                      },
                                      icon: const Icon(
                                        Icons.money,
                                        color: Color(0xff232F34),
                                      ),
                                      label: const Text('Advance'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(0xff232F34),
                                        side: const BorderSide(color: Color(0xff232F34)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        expensesController.expensesScreenEnum = ExpensesScreenEnum.fuel;
                                        print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<${expensesController.expensesScreenEnum}");
                                        Get.to(() => ExpensesAdd(
                                              expensesList: expense,
                                            ));
                                      },
                                      icon: const Icon(
                                        Icons.local_gas_station,
                                        color: Color(0xff232F34),
                                      ),
                                      label: const Text('FuelCard'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(0xff232F34),
                                        side: const BorderSide(color: Color(0xff232F34)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              default:
                return const SizedBox();
            }
          }(),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black54)),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(child: Text(value, style: const TextStyle(color: Colors.black87))),
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
                    controller: expensesController.tripSheetNoController,
                    decoration: const InputDecoration(
                      labelText: 'Trip Sheet No.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: expensesController.vehicleNumberController,
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
                          controller: expensesController.fromDateController,
                          decoration: const InputDecoration(
                            labelText: 'From Date',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () {
                            _selectDate(context, expensesController.fromDateController);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: expensesController.toDateController,
                          decoration: const InputDecoration(
                            labelText: 'To Date',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () {
                            _selectDate(context, expensesController.toDateController);
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
                            expensesController.tripSheetNoController.clear();
                            expensesController.vehicleNumberController.clear();
                            Navigator.pop(context);
                          },
                          text: 'Clear',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TmsButton(
                          onPressed: () {
                            expensesController.expensesListApi();
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
