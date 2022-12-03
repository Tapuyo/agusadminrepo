import 'dart:math';
import 'dart:math' as math;
import 'package:agus/admin/models/area_meter.dart';
import 'package:agus/admin/views/home/chart/indicator.dart';
import 'package:agus/constants/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({super.key});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
  int touchedIndex = -1;
  List<AreaMeter> areaMeterList = [];
  String billID = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBilling();
  }

  getBilling() async {
    await FirebaseFirestore.instance
        .collection('billing')
        .where('status', isEqualTo: 'open')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                billID = doc.id;
              })
            });

    if (billID != '') {
      getArea();
    }
  }

  getArea() async {
    areaMeterList = [];
    await FirebaseFirestore.instance
        .collection('area')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                double meterTotal = await getBillMeter(doc.id);
                AreaMeter areaMeter = AreaMeter(
                    doc.id,
                    meterTotal,
                    doc['name'],
                    Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                        .withOpacity(1.0));
                setState(() {
                  areaMeterList.add(areaMeter);
                });
              })
            });
  }

  Future<double> getBillMeter(String areaID) async {
    double meterConsumpt = 0;
    await FirebaseFirestore.instance
        .collection('membersBilling')
        .where('billingId', isEqualTo: billID)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                if (doc['areaId'] == areaID) {
                  meterConsumpt = meterConsumpt + doc['totalCubic'];
                }
              })
            });
    return meterConsumpt;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: 400,
        height: 300,
        child: AspectRatio(
          aspectRatio: 1.3,
          child: Card(
            color: Color.fromARGB(255, 207, 229, 240),
            child: Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  'Meter Consumption',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: <Widget>[
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: areaMeterList.isNotEmpty
                          ? AspectRatio(
                              aspectRatio: 1,
                              child: PieChart(
                                PieChartData(
                                  pieTouchData: PieTouchData(
                                    touchCallback:
                                        (FlTouchEvent event, pieTouchResponse) {
                                      setState(() {
                                        if (!event
                                                .isInterestedForInteractions ||
                                            pieTouchResponse == null ||
                                            pieTouchResponse.touchedSection ==
                                                null) {
                                          touchedIndex = -1;
                                          return;
                                        }
                                        touchedIndex = pieTouchResponse
                                            .touchedSection!
                                            .touchedSectionIndex;
                                      });
                                    },
                                  ),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 40,
                                  sections: showingSections(),
                                ),
                              ),
                            )
                          : const Center(child: CircularProgressIndicator()),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: listAreas()),
                    const SizedBox(
                      width: 28,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Indicator> listAreas() {
    var textList = areaMeterList.map<Indicator>((s) {
      return Indicator(
        color: s.color,
        text: s.name,
        isSquare: true,
      );
    }).toList();

    return textList;
  }

  List<PieChartSectionData> showingSections() {
    int count = 0;
    List<PieChartSectionData> textList =
        areaMeterList.map<PieChartSectionData>((s) {
      final isTouched = count == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      
      count++;
      return PieChartSectionData(
        color: s.color,
        value: s.meter,
        title: s.meter.toStringAsFixed(2),
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
      );
      
    }).toList();
    return textList;
  }
}
