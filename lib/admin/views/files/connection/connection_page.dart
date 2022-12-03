import 'package:agus/admin/models/area_models.dart';
import 'package:agus/admin/models/connection_model.dart';
import 'package:agus/admin/views/files/connection/dialog/new_connection_dialog.dart';
import 'package:agus/constants/constant.dart';
import 'package:agus/utils/custom_icon_button.dart';
import 'package:agus/utils/custom_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


class ConnectionPage extends HookWidget {
  const ConnectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final refresh = useState<bool>(false);
    final connList = useState<List<Connection>>([]);

     useEffect(() {
      Future.microtask(() async {
        await getConnection(connList);
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
                        onPressed: ()async {
                          final res = await showDialog<bool>(
                              context: context,
                              builder: (context) => const NewConnectioDialog(),
                            );
                            refresh.value = !refresh.value;
                        },
                        text: 'New Connection ',
                        elevation: 0,
                        textSize: 14,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                    
                    CustomSearch(onChanged: (value) {
                    },text: 'Seach connection',),
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
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text('Name',
                                            style: kTextStyleHeadline4,
                                          ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text('Description',
                                          style: kTextStyleHeadline4),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text('Price',
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
                connectionList(context,connList),
              ],
            )));
  }


  getConnection(ValueNotifier connList) async {
    List<Connection> newConnection = [];

    await FirebaseFirestore.instance
        .collection('connection')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                debugPrint(doc.id);
                Connection conn = Connection(
                  doc.id,
                  doc['name'],
                  doc['description'],
                  doc['price'],
                );

                newConnection.add(conn);
              })
            });
    connList.value = newConnection;
  }

  Widget connectionList(BuildContext context, ValueNotifier connList) {
    return connList.value.isNotEmpty ?Expanded(
                child: ListView.builder(
                    //shrinkWrap: true,
                    itemCount: connList.value.length,
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
                                            connList.value[index].name,
                                            style: kTextStyleHeadline2Dark,
                                          ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(connList.value[index].description,
                                          style: kTextStyleHeadline2Dark),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text('Php ${connList.value[index].price.toString()}',
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
              ):const Center(child: CircularProgressIndicator(),);
  }
}
