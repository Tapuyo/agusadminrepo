import 'package:agus/constants/constant.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? elevation;
  final double? borderRadius;
  final EdgeInsets? padding;
  final double? textSize;
  final IconData icon;
  final bool? enable;

  const CustomIconButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.elevation,
    this.borderRadius = 20,
    this.padding,
    this.textSize = 12,
    required this.icon,
    this.enable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: enable == true ? onPressed:null,
        child: Container(
          height: 35,
          decoration: BoxDecoration(
      color: enable == true ? kColorGreen:kColorDarker,
   
      borderRadius: BorderRadius.circular(20),),
  
        child: Padding(
          padding: padding ??
              const EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
               SizedBox(width: 10,),
              Icon(icon, color: kColorWhite,),
              SizedBox(width: 4,),
              Text(
                text,
                style: kTextStyleHeadline1Light,
              ),
               SizedBox(width: 10,),
            ],
          ),
        ),
      )
  ),
    );
}}