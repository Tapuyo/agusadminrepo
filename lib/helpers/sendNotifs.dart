import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:agus/constants/string.dart';

class FCMHelper{
   void sendNotif(String title, String message) async{
    String token = fcmToken;
    Map<String, String> headers = {"Authorization": token,"Content-Type": "application/json"};
    Map map = {
      'data':{
        "to" : "/topics/Reader",
        "notification" : {
          "body" : message,
          "title": title
        }
      },
    };
    var body = json.encode(map['data']);
    String url = 'https://fcm.googleapis.com/fcm/send';
    final response = await http.post(Uri.parse(url),headers: headers, body: body);
    //var jsondata = json.decode(response.headers);
    print(response.body.toString());
    if(response.statusCode == 200){

    }else{

    }
  
  }
}