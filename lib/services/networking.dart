import 'dart:convert';
import 'package:http/http.dart';

class NetworkHelper {
  final String url;

  NetworkHelper({required this.url});

  Future getData() async {
    var uri = Uri.parse(url);
    Response response = await get(uri);

    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      return decodedData;
    } else {
      print(response.statusCode);
      print(response.body);
      return;
    }
  }
}
