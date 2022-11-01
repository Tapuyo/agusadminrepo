import 'package:agus/admin/models/flat_rate_model.dart';
import 'package:agus/constants/constant.dart';
import 'package:agus/utils/custom_menu_label_button.dart';
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
                  SizedBox(width: 5,),
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
              SizedBox(height: 10,),
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
                              SizedBox(height: 10,),
                              const Text(
                                'Creating new billing automatically current billing for the moth will automatically close  We advice to resolve previous month bill first before proceeding, it might cause an Issue to your latest billing. Other wise please continue your new billing',
                                style: kTextStyleHeadline2Dark,
                              ),
                            ],
                          ),
                        ),
                    ),
               SizedBox(height: 10,),
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
                              SizedBox(height: 5,),
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
                            Navigator.pop(context);
                          },
                          text: 'Cancel',
                          elevation: 0,
                          textSize: 14,
                          padding: const EdgeInsets.fromLTRB(5, 0, 10, 0)),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      flex: 1,
                      child: MenuButton(
                          isSelect: true,
                          onPressed: () {
                            Navigator.pop(context);
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
                              setState(() {
                                value = snapshot.data[index].price;
                                Navigator.pop(context, value);
                              });
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
}
