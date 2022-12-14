import 'package:agus/admin/models/billing_members_models.dart';
import 'package:agus/admin/models/flat_rate_model.dart';
import 'package:agus/admin/models/unsettle_bills.dart';
import 'package:agus/constants/constant.dart';
import 'package:agus/helpers/date_to_word.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../utils/custom_menu_button.dart';

class BillingPayDialog extends StatefulWidget {
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
  _BillingPayDialog createState() => _BillingPayDialog();

  const BillingPayDialog(
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

class _BillingPayDialog extends State<BillingPayDialog> {
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
  DateTime billDueDate = DateTime.now();
  String finalBill = '';
  double totalPercentAday = 0;
  double billPercentAday = 0;

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
    dueDate =
        DateTime.parse(widget.dueDateBalance).add(const Duration(days: 9));
    print(dueDate);
    final difference = DateTime.now().difference(dueDate).inDays;

    dueBalance = dueDate.toString();
    double balPercent = double.parse(widget.balance) * 0.02;
    totalPercentAday = balPercent * (difference);
    if (difference < 0) {
      totalPercentAday = 0;
    }

    balancewithpercent =
        (totalPercentAday + double.parse(widget.balance)).toStringAsFixed(2);

    

    billDueDate = DateTime.parse(widget.dateBill).add(const Duration(days: 9));
    final finalBillDiff = DateTime.now().difference(billDueDate).inDays;

    print(finalBillDiff);
    double tmpBill =
          (double.parse(balancewithpercent) + double.parse(widget.billingPrice));
    if (finalBillDiff <= 0) {
      finalBill =
          (double.parse(balancewithpercent) + double.parse(widget.billingPrice))
              .toStringAsFixed(2);
    } else {
      double billPercent = tmpBill * 0.02;
      billPercentAday = billPercent * (finalBillDiff);
      finalBill = 
        (tmpBill +
              billPercentAday)
          .toStringAsFixed(2);
    }
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
          height: 600,
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
                                '??? ${widget.billingPrice}',
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
                                '??? $balancewithpercent',
                                style: kTextStyleHeadline5,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Text(
                                'Due Date Balance:  ${stringDateToWord(widget.dueDateBalance.toString())}',
                                style: kTextStyleHeadline2Dark,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Spacer(),
                              Text(
                                '??? ${totalPercentAday.toStringAsFixed(2)}',
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
                                finalBill,
                                style: kTextStyleHeadline5,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Text(
                                'Bill Due Date:  ${stringDateToWord(widget.dateBill.toString())} ',
                                style: kTextStyleHeadline2Dark,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Spacer(),
                              Text(
                                '??? ${billPercentAday.toStringAsFixed(2)}',
                                style: kTextStyleHeadline2Dark,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 70,
                          ),
                          TextField(
                            textAlign: TextAlign.end,
                            controller: paymentController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Amount here...',
                            ),
                            onChanged: (value) {
                              setState(() {
                                if (double.parse(value) >=
                                    double.parse(finalBill)) {
                                  change = double.parse(value) -
                                      double.parse(finalBill);
                                  balance = 00;
                                } else {
                                  balance = double.parse(finalBill) -
                                      double.parse(value);
                                  change = 00;
                                }
                              });
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Change',
                                style: kTextStyleHeadline5,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Spacer(),
                              Text(
                                '??? ${change.toStringAsFixed(2)}',
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
                                'Balance',
                                style: kTextStyleHeadline5,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Spacer(),
                              Text(
                                '??? ${balance.toStringAsFixed(2)}',
                                style: kTextStyleHeadline5,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
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
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 1,
                        child: MenuButton(
                            isSelect: balance <= 0 ? true : false,
                            onPressed: () async {
                              if (balance <= 0) {
                                payNormal(billingIDMo);
                              } else {
                                payWithBalance(billingIDMo);
                              }
                              Navigator.pop(context, true);
                            },
                            text: balance <= 0 ? 'Pay Now' : 'Pay w/ Balance',
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
      'billingPrice': 0,
      'origBill': double.parse(widget.billingPrice)
    }).then((value) {
      addPaymentHistory(billID);
    });
  }

  Future<void> payWithBalance(String billID) async {
    FirebaseFirestore.instance.collection('membersBilling').doc(billID).update({
      'status': 'unpaid',
      'balance': balance,
      'billingPrice': 0,
      'origBill': double.parse(widget.billingPrice)
    }).then((value) {
      addPaymentHistory(billID);
    });
  }

  Future<void> addPaymentHistory(String billID) async {
    FirebaseFirestore.instance
        .collection('membersBilling')
        .doc(billID)
        .collection('payment')
        .add({
      'bill': billAmount,
      'amount': paymentController.text,
      'balance': balance,
      'change': change,
      'date': DateTime.now(),
      'user': 'admin'
    }).then((value) {
      setState(() {
        balance = 00;
        billAmount = 00;
        change = 00;
      });
    });
  }
}
