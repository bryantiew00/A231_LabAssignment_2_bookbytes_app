import 'dart:convert';
import 'dart:developer';
import 'package:bookbyte/buyer/user.dart';
import 'package:bookbyte/backend/my_server_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  final User userdata;
  const MainPage({super.key, required this.userdata});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Book> bookList = <Book>[];
  late double screenWidth, screenHeight;
  int numpage = 1;
  int curpage = 1;
  int numresult = 0;

  dynamic color;
  String title = "";

  @override
  void initState() {
    super.initState();
    books(title);
  }

  int axiscount = 2;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(backgroundImage: AssetImage('assets/images/books.jpg')),
              Text(
                "3Bs Bookbyte",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 30,
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.8),
            child: Container(
              color: Colors.grey,
              height: 1.0,
            ),
          )),
        );
  }


  String truncateString(String str) {
    if (str.length > 20) {
      str = str.substring(0, 20);
      return "$str...";
    } else {
      return str;
    }
  }

  void books(String title) {
    http.get(
      Uri.parse(
          "${MyServerConfig.server}bookbytes/php/books.php?title=$title&pageno=$curpage"),
    )
        .then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        log(response.body);
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          bookList.clear();
          data['data']['books'].forEach((v) {
            bookList.add(Book.fromJson(v));
          });
          numpage = int.parse(data['numpage'].toString());
          numresult = int.parse(data['numberresult'].toString());
        } else {
          //if no status failed
        }
      }
      setState(() {});
    });
  }

  void showSearchDialog() {
    TextEditingController searchctlr = TextEditingController();
    title = searchctlr.text;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text(
              "Search",
              style: TextStyle(),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: searchctlr,
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    books(searchctlr.text);
                  },
                  child: const Text("Search"),
                )
              ],
            ));
      },
    );
  }
}
