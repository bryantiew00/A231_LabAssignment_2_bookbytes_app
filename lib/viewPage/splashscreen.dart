import 'dart:async';
import 'dart:convert';

import 'package:bookbyte_apps/classPages/configuration.dart';
import 'package:bookbyte_apps/viewPage/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:bookbyte_apps/classPages/user.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashPgState();
}

class _SplashPgState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () => checkandlogin());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
        children: [
        Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/splash.png'),
                    fit: BoxFit.contain))),
        const Padding(
          padding: EdgeInsets.fromLTRB(50, 30, 50, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "3B's BookBytes Store",
                style: TextStyle(
                    fontSize: 23,
                    color: Colors.amberAccent,
                    fontWeight: FontWeight.bold),
              ),
              CircularProgressIndicator(),
              Text(
                "Version 0.0.1",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black38,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        )
      ],
     );
  }

 checkandlogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _email = (prefs.getString('email')) ?? '';
    String _password = (prefs.getString('pass')) ?? '';
    bool remember = (prefs.getBool('rem')) ?? false;

    if (remember) {
      http.post(
          Uri.parse("${Config.server}/bookbytes/php/login.php"),
          body: {"email": _email, "password": _password}).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['status'] == "success") {
            User user = User.fromJson(data['data']);
            Timer(
                const Duration(seconds: 4),
                () => Navigator.pushReplacement(
                    context, MaterialPageRoute(
                        builder: (content) => MainPage(
                              userData: user,
                            ))));
          } else {
            User user = User(
                user_id: "0",
                user_email: "unregistered@email.com",
                user_name: "Unregistered",
                user_datereg: "",
                user_password: "",
                );
            Timer(
                const Duration(seconds: 4),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainPage(
                              userData: user,
                            ))));
          }
        }
      });
    } else {
      User user = User(
          user_id: "0",
          user_email: "unregistered@email.com",
          user_name: "Unregistered",
          user_datereg: "",
          user_password: "",
        );
      Timer(
          const Duration(seconds: 4),
          () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (content) => MainPage(
                        userData: user,
                      ))));
    }
  }
}