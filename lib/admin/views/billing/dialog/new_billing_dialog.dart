import 'package:agus/admin/models/flat_rate_model.dart';
import 'package:agus/constants/constant.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../utils/custom_menu_button.dart';

class NewBillingDialog extends StatefulWidget {
  @override
  _NewBillingDialog createState() => _NewBillingDialog();

  const NewBillingDialog({
    Key? key,
  }) : super(key: key);
}

class _NewBillingDialog extends State<NewBillingDialog> {
  String value = '';

  String selectedValue = "January";
  String selectedValueYear = "2022";

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(value: "January", child: const Text("January")),
      DropdownMenuItem(value: "February", child: const Text("February")),
      DropdownMenuItem(value: "March", child: const Text("March")),
      DropdownMenuItem(value: "April", child: const Text("April")),
      DropdownMenuItem(value: "May", child: const Text("May")),
      DropdownMenuItem(value: "June", child: const Text("June")),
      DropdownMenuItem(value: "July", child: const Text("July")),
      DropdownMenuItem(value: "August", child: const Text("August")),
      DropdownMenuItem(value: "September", child: const Text("September")),
      DropdownMenuItem(value: "October", child: const Text("October")),
      DropdownMenuItem(value: "November", child: const Text("November")),
      DropdownMenuItem(value: "December", child: const Text("December")),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownItemsYear {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(value: "2022", child: const Text("2022")),
      DropdownMenuItem(value: "2023", child: const Text("2023")),
      DropdownMenuItem(value: "2024", child: const Text("2024")),
      DropdownMenuItem(value: "2025", child: const Text("2025")),
      DropdownMenuItem(value: "2026", child: const Text("2026")),
      DropdownMenuItem(value: "2027", child: const Text("2028")),
      DropdownMenuItem(value: "2029", child: const Text("2029")),
      DropdownMenuItem(value: "2030", child: const Text("2030")),
    ];
    return menuItems;
  }

  @override
  void initState() {
    // TODO: implement initState
    var mo = DateTime.now().month;
    if (mo == 1) {
      selectedValue = "January";
    } else if (mo == 2) {
      selectedValue = "February";
    } else if (mo == 3) {
      selectedValue = "March";
    } else if (mo == 4) {
      selectedValue = "April";
    } else if (mo == 5) {
      selectedValue = "May";
    } else if (mo == 6) {
      selectedValue = "June";
    } else if (mo == 7) {
      selectedValue = "July";
    } else if (mo == 8) {
      selectedValue = "August";
    } else if (mo == 9) {
      selectedValue = "September";
    } else if (mo == 10) {
      selectedValue = "October";
    } else if (mo == 11) {
      selectedValue = "November";
    } else if (mo == 12) {
      selectedValue = "December";
    }
    selectedValueYear = DateTime.now().year.toString();
    super.initState();
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
          width: 500,
          height: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Piwas',
                style: BluekTextStyleHeadline1,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 2, 20, 0),
                        child: Row(
                          children: [
                            Text(
                              'Month',
                              style: kTextStyleHeadline2Dark,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            DropdownButton(
                              underline: SizedBox(),
                              style: kTextStyleHeadline2Dark,
                              focusColor: Colors.transparent,
                              value: selectedValue,
                              items: dropdownItems,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedValue = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 2, 20, 0),
                        child: Row(
                          children: [
                            Text(
                              'Year',
                              style: kTextStyleHeadline2Dark,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            DropdownButton(
                              underline: SizedBox(),
                              style: kTextStyleHeadline2Dark,
                              focusColor: Colors.transparent,
                              value: selectedValueYear,
                              items: dropdownItemsYear,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedValueYear = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.pink.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text(
                        'Note: ',
                        style: kTextStyleHeadline2Dark,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Creating new billing automatically current billing for the moth will automatically close  We advice to resolve previous month bill first before proceeding, it might cause an Issue to your latest billing. Other wise please continue your new billing',
                        style: kTextStyleHeadline2Dark,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text(
                        'You may contact us for further information, message us using our help page or contact provided below: ',
                        style: kTextStyleHeadline1,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Call us: 0938 514 3902 - 02(002-1202) \nEmail: agus@agusph.app',
                        style: kTextStyleHeadline1,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
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
                          isSelect: true,
                          onPressed: () async{
                            await getTotalBill(selectedValue,selectedValueYear);
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context, true);
                          },
                          text: 'Continue',
                          elevation: 0,
                          textSize: 14,
                          padding: const EdgeInsets.fromLTRB(5, 0, 10, 0)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 
  getTotalBill(String billMonth, String billYear) async {
    String prevBillId = '';
    await FirebaseFirestore.instance
        .collection('billing')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                if (doc['status'].toString() == 'open') {
                  prevBillId = doc.id.toString();
                }
              })
            });

   await createBilling(billMonth, billYear, prevBillId);
  }

  Future<void> createBilling(
      String billMonth, String billYear, String prevBillId) async {
    FirebaseFirestore.instance.collection('billing').add(
        {'month': billMonth, 'year': billYear, 'status': 'open', 'date':DateTime.now(), 'user': 'admin'}).then((value) async{
        await getPrevBill(value.id, prevBillId);
    });
  }

  Future<void> getPrevBill(String currentbillId, String prevBillId) async {
    await FirebaseFirestore.instance
        .collection('membersBilling').where('billingId', isEqualTo: prevBillId)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                String areaId = doc['areaId'];
                String connectionId = doc['connectionId'];
                double currentReading = 0;
                if (doc['currentReading'] <= 0) {
                  currentReading = doc['previousReading'];
                } else {
                  currentReading = doc['currentReading'];
                }
                String flatRate = doc['flatRate'];
                double flatRatePrice = doc['flatRatePrice'];
                String memberId = doc['memberId'];
                String name = doc['name'];
                double totalBalance = doc['balance'];
                DateTime dueBalance = (doc['dateBill'] as Timestamp).toDate();
                await copyPrevBillToLatest(currentbillId, areaId, connectionId,
                    currentReading, flatRate, flatRatePrice, memberId, name,dueBalance,totalBalance);
              })
            });
    await closeOldBill(prevBillId);
  }

  Future<void> copyPrevBillToLatest(
    String currentbillId,
    String areaId,
    String connectionId,
    double currentReading,
    String flatRate,
    double flatRatePrice,
    String memberId,
    String name,
    DateTime dueDateBalance,
    double totalBalance
  ) async {

    
    FirebaseFirestore.instance
        .collection('membersBilling')
        .add({
      'billingId': currentbillId,
      'totalCubic': 0,
      'toBill': false,
      'status': 'unpaid',
      'balance': totalBalance,
      'billingPrice': 0,
      'connectionId': connectionId,
      'previousReading': currentReading,
      'currentReading': 0,
      'dateRead': DateTime.now(),
      'flatRate': '',
      'flatRatePrice': 0,
      'memberId': memberId,
      'name': name,
      'areaId': areaId,
      'month': selectedValue,
      'year': selectedValueYear,
      'dueDateBalance': dueDateBalance,
      'dateBill': DateTime.now(),
    }).then((value) {});
  }

  getCustomFormattedDateTime(String givenDateTime, String dateFormat) {
    // dateFormat = 'MM/dd/yy';
    final DateTime docDateTime = DateTime.parse(givenDateTime);
    return DateFormat(dateFormat).format(docDateTime);
  }

  Future<void> closeOldBill(
      String docID) async {
      FirebaseFirestore.instance
          .collection('billing')
          .doc(docID)
          .update({
        'status': 'close',
      }).then((value) {

      });
    
  }
}
