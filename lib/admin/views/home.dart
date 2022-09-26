import 'package:agus/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class WebHome extends StatefulWidget {
  const WebHome({Key? key}) : super(key: key);

  @override
  State<WebHome> createState() => _WebHomeState();
}

class _WebHomeState extends State<WebHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Row(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: const ColoredBox(
                  color: kColorBlue,
                  // child: Row(children: [

                  // ]),
                )),
          ],
        )
      ]),
    );
  }
}
