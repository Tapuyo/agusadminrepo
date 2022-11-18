import 'package:agus/admin/models/area_models.dart';
import 'package:agus/admin/models/member_model.dart';
import 'package:agus/admin/views/files/member/dialog/new_member_dialog.dart';
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
    final refresh = useState<bool>(false);
    final memberList = useState<List<Member>>([]);

     useEffect(() {
      Future.microtask(() async {
        await getMember(memberList);
      });
      return;
    },  [refresh.value]);

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
                        onPressed: () async{
                            final res = await showDialog<bool>(
                              context: context,
                              builder: (context) => const NewMemberDialog(),
                            );
                            refresh.value = !refresh.value;
                        },
                        text: 'New Member ',
                        elevation: 0,
                        textSize: 14,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                    
                    CustomSearch(onChanged: (value) {
                    },text: 'Seach member',),
                    Spacer(),
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
                                  children: const [
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
                buildmembersList(context,memberList),
              ],
            )));
  }


  getMember(ValueNotifier memberList) async {
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
    memberList.value = newMember;
  }

  Widget buildmembersList(BuildContext context, ValueNotifier memberList) {
    return Expanded(
                child: ListView.builder(
                    //shrinkWrap: true,
                    itemCount: memberList.value.length,
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
                                            memberList.value[index].firstName + ' ' + memberList.value[index].middleName + '. ' + memberList.value[index].lastName + ' ' + memberList.value[index].extensionName,
                                            style: kTextStyleHeadline2Dark,
                                          ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(memberList.value[index].address,
                                          style: kTextStyleHeadline2Dark),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(memberList.value[index].contact,
                                          style: kTextStyleHeadline2Dark),
                                    ),
                                     Expanded(
                                      flex: 2,
                                      child: Text(memberList.value[index].status,
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
}
