import 'package:agus/admin/models/connection_model.dart';
import 'package:agus/admin/models/flat_rate_model.dart';
import 'package:agus/constants/constant.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/custom_menu_button.dart';
import '../../../../models/area_models.dart';

class NewMemberDialog extends StatefulWidget {
  @override
  _NewMemberDialog createState() => _NewMemberDialog();

  const NewMemberDialog({
    Key? key,
  }) : super(key: key);
}

class _NewMemberDialog extends State<NewMemberDialog> {
  TextEditingController fnameController = TextEditingController(text: '');
  TextEditingController mnameController = TextEditingController(text: '');
  TextEditingController lnameController = TextEditingController(text: '');
  TextEditingController enameController = TextEditingController(text: '');
  TextEditingController contactController = TextEditingController(text: '');
  TextEditingController addressController = TextEditingController(text: '');
  TextEditingController currentController = TextEditingController(text: '0');
  TextEditingController prevController = TextEditingController(text: '0');
  TextEditingController meterIDController = TextEditingController(text: '');
  String billingID = '';
  String billingMonth = '';
  String billingYear = '';

  List<Area> areaList = [];
  String areaSelected = 'Default';
    Area area =  Area(
                  'Default',
                  'Area',
                  'Area',
                  'Area',
                  'Area',
                  'Area',
                );

  List<Connection> connList = [];
  String connSelected = 'Default';
    Connection conn =  Connection(
                  'Default',
                  'Connection',
                  'Connection',
                  7,
                );

    


  @override
  void initState() {
    areaList.add(area);
    connList.add(conn);
    super.initState();
    getBilling();
    getAreaDropDown();
    getConnDropDown();
  }


  getBilling() async {
    await FirebaseFirestore.instance
        .collection('billing').where('status', isEqualTo: 'open')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
               setState(() {
                 
                  billingID = doc.id;
                  billingMonth = doc['month'];
                  billingYear = doc['year'];
               });
              })
            });
  }

  getAreaDropDown() async {
    List<Area> areaTmp = [];
     areaTmp.add(area);

    await FirebaseFirestore.instance
        .collection('area')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                debugPrint(doc.id);
                Area area = Area(
                  doc.id,
                  doc['code'],
                  doc['name'],
                  doc['description'],
                  doc['status'],
                  doc['date'].toString(),
                );

                areaTmp.add(area);
              })
            });
    setState(() {
      areaList = areaTmp;
    });
  }

    getConnDropDown() async {
    List<Connection> areaTmp = [];
     areaTmp.add(conn);

    await FirebaseFirestore.instance
        .collection('connection')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                debugPrint(doc.id);
                Connection area = Connection(
                  doc.id,
                  doc['name'],
                  doc['description'],
                  doc['price'],
                );

                areaTmp.add(area);
              })
            });
    setState(() {
      connList = areaTmp;
    });
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
          height: 600,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                'New Members $billingID',
                style: BluekTextStyleHeadline1,
              ),
              const SizedBox(height: 15,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextField(
                                style: kTextStyleHeadline1,
                                controller: meterIDController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Members ID/Meter number',
                                ),
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                            
                          ],
                        ),
                         const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextField(
                                style: kTextStyleHeadline1,
                                controller: fnameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'First Name',
                                ),
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                maxLength: 1,
                                style: kTextStyleHeadline1,
                                controller: mnameController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'MI',
                                    counterText: ''),
                                onChanged: (value) {},
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextField(
                                style: kTextStyleHeadline1,
                                controller: lnameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Last Name',
                                ),
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                             const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                maxLength: 1,
                                style: kTextStyleHeadline1,
                                controller: enameController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Ex: Jr',
                                    counterText: ''),
                                onChanged: (value) {},
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextField(
                                maxLines: 3,
                                style: kTextStyleHeadline1,
                                controller: addressController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Address',
                                ),
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextField(
                                style: kTextStyleHeadline1,
                                controller: contactController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Contact number',
                                ),
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                         const SizedBox(
                          height: 12,
                        ),
                     
                     ]),
                  ),
                 
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade600, 
                    width: 1
                  ),
                  borderRadius: BorderRadius.circular(4),
                  
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(children: [
                                const SizedBox(
                                height: 8,
                              ),
                              if (areaList.isNotEmpty) ...[
                                
                                Row(children: [const Text('Area : ',style: TextStyle(fontSize: 12),),
                                const SizedBox(
                                  width: 8,
                                ),
                               
                                 DropdownButton(
                                  underline: SizedBox(),
                                  hint: const Text(
                                      'Choose '), 
                                  value: areaSelected,
                                  onChanged: (newValue) {
                                   setState(() {
                                      areaSelected = newValue.toString();
                                   });
                                  },
                                  items: areaList.map((area) {
                                    return DropdownMenuItem(
                                      // ignore: sort_child_properties_last
                                      child:  Text(area.name,style: TextStyle(fontSize: 12),),
                                      value: area.id,
                                    );
                                  }).toList(),
                                )
                               
                                ,],)
                              ],
                              ],),
                ),
              ),
              SizedBox(height: 12,),
                Container(
                   decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade600, 
                    width: 1
                  ),
                  borderRadius: BorderRadius.circular(4),
                  
                ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(children: [
                              const SizedBox(
                              height: 8,
                            ),
                            if (areaList.isNotEmpty) ...[
                              
                              Row(children: [
                                const Text('Connection Type :         ',style: TextStyle(fontSize: 12),),
                              const SizedBox(
                                width: 8,
                              ),
                             
                               DropdownButton(
                                underline: SizedBox(),
                                hint: const Text(
                                    'Choose '), 
                                value: connSelected,
                                onChanged: (newValue) {
                                 setState(() {
                                    connSelected = newValue.toString();
                                 });
                                },
                                items: connList.map((conn) {
                                  return DropdownMenuItem(
                                    // ignore: sort_child_properties_last
                                    child:  Text('${conn.name}, Php   ${conn.price.toString()}',style: TextStyle(fontSize: 12),),
                                    value: conn.id,
                                  );
                                }).toList(),
                              )
                             
                              ,],)
                            ],
                            ],),
                  ),
                ),

              SizedBox(height: 12,),
              Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                style: kTextStyleHeadline1,
                                controller: prevController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Previous Meter',
                                ),
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              flex: 2,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                style: kTextStyleHeadline1,
                                controller: currentController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Current Meter',
                                    counterText: ''),
                                onChanged: (value) {},
                              ),
                            ),
                          ],
                        ),
              const Spacer(),
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
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: MenuButton(
                          isSelect: true,
                          onPressed: () async {
                            await saveMember();
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context, true);
                          },
                          text: 'Save',
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

  saveMember() async {
    FirebaseFirestore.instance.collection('members').add({
      'memberId': meterIDController.text,
      'firstName': fnameController.text,
      'middleInitName': mnameController.text,
      'lastName': lnameController.text,
      'extensionName': enameController.text,
      'contact': contactController.text,
      'address': addressController.text,
      'area': areaSelected,
      'connection': connSelected,
      'date': DateTime.now(),
      'status': 'active'
    }).then((value) {
        saveMemberToBill(value.id);
    });
  }


Future<void> saveMemberToBill(String memberID) async {
  String fullName = '${fnameController.text} ${mnameController.text}. ${lnameController.text} ${enameController.text}';
    FirebaseFirestore.instance.collection('membersBilling').add({
      'areaId': areaSelected,
      'balance': 0,
      'billingId': billingID,
      'billingPrice': 0,
      'connectionId': connSelected,
      'currentReading': double.parse(currentController.text),
      'totalCubic': 0,
      'toBill': false,
      'status': 'unpaid',
      'previousReading': double.parse(prevController.text,),
      'dateRead': DateTime.now(),
      'flatRate': '',
      'flatRatePrice': 0,
      'memberId': memberID,
      'name': fullName,
      'month': billingMonth,
      'year': billingYear,
      'dueDateBalance': DateTime.now(),
      'dateBill': DateTime.now(),
    }).then((value) {
    
    });
  }



}


