import 'package:agus/admin/models/billing_models.dart';
import 'package:agus/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BillingPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Billing', style: kTextStyleHeadline4,),),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: (){},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Icon(Icons.add_circle_outline, color: kColorBlue, size: 20,),
                SizedBox(width: 5,),
                const Text('Create new billing',style: BluekTextStyleHeadline2,),
              ],
            ),
          ),
        ),
        Divider(thickness: 5, color: kColorDarkBlue,),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 200,
              child: menuDate(context),
            )
          ],
        ),
      ],
    );
  }

  Future<List<Billing>> getBilling() async {
    List<Billing> bills = [];
    await FirebaseFirestore.instance
        .collection('billing')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                debugPrint(doc.id);
                Billing bill = Billing(doc.id, doc['month'], doc['year'],
                    doc['status'], doc['user']);
                bills.add(bill);
              })
            });
    print(bills.toString());
    return bills;
  }

  Widget menuDate(BuildContext context) {
    return FutureBuilder(
        future: getBilling(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.length <= 0) {
              // ignore: avoid_unnecessary_containers
              return Container(
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Icon(
                      Icons.folder_outlined,
                      color: kColorDarkBlue,
                      size: 70,
                    ),
                    Text('No billing found.'),
                  ],
                ),
              );
            } else {
              return Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: kColorDarkBlue,
                        child: GestureDetector(
                          onTap: () {},
                          child: Card(
                              color: kColorDarkBlue,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.circle, color: snapshot.data[index].status == 'active' ? Colors.green: kColorDarkBlue, size: 10,),
                                      SizedBox(width: 5,),
                                      Text(snapshot.data[index].month, style: kTextStyleHeadline4,),
                                      
                                      
                                    ],
                                  ),
                                  Text(snapshot.data[index].year, style: kTextStyleHeadline2Dark),
                                ],
                              )),
                        ),
                      );
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
