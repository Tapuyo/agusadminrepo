import 'package:agus/admin/models/area_models.dart';
import 'package:agus/admin/models/billing_members_models.dart';
import 'package:agus/admin/views/billing/dialog/flat_rate_dialog.dart';
import 'package:agus/admin/views/billing/print/billing_print.dart';
import 'package:agus/constants/constant.dart';
import 'package:agus/utils/custom_icon_button.dart';
import 'package:agus/utils/custom_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BillingContentPage extends HookWidget {
  final String docID;
  const BillingContentPage({Key? key, required this.docID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lock = useState<bool>(true);
    final fBilling = useState<Future?>(null);
    final billingMember = useState<List<BillingMember>>([]);

    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 100,
          child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconButton(
                          icon: lock.value ? Icons.lock : Icons.lock_open,
                          key: key,
                          onPressed: () {
                            lock.value = !lock.value;
                          },
                          text: lock.value ? 'Unlock ' : 'lock',
                          elevation: 0,
                          textSize: 14,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                      CustomSearch(
                        onChanged: (value) {},
                        text: 'Seach area',
                      ),
                      Spacer(),
                      CustomIconButton(
                          icon: Icons.print,
                          key: key,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BillingPring(
                                        docID: docID,
                                      )),
                            );
                          },
                          text: 'Print ',
                          elevation: 0,
                          textSize: 14,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                      CustomIconButton(
                          icon: Icons.note,
                          key: key,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BillingPring(
                                        docID: docID,
                                      )),
                            );
                          },
                          text: 'Print Bill',
                          elevation: 0,
                          textSize: 14,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        color: Colors.transparent,
                        child: GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Name',
                                    style: kTextStyleHeadline4,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text('Previous ',
                                      style: kTextStyleHeadline4),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text('Current ',
                                      style: kTextStyleHeadline4),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text('Total Cubic',
                                      style: kTextStyleHeadline4),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text('Billing Price',
                                      style: kTextStyleHeadline4),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text('Status',
                                      style: kTextStyleHeadline4),
                                ),
                                Spacer(),
                                Text('Action', style: kTextStyleHeadline4),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider()
                    ],
                  ),
                  billMemberList(context, lock, fBilling, billingMember),
                ],
              )),
        ),
      ),
    );
  }

  Future<List<BillingMember>> getArea() async {
    List<BillingMember> billingMember = [];
    if (docID.isEmpty) {
      return [];
    }

    await FirebaseFirestore.instance
        .collection('billing')
        .doc(docID)
        .collection('members')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                BillingMember bill = BillingMember(
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
                );

                billingMember.add(bill);
              })
            });
    return billingMember;
  }

  Widget billMemberList(BuildContext context, ValueNotifier lock,
      ValueNotifier fBilling, ValueNotifier billingMember) {
    final _controllers = useState<List<TextEditingController>>([]);
    final totalList = useState<List<String>>([]);

    fBilling.value = getArea();

    return FutureBuilder(
        future: fBilling.value,
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
                    Text('No area found.'),
                  ],
                ),
              );
            } else {
              return Expanded(
                child: ListView.builder(
                    //shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      TextEditingController txtctrl =
                          new TextEditingController();
                      txtctrl.text =
                          snapshot.data[index].currentReading.toString();
                      _controllers.value.add(txtctrl);
                      totalList.value
                          .add(snapshot.data[index].totalCubic.toString());
                      //  _controllers[index].value =  snapshot.data[index].currentReading;
                      return Column(
                        children: [
                          Container(
                            color: Colors.transparent,
                            child: GestureDetector(
                              onTap: () {},
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 2, 20, 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        snapshot.data[index].name,
                                        style: kTextStyleHeadline2Dark,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                          snapshot.data[index].previousReading
                                              .toString(),
                                          style: kTextStyleHeadline2Dark),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (!lock.value) {
                                            _updateDialog(
                                                context,
                                                snapshot.data[index].id,
                                                snapshot
                                                    .data[index].currentReading
                                                    .toString(),
                                                snapshot.data[index].name
                                                    .toString(),
                                                fBilling,
                                                snapshot
                                                    .data[index].previousReading
                                                    .toString(),
                                                snapshot.data[index].flatRate,
                                                snapshot
                                                    .data[index].connectionId);
                                          }
                                        },
                                        child: Text(
                                            snapshot.data[index].currentReading
                                                .toString(),
                                            style: kTextStyleHeadlineClickable),
                                      ),
                                    ),

                                    //  Expanded(
                                    //   flex: 2,
                                    //   child: lock.value ? Text(
                                    //       _controllers.value[index].text.toString(),
                                    //       style: kTextStyleHeadline2Dark):SizedBox(
                                    //         width: 10,
                                    //         child: TextField(
                                    //           controller: _controllers.value[index],
                                    //           onChanged: (value) {
                                    //             _controllers.value[index].text == value;
                                    //             double newTotal = double.parse(value) - (double.parse(snapshot.data[index].previousReading.toString()));
                                    //             totalList.value[index] = newTotal.toStringAsFixed(2);
                                    //             print(totalList.value[index]);
                                    //           },
                                    //         ),
                                    //       ),
                                    // ),
                                    // SizedBox(width: 10,),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                          snapshot.data[index].totalCubic
                                              .toStringAsFixed(2),
                                          style: kTextStyleHeadline2Dark),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (!lock.value) {
                                            _updateFlatRateDialog(
                                                context,
                                                snapshot.data[index].id,
                                                snapshot.data[index].name,
                                                fBilling,
                                                snapshot
                                                    .data[index].flatRatePrice
                                                    .toString(),
                                                snapshot.data[index].memberId);
                                          }
                                        },
                                        child: Text(
                                            'Php ${snapshot.data[index].billingPrice.toStringAsFixed(2)}',
                                            style: kTextStyleHeadlineClickable),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(snapshot.data[index].status,
                                          style: kTextStyleHeadline2Dark),
                                    ),
                                    Spacer(),
                                    IconButton(
                                        onPressed: () {
                                          var args = billingMember;
                                          Navigator.of(context).restorablePush(_modalBuilder, arguments: args.value);

                                        },
                                        icon: Icon(Icons.menu))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider()
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

  void _updateDialog(
      BuildContext context,
      String id,
      String currentReading,
      String name,
      ValueNotifier fBilling,
      String previousReading,
      String flatRate,
      String connectionId) {
    TextEditingController controllers = new TextEditingController();
    controllers.text = currentReading.toString();
    showCupertinoModalPopup<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Update Reading'),
        content: Column(
          children: [
            Text('Update $name current reading'),
            SizedBox(
              height: 8,
            ),
            SizedBox(
              width: 100,
              height: 30,
              child: CupertinoTextField(
                textAlign: TextAlign.center,
                controller: controllers,
                onChanged: (value) {
                  controllers.text == value;
                },
              ),
            ),
          ],
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              double totalCubic = double.parse(controllers.text) -
                  double.parse(previousReading);
              updateReadingMember(id, controllers.text, fBilling, totalCubic,
                  flatRate, connectionId);
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<void> updateReadingMember(
      String id,
      String currentReading,
      ValueNotifier fBilling,
      double totalCubic,
      String flatRate,
      String connectionId) async {
    if (currentReading.isNotEmpty && totalCubic > 0 && flatRate.isEmpty) {
      double totalPrice = await getTotalBill(connectionId, totalCubic);
      FirebaseFirestore.instance
          .collection('billing')
          .doc(docID)
          .collection('members')
          .doc(id)
          .update({
        'currentReading': double.parse(currentReading),
        'totalCubic': totalCubic,
        'billingPrice': totalPrice
      }).then((value) {
        getArea();
        fBilling.value = getArea();
      });
    }
  }

  Future<double> getTotalBill(String connectionId, double totalCubic) async {
    double totalBill = 0;
    double price = 0;

    await FirebaseFirestore.instance
        .collection('connection')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                //  debugPrint(doc.id);
                if (doc.id == connectionId) {
                  price = doc['price'];
                }
              })
            });
    totalBill = price * totalCubic;
    return totalBill;
  }

  void _updateFlatRateDialog(BuildContext context, String id, String name,
      ValueNotifier fBilling, String flatRatePrice, String memberId) {
    TextEditingController controllers = new TextEditingController();
    controllers.text = flatRatePrice.toString();
    showCupertinoModalPopup<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Update Billing'),
        content: Column(
          children: [
            Text('Update $name billing using flat rate'),
            SizedBox(
              height: 8,
            ),
            SizedBox(
              width: 100,
              height: 30,
              child: CupertinoTextField(
                textAlign: TextAlign.center,
                controller: controllers,
                onChanged: (value) {
                  controllers.text == value;
                },
              ),
            ),
            CupertinoButton(
              onPressed: () async {
                String? val = await showDialog<String>(
                  //<--------|
                  context: context,
                  builder: (context) => FlatRateDialog(
                    memberId: memberId,
                    valRate: controllers.text,
                  ),
                );
                controllers.text = val.toString();
              },
              child: Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    'Search flat rate from history',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    CupertinoIcons.search,
                    size: 20,
                  ),
                ],
              ),
            )
          ],
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              updateFlatRateMember(
                id,
                controllers.text,
                fBilling,
              );
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<void> updateFlatRateMember(
      String id, String flatRatePrice, ValueNotifier fBilling) async {
    if (flatRatePrice.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('billing')
          .doc(docID)
          .collection('members')
          .doc(id)
          .update({
        'flatRatePrice': double.parse(flatRatePrice),
        'billingPrice': double.parse(flatRatePrice),
      }).then((value) {
        getArea();
        fBilling.value = getArea();
      });
    }
  }

  Future<void> listMenuModal(BuildContext context) async {
    int? value = await showCupertinoModalPopup<int>(
      context: context,
      builder: (BuildContext context) => Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(-2); //pasing value on pop is -2
              },
              child: Text("Close ")),
        ],
      ),
    );

    print(value);
  }

  static Route<void> _modalBuilder(BuildContext context, Object? arguments) {
    print(arguments.toString());
    return CupertinoModalPopupRoute<void>(
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Title'),
          message: const Text('title'),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              child: const Text('Action One'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Action Two'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
