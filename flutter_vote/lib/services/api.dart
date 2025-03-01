import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Api {
  static const baseUrl = "http://172.20.10.2:5000/";

  static addproduct(Map data) async {
    print(data);
    try {
      print("Going for response ${baseUrl}data");
      final res = await http.post(Uri.parse("${baseUrl}data"), body: data);
      print("Mannan$res");
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        print(data);
      } else {
        print("Failed to Get the Response");
      }
    } catch (e) {
      print("catch part");
      debugPrint(e.toString());
    }
  }
}
