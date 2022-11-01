import 'package:agus/admin/models/flat_rate_model.dart';
import 'package:agus/constants/constant.dart';
import 'package:agus/utils/custom_menu_label_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FlatRateDialog extends StatefulWidget {
  final String memberId;
  final String valRate;
  @override
  _DialogTwoState createState() => _DialogTwoState();

  const FlatRateDialog({
    Key? key,
    required this.memberId,
    required this.valRate
  }) : super(key: key);
}

class _DialogTwoState extends State<FlatRateDialog> {
  String value = '';


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: SizedBox(
         width: 250,
        height: 300,
        child: Column(
          children: [
            Text('Choose flat rate'),
            const SizedBox(height: 15),
            flatRateList(context),
            Spacer(),
            // ElevatedButton(
            //  // Pass the value you want to return here ---------------|
            //   onPressed: () => Navigator.pop(context, value), //<-----|
            //   child: SizedBox(
            //     width: 200,
            //     child: const Text('cancel')),
            // ),
            MenuLabelButton(
                        isSelect: false,
                        onPressed: () {
                          Navigator.pop(context, widget.valRate);
                        },
                        text: 'Cancel',
                        elevation: 0,
                        textSize: 14,
                        padding: const EdgeInsets.fromLTRB(5, 0, 10, 0)),
          ],
        ),
      ),
    );
  }

  Future<List<FlatRate>> getFlat() async {
    List<FlatRate> flatRate = [];

    await FirebaseFirestore.instance
        .collection('members').doc(widget.memberId).collection('flatrate')
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
                                    setState(() {
                                      value = snapshot.data[index].price;
                                      Navigator.pop(context, value);
                                    });
                                },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
}
