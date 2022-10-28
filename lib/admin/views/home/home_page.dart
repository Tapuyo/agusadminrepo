import 'package:agus/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),),
                child: Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Row(children: [
                  //TODO
                ]),
                ),
              ),
              SizedBox(height: 20,),
              DecoratedBox(
                  decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
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