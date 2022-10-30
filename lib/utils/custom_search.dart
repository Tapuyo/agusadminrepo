import 'package:agus/constants/constant.dart';
import 'package:flutter/material.dart';

class CustomSearch extends StatelessWidget {
  final String text;
  final Function(String) onChanged;
  final double? elevation;
  final double? borderRadius;
  final EdgeInsets? padding;
  final double? textSize;

  const CustomSearch({
    Key? key,
    required this.text,
    required this.onChanged,
    this.elevation,
    this.borderRadius = 20,
    this.padding,
    this.textSize = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 40,
          width: 250,
          decoration: BoxDecoration(
            color: kColorDarkBlue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 250,
                child: TextField(
                  onChanged: onChanged,
                  cursorHeight: 20,
                  style: kTextStyleHeadline1,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                            width: 3, color: Colors.grey.shade100), 
                      ),
                      contentPadding: EdgeInsets.only(
                        bottom: 40 / 2,
                      ),
                      hintText: text),
                ),
              )
            ],
          ),
        ));
  }
}
