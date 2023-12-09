import 'package:bookbyte_apps/custPages/loginPage.dart'; 
import 'package:flutter/material.dart';
import 'package:bookbyte_apps/classPages/user.dart';

class MainPage extends StatefulWidget {
  final User userData;
  const MainPage({super.key, required this.userData});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
int indexCurrent = 0;
String title = "";

@override
    Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text("Welcome To 3B's Bookbyte Store")),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: indexCurrent,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_rounded),
            label: "Account",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket_outlined),
            label: "Shop",
          ),
        ],
      ),
    );
}

  void onTabTapped(int indexs) {
    setState(() {
      indexCurrent = indexs;
      if (indexCurrent == 0) {
        title = "Home";
        
      }
      if (indexCurrent == 1) {
        title = "Account";
        {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const LoginPg()));
        };
      }
      if (indexCurrent == 2) {
        title = "Shop";
      }
    });
  }
}
