import 'package:agus/admin/models/billing_models.dart';
import 'package:agus/admin/views/billing/billing_content.dart';
import 'package:agus/admin/views/billing/dialog/new_billing_dialog.dart';
import 'package:agus/constants/constant.dart';
import 'package:agus/utils/custom_menu_label_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/custom_icon_button.dart';

class BillingPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final docID = useState<String>('');
    final yearChoose = useState<String>(DateTime.now().year.toString());
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          billingMenu(context, docID, yearChoose),
          
          SizedBox(
            width: 10,
          ),
          BillingContentPage(docID: docID.value)
        ],
      ),
    );
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

  Widget billingMenu(
      BuildContext context, ValueNotifier docID, ValueNotifier yearChoose) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: 180,
        height: MediaQuery.of(context).size.height - 100,
        child: Padding(
          padding: EdgeInsets.fromLTRB(2, 20, 2, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomIconButton(
                  icon: Icons.add_circle,
                  key: key,
                  onPressed: () async {
                    String? val = await showDialog<String>(
                      context: context,
                      builder: (context) => NewBillingDialog(),
                    );
                  },
                  text: 'Create New Billing ',
                  elevation: 0,
                  textSize: 16,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
              SizedBox(
                height: 10,
              ),
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
              menuDate(context, docID, yearChoose),
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
    print(bills.toString());
    return bills;
  }

  Widget menuDate(
      BuildContext context, ValueNotifier docID, ValueNotifier yearChoose) {
    return FutureBuilder(
        future: getBilling(yearChoose.value),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.length <= 0) {
              // ignore: avoid_unnecessary_containers
              return Expanded(
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
            return Container(
              child: Center(
                child: Text('loading.'),
              ),
            );
          }
        });
  }
}
