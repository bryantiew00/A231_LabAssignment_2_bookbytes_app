// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:bookbyte_apps/custPages/registerPage.dart';
import 'package:bookbyte_apps/classPages/configuration.dart';
import 'package:bookbyte_apps/viewPage/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookbyte_apps/classPages/user.dart';

class LoginPg extends StatefulWidget {
  const LoginPg({super.key});

  @override
  State<LoginPg> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginPg> {
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    loadingPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(126, 136, 46, 215),
      body: Stack(
        children: [
          Image.asset('assets/login.jpeg',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center),
          Container(
            padding: const EdgeInsets.only(left: 40, top: 125),
            child: const Text(
              "Welcome\nto \n 3B's BookBytes",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 36,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.6),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 50, right: 50),
                      child: Column(children: [
                        TextFormField(
                          controller: emailEditingController,
                          style: const TextStyle(color: Colors.black38),
                          decoration: InputDecoration(
                              fillColor: Colors.amberAccent,
                              filled: true,
                              hintText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(23),
                              )),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: passwordEditingController,
                          style: const TextStyle(),
                          obscureText: true,
                          decoration: InputDecoration(
                              fillColor: Colors.blueAccent,
                              filled: true,
                              hintText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(23),
                              )),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(children: [
                          Checkbox(
                            value: _isChecked,
                            onChanged: (bool? value) {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              savenRemoveprefs(value!);
                              setState(() {
                                _isChecked = value;
                              });
                            },
                          ),
                          const Text("Remember Me"),
                        ]),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegistrationPg()));
                              },
                              style: const ButtonStyle(),
                              child: const Text(
                                'Register',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: const Color.fromARGB(255, 58, 230, 178),
                              child: IconButton(
                                  color: const Color.fromARGB(255, 237, 52, 52),
                                  onPressed: () {
                                    login();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward,
                                  )),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void login() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    String email = emailEditingController.text;
    String pass = passwordEditingController.text;
    
    http.post(Uri.parse("${Config.server}/bookbytes/php/login.php"),
        body: {"email": email, "password": pass}).then((response) {
     // print(response.statusCode);
     print(response.body);
      if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          //print(data);
          if (data['status'] == "success") {
            User user = User.fromJson(data['data']);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Login Successful"),
              backgroundColor: Colors.green,
            ));
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => MainPage(
                          userData: user,
                        )));

        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed to Login"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }

  void  savenRemoveprefs(bool value) async {
    String email = emailEditingController.text;
    String password = passwordEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save pref
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      await prefs.setBool('remember me', value);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("User Preferences Has Been Stored"),
        backgroundColor: Colors.green,
      ));
    } else {
      //remove pref
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      await prefs.setBool('remember me', false);
      emailEditingController.text = '';
      passwordEditingController.text = '';
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("User Preferences Has Been Deleted"),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> loadingPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    _isChecked = (prefs.getBool('remember me')) ?? false;
    if (_isChecked) {
      emailEditingController.text = email;
      passwordEditingController.text = password;
    }
    setState(() {});
  }
}