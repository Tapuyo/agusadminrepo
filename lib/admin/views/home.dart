import 'dart:html';

import 'package:agus/admin/views/billing/billing.dart';
import 'package:agus/admin/views/files/files.dart';
import 'package:agus/admin/views/home/home_page.dart';
import 'package:agus/admin/views/report/report.dart';
import 'package:agus/constants/constant.dart';
import 'package:agus/utils/custom_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class WebHome extends HookWidget {
  const WebHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ismenuCollapse = useState<bool>(true);
    final indexMenu = useState<int>(0);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 207, 229, 240),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: const ColoredBox(
                      color: Color.fromARGB(255, 207, 229, 240),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(50, 20, 0, 10),
                        child: Text('PIWAS',style:BluekTextStyleHeadline5),
                      ),
                    )
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                menuWidget(context, ismenuCollapse, indexMenu),
                bodyWidget(context, indexMenu)
              ],
            )
          ]),
    );
  }

  Widget menuWidget(BuildContext context, ValueNotifier ismenuCollapse,
      ValueNotifier indexMenu) {
    return SizedBox(
      width: ismenuCollapse.value ? 200 : 50,
      height: MediaQuery.of(context).size.height - 60,
      child: ColoredBox(
        color: Color.fromARGB(255, 207, 229, 240),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30,),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: ismenuCollapse.value
                  ? Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MenuButton(
                            isSelect: indexMenu.value == 0,
                              key: key,
                              onPressed: () {
                                indexMenu.value = 0;
                              },
                              text: 'Home',
                              elevation: 0,
                              textSize: 14,
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0)),
                          MenuButton(
                            isSelect: indexMenu.value == 2,
                              key: key,
                              onPressed: () {
                                indexMenu.value = 2;
                              },
                              text: 'Files',
                              elevation: 0,
                               textSize: 14,
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0)),
                          MenuButton(
                            isSelect: indexMenu.value == 1,
                              key: key,
                              onPressed: () {
                                indexMenu.value = 1;
                              },
                              text: 'Billing',
                              elevation: 0,
                               textSize: 14,
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0)),
                          MenuButton(
                            isSelect: indexMenu.value == 3,
                              key: key,
                              onPressed: () {
                                indexMenu.value = 3;
                              },
                              text: 'Reports',
                              elevation: 0,
                               textSize: 14,
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0)),
                          MenuButton(
                            isSelect: indexMenu.value == 4,
                              key: key,
                              onPressed: () {
                                indexMenu.value = 4;
                              },
                              text: 'Settings',
                              elevation: 0,
                               textSize: 14,
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0)),
                        ],
                      ),
                  )
                  : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: () {
                                indexMenu.value = 0;
                              },
                              icon: const Icon(Icons.home)),
                          IconButton(
                              onPressed: () {
                                indexMenu.value = 2;
                              },
                              icon: const Icon(Icons.list)),
                          IconButton(
                              onPressed: () {
                                indexMenu.value = 1;
                              },
                              icon: const Icon(Icons.menu_book)),
                          
                          IconButton(
                              onPressed: () {
                                indexMenu.value = 3;
                              },
                              icon: const Icon(Icons.pie_chart)),
                          IconButton(
                              onPressed: () {
                                indexMenu.value = 4;
                              },
                              icon: const Icon(Icons.settings)),
                        ],
                      ),
                  ),
            ),
            Spacer(),
            IconButton(
                onPressed: () {
                  ismenuCollapse.value = !ismenuCollapse.value;
                },
                icon: !ismenuCollapse.value
                    ? const Icon(Icons.menu)
                    : const Icon(Icons.arrow_back_ios_new)),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget bodyWidget(BuildContext context, ValueNotifier indexMenu) {
    switch (indexMenu.value) {
      case 0:
        {
          return const HomePage();
        }

      case 1:
        {
          return  BillingPage();
        }
      
      case 2:
        {
          return  const FilesPage();
        }
      
      case 3:
        {
          return  ReportPage();
        }

      default:
        {
          return const HomePage();
        }
    }
  }
}
