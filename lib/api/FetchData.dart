import 'dart:convert';

import 'package:http/http.dart';

class API {

  // for fetching the data from third party API
  static Future FetchData() async {
    try {
      final url = Uri.parse("https://dummyjson.com/products");
      final response = await get(url);
      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      print(e);
    }
  }
}
