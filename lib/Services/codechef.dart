import 'package:Portfolio/modals/codechef.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class CodechefServices {
  String handle;
  CodechefServices({this.handle});

  Future<Codechef> getInfo() async {
    String currrating;
    String maxrating;
    var url;
    final http.Response response =
        await http.get("https://www.codechef.com/users/$handle");
    if (response.statusCode == 200) {
      final doc = parse(response.body);
      final currratinglist = doc.getElementsByClassName("rating-number");
      if (currratinglist.length>0)
        currrating = currratinglist[0].firstChild.toString();
      final maxratinglist =
          doc.getElementsByClassName("rating-header text-center");
      if (maxratinglist.length>0)
        maxrating = maxratinglist[0].children[3].firstChild.toString();
      final urllist =
          doc.getElementsByClassName("user-details-container plr10");
      if (urllist.length>0)
        url = urllist[0].children[0].children[0].attributes["src"];
      if (currrating != null && maxrating != null && url != null)
        return Codechef(
            handle: handle,
            imageurl: "https://s3.amazonaws.com/codechef_shared" + url,
            rating: int.parse(currrating.substring(1, currrating.length - 1)),
            maxrating:
                int.parse(maxrating.substring(16, maxrating.length - 2)));
    } else {
      print(response.statusCode);
    }
  }
}
