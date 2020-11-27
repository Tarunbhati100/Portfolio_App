import 'package:Portfolio/modals/codechef.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class CodechefServices {
  String handle;
  CodechefServices({this.handle});

  Future<Codechef> getInfo() async {
    final http.Response response =
        await http.get("https://www.codechef.com/users/$handle");
    if (response.statusCode == 200) {
      final doc = parse(response.body);
      String currrating =
          doc.getElementsByClassName("rating-number")[0].firstChild.toString();
      String maxrating = doc
          .getElementsByClassName("rating-header text-center")[0]
          .children[3]
          .firstChild
          .toString();
      var url = doc
          .getElementsByClassName("user-details-container plr10")[0]
          .children[0]
          .children[0]
          .attributes["src"];
      return Codechef(
          handle: handle,
          imageurl: "https://s3.amazonaws.com/codechef_shared" + url,
          rating: int.parse(currrating.substring(1, currrating.length - 1)),
          maxrating: int.parse(maxrating.substring(16, maxrating.length - 2)));
    } else {
      print(response.statusCode);
    }
  }
}
