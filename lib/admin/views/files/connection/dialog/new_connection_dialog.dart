import 'package:agus/admin/models/flat_rate_model.dart';
import 'package:agus/constants/constant.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/custom_menu_button.dart';

class NewConnectioDialog extends StatefulWidget {
  @override
  _NewConnectionDialog createState() => _NewConnectionDialog();

  const NewConnectioDialog({
    Key? key,
  }) : super(key: key);
}

class _NewConnectionDialog extends State<NewConnectioDialog> {
  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController descriptionController = TextEditingController(text: '');
  TextEditingController codeController = TextEditingController(text: '');
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          width: 500,
          height: 340,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'New Connection',
                style: BluekTextStyleHeadline1,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextField(
                      style: kTextStyleHeadline1,
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8,),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextField(
                      maxLines: 3,
                      style: kTextStyleHeadline1,
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8,),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: kTextStyleHeadline1,
                      controller: codeController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Price in Peso',
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: MenuButton(
                          isSelect: false,
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          text: 'Cancel',
                          elevation: 0,
                          textSize: 14,
                          padding: const EdgeInsets.fromLTRB(5, 0, 10, 0)),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: MenuButton(
                          isSelect: true,
                          onPressed: () async {
                            await saveConnection();
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context, true);
                          },
                          text: 'Save',
                          elevation: 0,
                          textSize: 14,
                          padding: const EdgeInsets.fromLTRB(5, 0, 10, 0)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveConnection() async {
    FirebaseFirestore.instance.collection('connection').add({
      'price': double.parse(codeController.text),
      'description': descriptionController.text,
      'name': nameController.text,
    }).then((value) {});
  }
}
