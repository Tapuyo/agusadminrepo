import 'package:agus/admin/models/area_models.dart';
import 'package:agus/constants/constant.dart';
import 'package:agus/utils/custom_icon_button.dart';
import 'package:agus/utils/custom_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


class AreaPage extends HookWidget {
  const AreaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                        icon: Icons.add_circle,
                        key: key,
                        onPressed: () {},
                        text: 'New Area ',
                        elevation: 0,
                        textSize: 14,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                    Spacer(),
                    CustomSearch(onChanged: (value) {
                    },text: 'Seach area',),
                    IconButton(onPressed: (){}, icon: Icon(Icons.sort,color: kColorDarker.withOpacity(.5),))
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
                                      child: Text('Name',
                                            style: kTextStyleHeadline4,
                                          ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text('Code',
                                          style: kTextStyleHeadline4),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text('Description',
                                          style: kTextStyleHeadline4),
                                    ),
                                    Spacer(),

                                    Text('Action',
                                        style: kTextStyleHeadline4),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider()
                        ],
                      ),
                areaList(context),
              ],
            )));
  }


  Future<List<Area>> getArea() async {
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
    debugPrint(newAreas.toString());
    return newAreas;
  }

  Widget areaList(BuildContext context) {
    return FutureBuilder(
        future: getArea(),
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
                      return Column(
                        children: [
                          Container(
                            color: Colors.transparent,
                            child: GestureDetector(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      child: Text(snapshot.data[index].code,
                                          style: kTextStyleHeadline2Dark),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(snapshot.data[index].description,
                                          style: kTextStyleHeadline2Dark),
                                    ),
                                    Spacer(),
                                    IconButton(onPressed: (){}, icon: Icon(Icons.menu))
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
}
