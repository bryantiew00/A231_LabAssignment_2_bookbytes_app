import 'dart:convert';

import 'package:bookbyte_apps/custPages/loginPage.dart';
import 'package:bookbyte_apps/classPages/configuration.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class RegistrationPg extends StatefulWidget {
  const RegistrationPg({super.key});

  @override
  State<RegistrationPg> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationPg> {
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController phoneEditingController = TextEditingController();
  final TextEditingController password1EditingController = TextEditingController();
  final TextEditingController password2EditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String Eula = "";
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
          Image.asset('assets/profile.png',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.topCenter),
       
       SingleChildScrollView(
          child: Center(
            heightFactor: 1.9,
              child : Container( 
                padding: const EdgeInsets.all(15.8),
                child: Form(
                  key: _formKey,
                  child: Card(
                    elevation: 9,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 6, 17, 6),
                      child: Column(children: [
                        const Text(
                          "Register",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          controller: nameEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            icon: Icon(Icons.person),
                          ),
                          validator: (val) => val!.isEmpty || (val.length < 3)
                              ? "name must be longer than 4"
                              : null,
                        ),
                        TextFormField(
                          controller: emailEditingController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            icon: Icon(Icons.email),
                          ),
                          validator: (val) => val!.isEmpty ||
                                  !val.contains("@") ||
                                  !val.contains(".")
                              ? "enter a valid email"
                              : null,
                        ),
                        TextFormField(
                          controller: password1EditingController,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            icon: Icon(Icons.lock),
                          ),
                          validator: (val) => validatePassword(val.toString()),
                        ),
                        TextFormField(
                          controller: password2EditingController,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Re-enter Password',
                            icon: Icon(Icons.lock),
                          ),
                          validator: (val) => validatePassword(val.toString()),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Checkbox(
                              value: _isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked = value!;
                                });
                              },
                            ),
                            GestureDetector(
                                onTap: EULA,
            
                                child: const Text("I have read term & condition")),
                            
                               CircleAvatar(
                              radius: 30,
                              backgroundColor: const Color.fromARGB(255, 69, 109, 218),
                              child: IconButton(
                                  color: Colors.white,
                                  onPressed: () {
                                      _registerUserDialog();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward,
                                  )),
                            )
                                
                          ],
                        )
                      ]),
                    ),
                  ),
                ),
              ),
          ),
        )
      ],
      ),
    );
  }

  String? validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  void _registerUserDialog() {
    String pass1 = password1EditingController.text;
    String pass2 = password2EditingController.text;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Accept T&C"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (pass1 != pass2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Password Different!!"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          title: const Text(
            "Create a new account?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure want to create account?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                register();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Registration Not Been Received"),
                  backgroundColor: Colors.red,
                ));
              },
            ),
          ],
        );
      },
    );
  }

  loadingEula() async {
    Eula = await rootBundle.loadString('assets/EULA.txt');
  }

  void EULA() {
    loadingEula();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "READ EULA",
            style: TextStyle(),
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                      child: RichText(
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        style: const TextStyle(
                            fontSize: 12.0, color: Colors.black),
                        text: loadingEula()),
                  )),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void register() {
    String name = nameEditingController.text;
    String email = emailEditingController.text;
    String pass = password1EditingController.text;

    http.post(
        Uri.parse("${Config.server}/bookbyte_apps/bookbytes/php/register.php"),
        body: {
          "name": name,
          "email": email,
          "password": pass
        }).then((response) {
        print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registration Was Successful"),
            backgroundColor: Colors.green,
          ));
          Navigator.push(context,
              MaterialPageRoute(builder: (content) => const LoginPg()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registration Was Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}