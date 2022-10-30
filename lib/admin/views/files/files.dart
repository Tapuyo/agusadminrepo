import 'package:agus/admin/views/files/area/area_page.dart';
import 'package:agus/admin/views/files/connection/connection_page.dart';
import 'package:agus/admin/views/files/member/member_page.dart';
import 'package:agus/admin/views/files/reader/reader_page.dart';
import 'package:agus/utils/custom_menu_button.dart';
import 'package:agus/utils/custom_menu_label_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FilesPage extends HookWidget {
  const FilesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menuSelect = useState<String>('area');
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
                    MenuLabelButton(
                        isSelect: menuSelect.value == 'area',
                        key: key,
                        onPressed: () {
                          menuSelect.value = 'area';
                        },
                        text: 'Area',
                        elevation: 0,
                        textSize: 14,
                        padding: const EdgeInsets.fromLTRB(5, 0, 10, 0)),
                    MenuLabelButton(
                        isSelect: menuSelect.value == 'member',
                        key: key,
                        onPressed: () {
                          menuSelect.value = 'member';
                        },
                        text: 'Members',
                        elevation: 0,
                        textSize: 14,
                        padding: const EdgeInsets.fromLTRB(5, 0, 10, 0)),
                    MenuLabelButton(
                        isSelect: menuSelect.value == 'reader',
                        key: key,
                        onPressed: () {
                          menuSelect.value = 'reader';
                        },
                        text: 'Reader',
                        elevation: 0,
                        textSize: 14,
                        padding: const EdgeInsets.fromLTRB(5, 0, 10, 0)),
                    MenuLabelButton(
                        isSelect: menuSelect.value == 'connection',
                        key: key,
                        onPressed: () {
                          menuSelect.value = 'connection';
                        },
                        text: 'Connection',
                        elevation: 0,
                        textSize: 14,
                        padding: const EdgeInsets.fromLTRB(5, 0, 10, 0)),
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
              height: MediaQuery.of(context).size.height - 220,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Row(children: [bodyWidget(context, menuSelect)]),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget bodyWidget(BuildContext context, ValueNotifier indexMenu) {
    switch (indexMenu.value) {
      case 'area':
        {
          return const AreaPage();
        }

      case 'member':
        {
          return MemberPage();
        }
      case 'reader':
        {
          return ReaderPage();
        }
      case 'connection':
        {
          return ConnectionPage();
        }
      default:
        {
          return const AreaPage();
        }
    }
  }
}
