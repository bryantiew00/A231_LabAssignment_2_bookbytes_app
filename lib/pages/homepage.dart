import '../buyer/user.dart';
import 'package:flutter/material.dart';

class BookListPage extends StatefulWidget {
  final User user;
  const BookListPage({super.key, required this.user});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  late double screenWidth, screenHeight;
  // ignore: prefer_typing_uninitialized_variables
  String title = "";

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "3Bs Book List",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: 60,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              searchDialog();
            },
            icon: const Icon(Icons.search),
          ),
          //IconButton(
          //  onPressed: () {
          //    Navigator.push(
          //      context,
          //      MaterialPageRoute(
          //        builder: (content) => CartPage(userdata: widget.user),
          //      ),
          //    );
          //  },
          //  icon: const Icon(Icons.add_shopping_cart),
          //)
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey,
            height: 1.0,
            child: const Text("No Data"),
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

  searchDialog() {
    TextEditingController searchctlr = TextEditingController();
    title = searchctlr.text;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Search Title",
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
                onPressed: () {},
                child: const Text("Search"),
              )
            ],
          ),
        );
      },
    );
  }
}
