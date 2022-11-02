import 'package:agus/admin/models/flat_rate_model.dart';
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
      required this.connID})
      : super(key: key);
}

class _BillingPayDialog extends State<BillingPayDialog> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.memID);
    print(widget.areaID);
    print(widget.connID);
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
                'Bill for ${widget.billMonth} ${widget.billYear}' ,
                style: kTextStyleHeadline2Dark,
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
                          onPressed: () async {
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

  Future<List<FlatRate>> getFlat() async {
    List<FlatRate> flatRate = [];

    await FirebaseFirestore.instance
        .collection('billing')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                debugPrint(doc.id);
                FlatRate area = FlatRate(
                  doc.id,
                  doc['description'],
                  doc['price'].toString(),
                );

                flatRate.add(area);
              })
            });
    return flatRate;
  }

  Widget flatRateList(BuildContext context) {
    return FutureBuilder(
        future: getFlat(),
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
                    Text('No flat rate found.'),
                  ],
                ),
              );
            } else {
              return SizedBox(
                width: 200,
                height: 200,
                child: ListView.builder(
                    //shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {});
                            },
                            child: Card(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 2, 20, 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: SizedBox(
                                        height: 40,
                                        child: Center(
                                          child: Text(
                                            snapshot.data[index].price,
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
    FirebaseFirestore.instance.collection('billing').add({
      'month': billMonth,
      'year': billYear,
      'status': 'open',
      'date': DateTime.now(),
      'user': 'admin'
    }).then((value) async {
      await getPrevBill(value.id, prevBillId);
    });
  }

  Future<void> getPrevBill(String currentbillId, String prevBillId) async {
    await FirebaseFirestore.instance
        .collection('billing')
        .doc(prevBillId)
        .collection('members')
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
                await copyPrevBillToLatest(currentbillId, areaId, connectionId,
                    currentReading, flatRate, flatRatePrice, memberId, name);
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
  ) async {
    FirebaseFirestore.instance
        .collection('billing')
        .doc(currentbillId)
        .collection('members')
        .add({
      'totalCubic': 0,
      'toBill': false,
      'status': 'unpaid',
      'balance': 0,
      'billingPrice': 0,
      'connectionId': connectionId,
      'previousReading': currentReading,
      'currentReading': 0,
      'dateRead': DateTime.now(),
      'flatRate': flatRate,
      'flatRatePrice': flatRatePrice,
      'memberId': memberId,
      'name': name,
      'areaId': areaId
    }).then((value) {});
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
}
