import 'package:agus/constants/constant.dart';
import 'package:flutter/material.dart';

class ChipLabel extends StatelessWidget {
  final String textTitle;
  final String textLabel;
  final VoidCallback onPressed;
  final double? textSize;
  final double? circleRatio;
  final Color circleColor;
  final Color? textColor;

  const ChipLabel(
      {Key? key,
      required this.textTitle,
      required this.textLabel,
      required this.onPressed,
      this.textSize = 12,
      this.circleRatio = 15,
      required this.circleColor,
      this.textColor = Colors.black45})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: circleRatio,
                    height: circleRatio,
                    decoration: BoxDecoration(
                        color: circleColor, shape: BoxShape.circle),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    textTitle,
                    style: kTextStyleHeadline2Dark,
                  ),
                ],
              ),
           
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    textLabel,
                    style: kTextStyleHeadline5,
                  ),
                ],
              )
            ]),
      ),
    );
  }
}
