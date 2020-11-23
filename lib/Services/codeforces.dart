import 'dart:convert';

import 'package:Portfolio/modals/Codeforces.dart';
import 'package:http/http.dart' as http;

class CodeforesServices {
  String handle;
  CodeforesServices({this.handle});

  Future<Codeforces> getInfo() async {
    final http.Response response =
        await http.get("https://codeforces.com/api/user.info?handles=$handle");
    if (response.statusCode == 200) {
      final data = response.body;
      final decodedData = jsonDecode(data)['result'][0];
      return Codeforces(
        handle: decodedData['handle'],
        rank: decodedData['rank'],
        maxrating: decodedData['maxRating'],
        maxrank: decodedData['maxRank'],
        imgurl: decodedData['titlePhoto'],
        currrating: decodedData['rating'],
      );
    } else {
      print(response.statusCode);
    }
  }
}
