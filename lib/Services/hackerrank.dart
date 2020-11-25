import 'package:Portfolio/modals/Badge.dart';
import 'package:Portfolio/modals/hackerrank.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class HackerRankServices {
  String handle;
  HackerRankServices({this.handle});

  Future<HackerRank> getInfo() async {
    final http.Response response =
        await http.get("https://www.hackerrank.com/$handle");
    if (response.statusCode == 200) {
      final doc = parse(response.body);
      List<Badge> badgesdata = [];
      String imageUrl = doc
          .getElementsByClassName("ui-avatar__img")[0]
          .attributes["src"]
          .toString();
      final badge = doc.getElementsByClassName("hacker-badge");
      for (var i in badge) {
        final title = i.getElementsByClassName("badge-title")[0].firstChild.toString();
        badgesdata.add(Badge(
            name: i
                .getElementsByClassName("badge-title")[0]
                .firstChild
                .toString().substring(1,title.length-1),
            star: i
                .getElementsByClassName("star-section")[0]
                .children[0]
                .children
                .length));
      }
      return HackerRank(handle: handle, badges: badgesdata, imageurl: imageUrl);
    } else {
      print(response.statusCode);
    }
  }
}
