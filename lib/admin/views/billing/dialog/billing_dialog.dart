import 'package:agus/admin/models/billing_members_models.dart';
import 'package:agus/admin/models/flat_rate_model.dart';
import 'package:agus/admin/models/unsettle_bills.dart';
import 'package:agus/admin/views/billing/dialog/print_test.dart';
import 'package:agus/constants/constant.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../helpers/date_to_word.dart';
import '../../../../utils/custom_menu_button.dart';

class BillingPDialog extends StatefulWidget {
  final String billingID;
  final String memberID;
  final String name;
  final String billingPrice;
  final String billYear;
  final String billMonth;
  final String memID;
  final String areaID;
  final String connID;
  final String balance;
  final String dateBill;
  final String dueDateBalance;
  @override
  _BillingPDialog createState() => _BillingPDialog();

  const BillingPDialog(
      {Key? key,
      required this.billingID,
      required this.memberID,
      required this.name,
      required this.billingPrice,
      required this.billYear,
      required this.billMonth,
      required this.memID,
      required this.areaID,
      required this.connID,
      required this.balance,
      required this.dateBill,
      required this.dueDateBalance})
      : super(key: key);
}

class _BillingPDialog extends State<BillingPDialog> {
  String billingIDMo = '';
  double change = 00;
  double billAmount = 00;
  double balance = 00;
  String monthBilling = '';
  String yearBilling = '';
  TextEditingController paymentController = TextEditingController();
  String dueBalance = '';
  String balancewithpercent = '';
  DateTime dueDate = DateTime.now();
  String finalBill = '';
  double balPercent = 0;
  double totalPercentAday = 0;

  @override
  void initState() {
    super.initState();
    paymentController.text = '';
    billingIDMo = widget.memberID;
    monthBilling = widget.billMonth;
    yearBilling = widget.billYear;
    computeBill();
  }

  computeBill() {
    dueDate = DateTime.parse(widget.dueDateBalance).add(const Duration(days: 9));
    final difference = DateTime.now().difference(dueDate).inDays;

    print(difference);
    
    dueBalance = dueDate.toString();
    balPercent = double.parse(widget.balance) * 0.02;
    totalPercentAday = balPercent * (difference);
    if(difference < 0){
      totalPercentAday = 0;
    }

    balancewithpercent =
        (totalPercentAday + double.parse(widget.balance)).toStringAsFixed(2);
    finalBill =
        (double.parse(balancewithpercent) + double.parse(widget.billingPrice))
            .toStringAsFixed(2);


  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          width: 600,
          height: 400,
          child: Stack(
            children: [
              Column(
                children: [
                  Text(
                    'Billing $monthBilling $yearBilling',
                    style: BluekTextStyleHeadline2,
                  ),
                  const SizedBox(height: 15),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'Name: ${widget.name}',
                            style: kTextStyleHeadline2Dark,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Billing details',
                            style: kTextStyleHeadline2Dark,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Billing for $monthBilling $yearBilling',
                            style: kTextStyleHeadline2Dark,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Bill:',
                                style: kTextStyleHeadline5,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Spacer(),
                              Text(
                                "₱ ${widget.billingPrice}",
                                style: kTextStyleHeadline5,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Balance bill (2%):',
                                style: kTextStyleHeadline5,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Spacer(),
                              Text(
                                '₱ $balancewithpercent',
                                style: kTextStyleHeadline5,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Due Date Balance:',
                                style: kTextStyleHeadline2Dark,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Spacer(),
                              Text(
                                '${stringDateToWord(DateFormat('yyyy-MM-dd')
                                    .format(dueDate)
                                    .toString())}  ₱ ${totalPercentAday.toStringAsFixed(2)}',
                                style: kTextStyleHeadline2Dark,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Total:',
                                style: kTextStyleHeadline5,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Spacer(),
                              Text(
                                '₱ ${finalBill}',
                                style: kTextStyleHeadline5,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                           Text(
                        'Please pay bill on or before due date: ${stringDateToWord(DateTime.now().toString())}',
                        style: kTextStyleHeadline1,
                      ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                 
                ],
              ),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: MenuButton(
                            isSelect: false,
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            text: 'Cancel',
                            elevation: 0,
                            textSize: 14,
                            padding: const EdgeInsets.fromLTRB(5, 0, 10, 0)),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 1,
                        child: MenuButton(
                            isSelect: true,
                            onPressed: () async {
                              await updateBillingToBill(widget.memberID);
                              // await showDialog<bool>(
                              //   context: context,
                              //   builder: (context) => PrintTest(),
                              // );
                              Navigator.of(context).pop();
                            },
                            text: 'Bill Now',
                            elevation: 0,
                            textSize: 14,
                            padding: const EdgeInsets.fromLTRB(5, 0, 10, 0)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 
  Future<void> updateBillingToBill(String memberIdBill) async {
    FirebaseFirestore.instance
        .collection('membersBilling')
        .doc(memberIdBill)
        .update({'toBill': true, 'dateBill': DateTime.now(),'totalBill': double.parse(finalBill),'balancePercent':balancewithpercent}).then((value) {});
  }

  getCustomFormattedDateTime(String givenDateTime, String dateFormat) {
    // dateFormat = 'MM/dd/yy';
    final DateTime docDateTime = DateTime.parse(givenDateTime);
    return DateFormat(dateFormat).format(docDateTime);
  }

  Future<void> closeOldBill(String docID) async {
    FirebaseFirestore.instance.collection('billing').doc(docID).update({
      'status': 'close',
    }).then((value) {});
  }

  Future<void> payNormal(String billID) async {
    FirebaseFirestore.instance.collection('membersBilling').doc(billID).update({
      'status': 'paid',
      'balance': 0,
    }).then((value) {
      addPaymentHistory(billID);
    });
  }

  Future<void> payWithBalance(String billID) async {
    FirebaseFirestore.instance
        .collection('membersBilling')
        .doc(billID)
        .update({'status': 'unpaid', 'balance': balance}).then((value) {
      addPaymentHistory(billID);
    });
  }

  Future<void> addPaymentHistory(String billID) async {
    FirebaseFirestore.instance
        .collection('membersBilling')
        .doc(billID)
        .collection('payment')
        .add({
      'bill': finalBill,
      'amount': paymentController.text,
      'balance': balance,
      'change': change,
      'date': DateTime.now(),
      'user': 'admin',

    }).then((value) {
      setState(() {
        balance = 00;
        billAmount = 00;
        change = 00;
      });
    });
  }
}
