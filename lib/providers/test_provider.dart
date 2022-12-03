import 'package:agus/admin/models/area_models.dart';
import 'package:flutter/foundation.dart';

class TestProvider with ChangeNotifier{
  double count = 0;

  double get iscount => count;


  void countAdd(double value){
    count = value;
    notifyListeners();
  }


}