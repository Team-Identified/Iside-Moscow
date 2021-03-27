import 'dart:convert';
import 'package:http/http.dart';

class News {
  var data = {};
  var news4today = <Map>[];

  Future<void> getData() async {
    // try {
      for (int i = 1; i < 11; i++) {
        var url = Uri.parse('http://10.0.2.2:8000/news/get_news/?page=$i');
        var response = await get(url);
        data[i] = jsonDecode(utf8.decode(response.bodyBytes));
      }
    reformatData();
    // } catch (error) {
    //   print(error);
    // }
  }

  void reformatData() {
    for (int i = 1; i < 11; i++) {
      for (int j = 0; j < data[i]['articles'].length; j++) {
        Map tempData = Map<String, dynamic>.from(data[i]['articles'][j]);
        news4today.add(tempData);
      }
    }
    for (int i = 0; i < news4today.length; i++){
      news4today[i].remove('content');
    }
  }
}
