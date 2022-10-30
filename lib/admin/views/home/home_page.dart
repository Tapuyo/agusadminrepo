import 'package:agus/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../utils/chip_label_header.dart';

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                borderRadius: BorderRadius.circular(20),),
                child: Padding(padding: EdgeInsets.fromLTRB(30, 2, 30, 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  ChipLabel(textTitle: 'Billed',textLabel: '880',onPressed: (){},circleColor: Colors.blue,circleRatio: 12),
                  ChipLabel(textTitle: 'To Pay',textLabel: '720',onPressed: (){},circleColor: Colors.yellow,circleRatio: 12),
                  ChipLabel(textTitle: 'Unpaid',textLabel: '60',onPressed: (){},circleColor: Colors.red,circleRatio: 12),
                  ChipLabel(textTitle: 'Recieved',textLabel: 'Php 23,201',onPressed: (){},circleColor: Colors.green,circleRatio: 12),
                  ChipLabel(textTitle: 'Balance',textLabel: 'Php 6,212',onPressed: (){},circleColor: Colors.purple,circleRatio: 12)
                ]),
                ),
              ),
              SizedBox(height: 20,),
              DecoratedBox(
                  decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 220,
                    child: Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Row(children: [
                      //TODO
                    ]),
                    ),
                  ),
                ),
          ],),
      )
    );
  }
}