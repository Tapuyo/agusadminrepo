import 'package:agus/admin/models/billing_models.dart';
import 'package:agus/admin/views/billing/billing_content.dart';
import 'package:agus/admin/views/billing/dialog/new_billing_dialog.dart';
import 'package:agus/admin/views/report/report_content.dart';
import 'package:agus/constants/constant.dart';
import 'package:agus/utils/custom_menu_label_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/custom_icon_button.dart';

class ReportPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final docID = useState<String>('');
     final mothChoose = useState<String>('');
    final yearChoose = useState<String>(DateTime.now().year.toString());
    final openBilling = useState<bool>(false);
    final fBilling = useState<Future?>(null); 

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          billingMenu(context, docID, yearChoose, openBilling,fBilling, mothChoose),
          const SizedBox(
            width: 10,
          ),
          ReportContentPage(docID: docID.value, openBilling: openBilling.value, billYear: yearChoose.value, billMonth: mothChoose.value,)
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> get dropdownItemsYear {
    List<DropdownMenuItem<String>> menuItems = const [
      DropdownMenuItem(value: "2022", child:  Text("2022")),
      DropdownMenuItem(value: "2023", child:  Text("2023")),
      DropdownMenuItem(value: "2024", child:  Text("2024")),
      DropdownMenuItem(value: "2025", child:  Text("2025")),
      DropdownMenuItem(value: "2026", child:  Text("2026")),
      DropdownMenuItem(value: "2027", child:  Text("2028")),
      DropdownMenuItem(value: "2029", child:  Text("2029")),
      DropdownMenuItem(value: "2030", child:  Text("2030")),
    ];
    return menuItems;
  }

  Widget billingMenu(BuildContext context, ValueNotifier docID,
      ValueNotifier yearChoose, ValueNotifier openBilling, ValueNotifier fBilling, ValueNotifier mothChoose) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: 170,
        height: MediaQuery.of(context).size.height - 80,
        child: Padding(
          padding: EdgeInsets.fromLTRB(2, 20, 2, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton(
                    underline: SizedBox(),
                    style: kTextStyleHeadline2Dark,
                    focusColor: Colors.transparent,
                    value: yearChoose.value,
                    items: dropdownItemsYear,
                    onChanged: (newValue) {
                      yearChoose.value = newValue!;
                    },
                  ),
                ],
              ),
              menuDate(context, docID, yearChoose, openBilling,fBilling, mothChoose),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Billing>> getBilling(String yearChoose) async {
    List<Billing> bills = [];
    await FirebaseFirestore.instance
        .collection('billing')
        .orderBy('date', descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                debugPrint(doc.id);
                if (doc['year'] == yearChoose) {
                  Billing bill = Billing(doc.id, doc['month'], doc['year'],
                      doc['status'], doc['user']);
                  bills.add(bill);
                }
              })
            });
    return bills;
  }

  Widget menuDate(BuildContext context, ValueNotifier docID,
      ValueNotifier yearChoose, ValueNotifier openBilling,ValueNotifier fBilling, ValueNotifier mothChoose) {
        fBilling.value = getBilling(yearChoose.value);
    return FutureBuilder(
        future: fBilling.value,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.length <= 0) {
              // ignore: avoid_unnecessary_containers
              return const Expanded(
                child: Center(
                  child: Text('No billing found.'),
                ),
              );
            } else {
              return Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return MenuLabelButton(
                          isSelect:
                              docID.value == snapshot.data[index].billingID,
                          key: key,
                          onPressed: () {
                            docID.value = snapshot.data[index].billingID;
                            if (snapshot.data[index].status == 'open') {
                              openBilling.value = true;
                            } else {
                              openBilling.value = false;
                            }
                            mothChoose.value = snapshot.data[index].month;

                            print(docID.value);
                          },
                          text: snapshot.data[index].month,
                          elevation: 0,
                          textSize: 12,
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0));
                    }),
              );
            }
          } else {
            return  Container(
              child: Center(
                child: Text('loading.'),
              ),
            );
          }
        });
  }
}
