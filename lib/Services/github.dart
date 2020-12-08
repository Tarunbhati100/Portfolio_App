import 'dart:convert';

import 'package:Portfolio/modals/GitHub.dart';
import 'package:http/http.dart' as http;

class GitHubServices {
  String handle;
  GitHubServices({this.handle});

  Future<GitHub> getInfo() async {
    try {
      final http.Response response =
          await http.get("https://api.github.com/users/$handle");
      if (response.statusCode == 200) {
        final data = response.body;
        final decodedData = jsonDecode(data);
        return GitHub(
          handle: decodedData['login'],
          gitHubUrl: decodedData['html_url'],
          imgurl: decodedData['avatar_url'],
          totalrepo: decodedData['public_repos'],
        );
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }
}
