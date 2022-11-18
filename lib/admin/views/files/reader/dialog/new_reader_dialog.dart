import 'package:agus/admin/models/flat_rate_model.dart';
import 'package:agus/constants/constant.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/custom_menu_button.dart';
import '../../../../models/area_models.dart';

class NewReaderDialog extends StatefulWidget {
  @override
  _NewReaderDialog createState() => _NewReaderDialog();

  const NewReaderDialog({
    Key? key,
  }) : super(key: key);
}

class _NewReaderDialog extends State<NewReaderDialog> {
  TextEditingController fnameController = TextEditingController(text: '');
  TextEditingController mnameController = TextEditingController(text: '');
  TextEditingController lnameController = TextEditingController(text: '');
  TextEditingController contactController = TextEditingController(text: '');
  TextEditingController addressController = TextEditingController(text: '');
  List<Area> areaList = [];
  List<SelectArea> selectedArea = [];

  @override
  void initState() {
    super.initState();
    getArea();
  }

  getArea() async {
    List<Area> newAreas = [];

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

                newAreas.add(area);
              })
            });
    setState(() {
      areaList = newAreas;
      print(areaList.length);
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
          width: 800,
          height: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'New Reader',
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
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: widgetAreaList(context)),
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
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: MenuButton(
                          isSelect: true,
                          onPressed: () async {
                            await saveReader();
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

  Future<void> saveReader() async {
    FirebaseFirestore.instance.collection('reader').add({
      'firstName': fnameController.text,
      'middleInitName': mnameController.text,
      'lastName': lnameController.text,
      'contact': contactController.text,
      'address': addressController.text
    }).then((value) {
      saveArea(value.id);
    });
  }

  saveArea(String id)async{

    for(var v in selectedArea) {
      FirebaseFirestore.instance.collection('reader').doc(id).collection('area').add({
      'areaId': v.id,
      'name': v.name
    }).then((value) {});
    }

  }


  Widget widgetAreaList(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 300,
      child: areaList.isNotEmpty
          ? ListView.builder(
              itemCount: areaList.length,
              itemBuilder: (context, index) {
                SelectArea tmp = SelectArea(areaList[index].id, areaList[index].name);
                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: toReadChip(tmp),
                );
              })
          : const Center(child: Text('no data founf')),
    );
  }

  Widget toReadChip(SelectArea value) {
    return GestureDetector(
      onTap: () {
       
        if(selectedArea.map((item) => item.id).contains(value.id)){
           print('remove');
          setState(() {
            selectedArea.removeWhere((element) => element.id == value.id);
          });
          print(selectedArea.length);
        }else{
           print('add');
          setState(() {
            selectedArea.add(value);
          });
        }
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: selectedArea.map((item) => item.id).contains(value.id) ? Colors.blueAccent : Colors.grey.withOpacity(.7),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Center(
              child: Text(
            value.name,
            style: TextStyle(color: Colors.white, fontSize: 12),
          )),
        ),
      ),
    );
  }
}


class SelectArea{
  String id;
  String name;

  SelectArea(this.id,this.name);
}