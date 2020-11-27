import 'package:Portfolio/Screens/SearchedDataScreen.dart';
import 'package:Portfolio/Services/database.dart';
import 'package:Portfolio/modals/User.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String username = "";
  List<Map<String, dynamic>> data = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Search User",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
                hintText: "Enter Username",
                labelText: "Enter Username",
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(
                      color: Colors.teal, style: BorderStyle.solid, width: 2),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final alldata = await DatabaseServices().getdata;
                    setState(() {
                      data = alldata.where((element) {
                        return element['Username']
                            .toString()
                            .contains(username);
                      }).toList();
                    });
                  },
                )),
            onChanged: (text) async {
              username = text.toLowerCase();
            },
          ),
          SizedBox(
            height: 10,
          ),
          Column(
              children: List.generate(data.length, (index) {
            return ListTile(
                leading: ClipOval(
                  child: Image.network(
                    data[index]['dpurl'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.fill,
                  ),
                ),
                title: Text(data[index]['Username'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    )),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return SearchedDataScreen(
                      user: User(
                        codeforces: data[index]['Codeforces Handle'],
                        gitHub:data[index]['GitHub Handle'],
                        userName:data[index]['Username'],
                        codechef: data[index]['Codechef Handle'],
                        hackerRank: data[index]['HackerRank Handle'],
                        dpUrl: data[index]['dpurl'],
                        aboutme: data[index]['About Me'],
                        achievements: data[index]['Achievements'],
                      ),
                    );
                  }));
                });
          }))
        ],),
      ));
  }
}
