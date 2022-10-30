import 'package:agus/admin/models/area_models.dart';
import 'package:agus/admin/models/member_model.dart';
import 'package:agus/constants/constant.dart';
import 'package:agus/utils/custom_icon_button.dart';
import 'package:agus/utils/custom_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


class MemberPage extends HookWidget {
  const MemberPage({Key? key}) : super(key: key);

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
                        text: 'New Member ',
                        elevation: 0,
                        textSize: 14,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                    Spacer(),
                    CustomSearch(onChanged: (value) {
                    },text: 'Seach member',),
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
                                      child: Text('Address',
                                          style: kTextStyleHeadline4),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text('Contact',
                                          style: kTextStyleHeadline4),
                                    ),
                                     Expanded(
                                      flex: 2,
                                      child: Text('Status',
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
                membersList(context),
              ],
            )));
  }


  Future<List<Member>> getMember() async {
    List<Member> newMember = [];

    await FirebaseFirestore.instance
        .collection('members')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                debugPrint(doc.id);
                Member member = Member(
                  doc.id,
                  doc['memberId'],
                  doc['firstName'],
                  doc['middleInitName'],
                  doc['lastName'],
                  doc['extensionName'],
                  doc['contact'],
                  doc['address'],
                  doc['area'],
                  doc['connection'],
                  doc['status'],
                  doc['date'].toString(),
                );
                newMember.add(member);
              })
            });
    debugPrint(newMember.toString());
    return newMember;
  }

  Widget membersList(BuildContext context) {
    return FutureBuilder(
        future: getMember(),
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
                    Text('No member found.'),
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
                                            snapshot.data[index].firstName + ' ' + snapshot.data[index].middleName + '. ' + snapshot.data[index].lastName + ' ' + snapshot.data[index].extensionName,
                                            style: kTextStyleHeadline2Dark,
                                          ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(snapshot.data[index].address,
                                          style: kTextStyleHeadline2Dark),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(snapshot.data[index].contact,
                                          style: kTextStyleHeadline2Dark),
                                    ),
                                     Expanded(
                                      flex: 2,
                                      child: Text(snapshot.data[index].status,
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
            return Container(
              child: Column(
                children: const [
                   Center(
                  child: Text('loading.'),
                ),
                ],
              ),
            );
          }
        });
  }
}
