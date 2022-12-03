
import 'dart:convert';
import 'package:agus/constants/string.dart';
import 'package:agus/helpers/sendNotifs.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class TextValueCount extends StatelessWidget {
  const TextValueCount({
    Key? key,
    required this.counter,
  }) : super(key: key);

  final ValueNotifier<double> counter;


  @override
  Widget build(BuildContext context) {
    FCMHelper fcmHelper = FCMHelper();
    return GestureDetector(
      onTap: (){
        fcmHelper.sendNotif('Piwas', 'Test message');
      },
      child: Container(
          child: Center(
            child: Text(counter.value.toString())
          )
      ),
    );
  }

}