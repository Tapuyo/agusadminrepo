import 'package:agus/admin/views/home/chart/barangay_member_chart.dart';
import 'package:agus/admin/views/home/chart/meter_chart.dart';
import 'package:agus/constants/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../utils/chip_label_header.dart';

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final billID = useState<String>('');
    final countBillMembers = useState<double>(0);
    final countBilledMembers = useState<double>(0);
    final countPaidMembers = useState<double>(0);
    final countUnpaidMembers = useState<double>(0);
    final countRecMembers = useState<double>(0);
    final countUnrecMembers = useState<double>(0);
    

    useEffect(() {
      Future.microtask(() async {
        await getBilling(billID);
      });
      return;
    }, const []);

    useEffect(() {
      Future.microtask(() async {
        await getBilledMembers(billID,countBilledMembers);
      });
      return;
    },  [billID.value]);

     useEffect(() {
      Future.microtask(() async {
        await getBillingMembers(billID,countBillMembers);
      });
      return;
    },  [billID.value]);

    useEffect(() {
      Future.microtask(() async {
        await getPaidMembers(billID,countPaidMembers);
      });
      return;
    },  [billID.value]);

    useEffect(() {
      Future.microtask(() async {
        await getUnpaidMembers(billID,countUnpaidMembers);
      });
      return;
    },  [billID.value]);

    useEffect(() {
      Future.microtask(() async {
        await getTotalReceivedMembers(billID,countRecMembers);
      });
      return;
    },  [billID.value]);

    useEffect(() {
      Future.microtask(() async {
        await getTotalUnrecMembers(billID,countUnrecMembers);
      });
      return;
    },  [billID.value]);

    return Expanded(
        child: Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(30, 2, 30, 2),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ChipLabel(
                        textTitle: 'Billed',
                        textLabel: '${countBilledMembers.value}/${countBillMembers.value}',
                        onPressed: () {},
                        circleColor: Colors.blue,
                        circleRatio: 12),
                    ChipLabel(
                        textTitle: 'Paid',
                        textLabel: '${countPaidMembers.value}',
                        onPressed: () {},
                        circleColor: Colors.yellow,
                        circleRatio: 12),
                    ChipLabel(
                        textTitle: 'Unpaid',
                        textLabel: '${countUnpaidMembers.value}',
                        onPressed: () {},
                        circleColor: Colors.red,
                        circleRatio: 12),
                    ChipLabel(
                        textTitle: 'Recieved',
                        textLabel: 'Php ${countRecMembers.value.toStringAsFixed(2)}',
                        onPressed: () {},
                        circleColor: Colors.green,
                        circleRatio: 12),
                    ChipLabel(
                        textTitle: 'Balance',
                        textLabel: 'Php ${countUnrecMembers.value.toStringAsFixed(2)}',
                        onPressed: () {},
                        circleColor: Colors.purple,
                        circleRatio: 12)
                  ]),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Expanded(child: BarChartSample1()),
                      PieChartSample2(),
                    ]),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  getBilling(ValueNotifier billingID) async {
    await FirebaseFirestore.instance
        .collection('billing')
        .where('status', isEqualTo: 'open')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                billingID.value = doc.id;
              })
    });
    print(billingID.value);
  }

  getBillingMembers(ValueNotifier billingID, ValueNotifier countBillMembers,) async {
  
    await FirebaseFirestore.instance
        .collection('membersBilling')
        .where('billingId', isEqualTo: billingID.value)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                countBillMembers.value = countBillMembers.value + 1;
              })
    });
  }

  getBilledMembers(ValueNotifier billingID, ValueNotifier countBilledMembers) async {

     await FirebaseFirestore.instance
        .collection('membersBilling')
        .where('billingId', isEqualTo: billingID.value)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                if(doc['toBill'] == true){
                  print(doc.id);
                  countBilledMembers.value = countBilledMembers.value + 1;
                }
              })
    });
  }

   getPaidMembers(ValueNotifier billingID, ValueNotifier countPaidMembers) async {

     await FirebaseFirestore.instance
        .collection('membersBilling')
        .where('billingId', isEqualTo: billingID.value)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                if(doc['status'] == 'paid'){
                  countPaidMembers.value = countPaidMembers.value + 1;
                }
              })
    });
  }

  getUnpaidMembers(ValueNotifier billingID, ValueNotifier countUpaidMembers) async {

     await FirebaseFirestore.instance
        .collection('membersBilling')
        .where('billingId', isEqualTo: billingID.value)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                if(doc['status'] == 'unpaid'){
                  countUpaidMembers.value = countUpaidMembers.value + 1;
                  
                }
              })
    });
  }


  getTotalReceivedMembers(ValueNotifier billingID, ValueNotifier countRecMembers) async {

     await FirebaseFirestore.instance
        .collection('membersBilling')
        .where('billingId', isEqualTo: billingID.value)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                if(doc['status'] == 'paid'){
                  countRecMembers.value = countRecMembers.value + doc['totalBill'];
                  
                }
              })
    });
  }

   getTotalUnrecMembers(ValueNotifier billingID, ValueNotifier countUnrecMembers) async {

     await FirebaseFirestore.instance
        .collection('membersBilling')
        .where('billingId', isEqualTo: billingID.value)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                if(doc['status'] == 'unpaid'){
                  try{
                    countUnrecMembers.value = countUnrecMembers.value + doc['totalBill'];
                  }catch(e){
                    debugPrint('none');
                  }
                }
              })
    });
  }
}
