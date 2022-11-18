import 'package:agus/admin/models/area_models.dart';
import 'package:agus/admin/models/reader_model.dart';
import 'package:agus/admin/views/files/reader/dialog/new_reader_dialog.dart';
import 'package:agus/constants/constant.dart';
import 'package:agus/utils/custom_icon_button.dart';
import 'package:agus/utils/custom_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


class ReaderPage extends HookWidget {
  const ReaderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final refresh = useState<bool>(false);
    final readerList = useState<List<Reader>>([]);

     useEffect(() {
      Future.microtask(() async {
        await getReader(readerList);
      });
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
                        onPressed: () async {
                           final res = await showDialog<bool>(
                              context: context,
                              builder: (context) => const NewReaderDialog(),
                            );
                            refresh.value = !refresh.value;
                        },
                        text: 'New Reader ',
                        elevation: 0,
                        textSize: 14,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                    
                    CustomSearch(onChanged: (value) {
                    },text: 'Seach reader',),
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
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: const [
                                    Expanded(
                                      flex: 2,
                                      child: Text('Name',
                                            style: kTextStyleHeadline4,
                                          ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text('Contact',
                                          style: kTextStyleHeadline4),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text('Address',
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
                _buildReaderList(context, readerList),
              ],
            )));
  }


  getReader(ValueNotifier readerList) async {
    List<Reader> newReader = [];

    await FirebaseFirestore.instance
        .collection('reader')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                debugPrint(doc.id);
                Reader area = Reader(
                  doc.id,
                  doc['firstName'],
                  doc['middleInitName'],
                  doc['lastName'],
                  doc['address'],
                  doc['contact'].toString(),
                );

                newReader.add(area);
              })
            });
    debugPrint(newReader.toString());
    readerList.value = newReader;
  }

  Widget _buildReaderList(BuildContext context, ValueNotifier readerList) {
    return Expanded(
                child: ListView.builder(
                    //shrinkWrap: true,
                    itemCount: readerList.value.length,
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
                                            '${readerList.value[index].firstName}  ${readerList.value[index].middleName}.  ${readerList.value[index].lastName}',
                                            style: kTextStyleHeadline2Dark,
                                          ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(readerList.value[index].contact,
                                          style: kTextStyleHeadline2Dark),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(readerList.value[index].address,
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
