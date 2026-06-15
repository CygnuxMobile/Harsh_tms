import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:harsh/widgets/app_size.dart';
import 'package:harsh/widgets/tms_button.dart';
import 'package:harsh/widgets/tms_normaltext.dart';
import 'package:intl/intl.dart';
import '../../../model/expenses_model/expenses_list_model.dart';
import '../../../utils/pref.dart';
import '../../../widgets/custom_dropdown_search.dart';
import '../../../widgets/dashboard_widgets/custom_drawer.dart';
import '../expenses_controller.dart';

enum ExpensesScreenEnum { none, advance, fuel }

class ExpensesAdd extends StatefulWidget {
  ExpensesAdd({key, required this.expensesList});

  final ExpensesList expensesList;

  @override
  State<ExpensesAdd> createState() => _ExpensesAddState();
}

class _ExpensesAddState extends State<ExpensesAdd> {
  ExpensesController expensesController = Get.find<ExpensesController>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    expensesController.advanceDataController.text = DateFormat('d MMM yyyy').format(DateTime.now());
    expensesController.chequeDateController.text = DateFormat('d MMM yy').format(DateTime.now());
    expensesController.selectedBranch.value = Pref().getBaseLocation();
  }

  @override
  void dispose() {
    expensesController.advancePlaceController.clear();
    expensesController.amountController.clear();
    expensesController.remarkController.clear();
    expensesController.selectedBranch.value = '';
    expensesController.selectedPaymentMode.value = '';
    expensesController.selectedBankAccount.value = '';
    expensesController.bankPaymentType.value = 'Cheque No.';
    expensesController.chequeNoController.clear();
    expensesController.rtgsNeftNoController.clear();
    expensesController.bankRemarkController.clear();
    expensesController.selectedCashAccount.value = '';
    expensesController.selectedCardNo.value = '';
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    expensesController.advanceDataController.text = DateFormat('d MMM yyyy').format(DateTime.now());
    expensesController.chequeDateController.text = DateFormat('d MMM yy').format(DateTime.now());
    expensesController.selectedBranch.value = Pref().getBaseLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            expensesController.expensesScreenEnum == ExpensesScreenEnum.advance ? 'Advance Slip Entry' : 'Fuel Card Entry',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff232F34),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: expensesController.advancePlaceController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Advance place',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter advance place';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                        readOnly: true,
                        controller: expensesController.advanceDataController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Advance date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            expensesController.advanceDataController.text = DateFormat('d MMM yyyy').format(pickedDate);
                          }
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownSearch<String>(
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                      ),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '  Select Location ',
                          labelText: 'Branch',
                        ),
                      ),
                      selectedItem: expensesController.selectedBranch.isEmpty ? '  Select Location ' : expensesController.selectedBranch.value,
                      items: expensesController.branchList.map((element) => element.locCode).toList(),
                      onChanged: (value) async {
                        expensesController.selectedBranch.value = value!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty || value == '  Select Location ') {
                          return 'Please select a branch';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: expensesController.amountController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Amount',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter amount';
                        }
                        return null;
                      },
                    ),
                  ),
                  expensesController.expensesScreenEnum == ExpensesScreenEnum.fuel
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: expensesController.fuelTimeQtyLtrController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Qty Ltr',
                            ),
                          ),
                        )
                      : SizedBox(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      enabled: false,
                      controller: TextEditingController(text: Pref().getUserId()),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Advance paid by',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: expensesController.remarkController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Remark',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TmsText(
                      text: "Payment Details",
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownSearch<String>(
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                      ),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '  Payment Mode ',
                          labelText: 'Payment Mode',
                        ),
                      ),
                      selectedItem:
                          expensesController.selectedPaymentMode.isEmpty ? '  Select Payment Option ' : expensesController.selectedPaymentMode.value,
                      items: expensesController.expensesScreenEnum == ExpensesScreenEnum.advance
                          ? expensesController.paymentMode.where((element) => element.codeId != "FUELCARD").map((element) => element.codeId).toList()
                          : expensesController.paymentMode.where((element) => element.codeId == "FUELCARD").map((element) => element.codeId).toList(),
                      onChanged: (value) async {
                        if (expensesController.selectedPaymentMode.value != value) {
                          expensesController.selectedBankAccount.value = '';
                          expensesController.bankPaymentType.value = 'Cheque No.';
                          expensesController.chequeNoController.clear();
                          expensesController.rtgsNeftNoController.clear();
                          expensesController.bankRemarkController.clear();
                          expensesController.selectedCashAccount.value = '';
                          expensesController.selectedCardNo.value = '';
                          expensesController.selectedAdvCode.value = '';
                          expensesController.selectedPaymentMode.value = value!;
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty || value == '  Select Payment Option ') {
                          return 'Please select a payment mode';
                        }
                        return null;
                      },
                    ),
                  ),
                  Obx(
                    () => expensesController.selectedPaymentMode.value == 'BANK'
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                                readOnly: true,
                                controller: expensesController.chequeDateController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Cheque date',
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101),
                                  );
                                  if (pickedDate != null) {
                                    expensesController.chequeDateController.text = DateFormat('d MMM yy').format(pickedDate);
                                  }
                                }),
                          )
                        : const SizedBox(),
                  ),
                  Obx(
                    () => expensesController.selectedPaymentMode.value == 'BANK'
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownSearch<String>(
                              popupProps: PopupProps.menu(
                                showSearchBox: true,
                              ),
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '  Select Bank Account ',
                                  labelText: 'Bank Account',
                                ),
                              ),
                              selectedItem: expensesController.selectedBankAccount.isEmpty
                                  ? '  Select Bank Account '
                                  : expensesController.selectedBankAccount.value,
                              items: expensesController.bankAccountList.map((element) => element.codeDesc).toList(),
                              onChanged: (value) async {
                                expensesController.selectedBankAccount.value = value!;
                                expensesController.selectedAdvCode.value =
                                    expensesController.bankAccountList.where((element) => element.codeDesc == value).first.codeId;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty || value == '  Select Bank Account ') {
                                  return 'Please select a bank account';
                                }
                                return null;
                              },
                            ),
                          )
                        : const SizedBox(),
                  ),
                  Obx(
                    () => expensesController.selectedPaymentMode.value == 'BANK'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Radio<String>(
                                value: 'Cheque No.',
                                groupValue: expensesController.bankPaymentType.value,
                                onChanged: (String? value) {
                                  expensesController.bankPaymentType.value = value!;
                                },
                              ),
                              const Text('Cheque No.'),
                              Radio<String>(
                                value: 'RTGS/NEFT No.',
                                groupValue: expensesController.bankPaymentType.value,
                                onChanged: (String? value) {
                                  expensesController.bankPaymentType.value = value!;
                                },
                              ),
                              const Text('RTGS/NEFT No.'),
                            ],
                          )
                        : const SizedBox(),
                  ),
                  Obx(() {
                    if (expensesController.selectedPaymentMode.value == 'BANK') {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          maxLength: 10,
                          controller: expensesController.bankPaymentType.value == 'Cheque No.'
                              ? expensesController.chequeNoController
                              : expensesController.rtgsNeftNoController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: expensesController.bankPaymentType.value,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter ${expensesController.bankPaymentType.value}';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
                  Obx(
                    () => expensesController.selectedPaymentMode.value == 'BANK'
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: expensesController.bankRemarkController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Remark',
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ),
                  Obx(
                    () => expensesController.selectedPaymentMode.value == 'CASH'
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownSearch<String>(
                              popupProps: PopupProps.menu(
                                showSearchBox: true,
                              ),
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '  Select Cash Account ',
                                  labelText: 'Cash Account',
                                ),
                              ),
                              selectedItem: expensesController.selectedCashAccount.isEmpty
                                  ? '  Select Cash Account '
                                  : expensesController.selectedCashAccount.value,
                              items: expensesController.cashAccountList.map((element) => element.codeDesc).toList(),
                              onChanged: (value) async {
                                expensesController.selectedCashAccount.value = value!;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty || value == '  Select Cash Account ') {
                                  return 'Please select a cash account';
                                }
                                return null;
                              },
                            ),
                          )
                        : const SizedBox(),
                  ),
                  Obx(
                    () => expensesController.selectedPaymentMode.value == 'ATM' || expensesController.selectedPaymentMode.value == 'FUELCARD'
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownSearch<String>(
                              popupProps: PopupProps.menu(
                                showSearchBox: true,
                              ),
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '  Select Card No  ',
                                  labelText: 'Card No',
                                ),
                              ),
                              selectedItem:
                                  expensesController.selectedCardNo.isEmpty ? '  Select Card No  ' : expensesController.selectedCardNo.value,
                              items: expensesController.cardNumberList.map((element) => element.codeDesc).toList(),
                              onChanged: (value) async {
                                expensesController.selectedCardNo.value = value!;
                                expensesController.selectedAdvCode.value =
                                    expensesController.cardNumberList.where((element) => element.codeDesc == value).first.codeId;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty || value == '  Select Card No  ') {
                                  return 'Please select a card number';
                                }
                                return null;
                              },
                            ),
                          )
                        : const SizedBox(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TmsButton(
                      size: Size(AppSize.size(context).width, AppSize.size(context).height * 0.060),
                      text: "Submit",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          expensesController.expensesSubmitApi(
                            vSlipNo: widget.expensesList.vSlipNo,
                            advLoc: expensesController.advancePlaceController.text,
                            advDate: expensesController.advanceDataController.text,
                            branchCode: expensesController.selectedBranch.value,
                            advAmt: expensesController.amountController.text,
                            qtyInLtr: expensesController.fuelTimeQtyLtrController.text.isNotEmpty
                                ? int.parse(expensesController.fuelTimeQtyLtrController.text)
                                : 0,
                            advAcccode: expensesController.selectedAdvCode.value,
                            chequeDate: expensesController.chequeDateController.text,
                            chequeNo: expensesController.bankPaymentType.value == 'Cheque No.'
                                ? expensesController.chequeNoController.text
                                : expensesController.rtgsNeftNoController.text,
                            paymentMode: expensesController.selectedPaymentMode.value,
                            remarks: expensesController.remarkController.text,
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
