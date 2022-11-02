import 'package:agus/admin/models/billing_members_models.dart';
import 'package:agus/admin/models/flat_rate_model.dart';
import 'package:agus/admin/models/unsettle_bills.dart';
import 'package:agus/constants/constant.dart';
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
      required this.balance})
      : super(key: key);
}

class _BillingPayDialog extends State<BillingPayDialog> {
  String billingIDMo = '';
  Future? billing;
  double change = 00;
  double billAmount = 00;
  double balance = 00;
  String monthBilling = '';
  String yearBilling = '';
  List<UnsettledBills> billingMember = [];
  TextEditingController paymentController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paymentController.text = '';
    billing = getUnsettleBilling();
    billingIDMo = widget.memberID;
    monthBilling = widget.billMonth;
    yearBilling = widget.billYear;
    if(double.parse(widget.balance) <= 0){
      billAmount = double.parse(widget.billingPrice);
    }else{
      billAmount = double.parse(widget.balance);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const Text(
                                'Unsettled bills',
                                style: kTextStyleHeadline2Dark,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              unsettleBills(context)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12,
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
                               SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Billing for $monthBilling $yearBilling',
                                style: kTextStyleHeadline2Dark,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Total bill',
                                    style: kTextStyleHeadline5,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Spacer(),
                                  Text(
                                    billAmount.toStringAsFixed(2),
                                    style: kTextStyleHeadline5,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              TextField(
                                controller: paymentController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Amount here...',
                                ),
                                onChanged: (value){
                                    setState(() {
                                      if(double.parse(value) >= billAmount){
                                        change =   double.parse(value) - billAmount;
                                        balance = 00;
                                      }else{
                                        balance =    billAmount - double.parse(value);
                                        change = 00;
                                      }
                                    });
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Change',
                                    style: kTextStyleHeadline5,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Spacer(),
                                  Text(
                                    change.toStringAsFixed(2),
                                    style: kTextStyleHeadline5,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Balance',
                                    style: kTextStyleHeadline5,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Spacer(),
                                  Text(
                                    balance.toStringAsFixed(2),
                                    style: kTextStyleHeadline5,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
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
                            isSelect: balance <= 0 ? true:false,
                            onPressed: () async {
                              if(balance <= 0){
                                payNormal(billingIDMo);
                              }else{
                                payWithBalance(billingIDMo);
                              }
                              // Navigator.pop(context, true);
                            },
                            text: balance <= 0 ? 'Pay Now':'Pay w/ Balance',
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

  Future<List<UnsettledBills>> getUnsettleBilling() async {
    billingMember = [];

    await FirebaseFirestore.instance
        .collection('membersBilling')
        .where('memberId', isEqualTo: widget.memID)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                UnsettledBills bill = UnsettledBills(
                    doc.id,
                    doc['memberId'].toString(),
                    doc['name'].toString(),
                    doc['areaId'].toString(),
                    doc['connectionId'].toString(),
                    doc['previousReading'],
                    doc['currentReading'],
                    doc['dateRead'].toString(),
                    doc['totalCubic'],
                    doc['billingPrice'],
                    doc['flatRate'].toString(),
                    doc['flatRatePrice'],
                    doc['status'].toString(),
                    doc['toBill'],
                    doc['balance'],
                    doc['month'],
                    doc['year']);

                billingMember.add(bill);
              })
            });
    return billingMember;
  }

  Widget unsettleBills(BuildContext context) {
    return FutureBuilder(
        future: billing,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.length <= 0) {
              // ignore: avoid_unnecessary_containers
              return Center(
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Icon(
                      Icons.folder_outlined,
                      color: kColorDarkBlue,
                      size: 70,
                    ),
                    Text('No data found.'),
                  ],
                ),
              );
            } else {
              return SizedBox(
                height: 400,
                child: ListView.builder(
                    //shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if(snapshot.data[index].balance > 0){
                                  billAmount = snapshot.data[index].balance;
                                  billingIDMo = snapshot.data[index].id;
                                    monthBilling = snapshot.data[index].billMonth;
                                  yearBilling = snapshot.data[index].billYear;
                                }else{
                                  billAmount = snapshot.data[index].billingPrice;
                                  billingIDMo = snapshot.data[index].id;
                                  monthBilling = snapshot.data[index].billMonth;
                                  yearBilling = snapshot.data[index].billYear;
                                }
                              });
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: SizedBox(
                                        height: 40,
                                        child: Center(
                                          child: Text(
                                            snapshot.data[index].billMonth +
                                                ' ' +
                                                snapshot.data[index].billYear,
                                            style: kTextStyleHeadline2Dark,
                                          ),
                                        
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Expanded(
                                      flex: 2,
                                      child: SizedBox(
                                        height: 40,
                                        child: Center(
                                          child: Text(snapshot.data[index].balance <= 0 ? 
                                            'Php ${snapshot.data[index].billingPrice.toStringAsFixed(2)}':'Php ${snapshot.data[index].balance.toStringAsFixed(2)}',
                                            style: kTextStyleHeadline2Dark,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              );
            }
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: Text('loading.'),
                ),
              ],
            );
          }
        });
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

  Future<void> payNormal(
      String billID) async {
      FirebaseFirestore.instance
          .collection('membersBilling')
          .doc(billID)
          .update({
        'status': 'paid',
        'balance': 0,
      }).then((value) {
        addPaymentHistory(billID);
      });
  }

  Future<void> payWithBalance(
      String billID) async {
      FirebaseFirestore.instance
          .collection('membersBilling')
          .doc(billID)
          .update({
        'status': 'unpaid',
        'balance': balance
      }).then((value) {
        addPaymentHistory(billID);
      });
  }

  Future<void> addPaymentHistory(
      String billID) async {
    FirebaseFirestore.instance.collection('membersBilling').doc(billID).collection('payment').add(
        {
        'bill': billAmount,
        'amount': paymentController.text, 
        'balance': balance, 
        'change': change,
         'date':DateTime.now(),
          'user': 'admin'
          
      }).then((value) {
        
        setState(() {
          billing = getUnsettleBilling();
          balance = 00;
          billAmount = 00;
          change = 00;
        });
    });
  }
}
