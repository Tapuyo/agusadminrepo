import 'package:flutter/foundation.dart';

class BillingsProvider with ChangeNotifier{
  bool refresh = false;
  String read = 'All';
  String paid = 'All';
  String flatRate = 'All';
  String searchString = '';
  

  bool get isRefresh => refresh;
  String get isRead => read;
  String get isPaid => paid;
  String get isFlateRate => flatRate;
  String get issearchString => searchString;

  void setClear() {
    paid = 'All';
    read = 'All';
    flatRate = 'All';
    notifyListeners();
  }

 void billRefresh() {
    refresh = !refresh;
    notifyListeners();
  }

  void setPaid(String value){
    paid = value;
    notifyListeners();
  }

  void setRead(String value){
    read = value;
    notifyListeners();
  }

  void setFlatRate(String value){
    flatRate = value;
    notifyListeners();
  }

  void setSearchString(String value){
    searchString = value;
    notifyListeners();
  }
}