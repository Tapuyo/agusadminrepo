import 'package:flutter/foundation.dart';

class HomeProvider with ChangeNotifier{
  bool refresh = false;
  

  bool get isRefresh => refresh;

 void billRefresh() {
    refresh = !refresh;
    notifyListeners();
  }
}