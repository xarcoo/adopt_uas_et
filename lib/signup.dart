import 'dart:convert';

import 'package:adopt_uas/login.dart';
import 'package:flutter/material.dart';
import 'package:adopt_uas/main.dart';
import 'package:http/http.dart' as http;

String _user_name = "";
String _user_password = "";
String error_login = "Insert your username and password";

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  void doSignup() async {
    final response = await http.post(
      Uri.parse("https://ubaya.me/flutter/160421050/uas/new_user.php"),
      body: {'user_name': _user_name, 'user_password': _user_password},
    );

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        setState(() {
          error_login = "Insert your username and password";
        });
        Login();
      } else {
        setState(() {
          error_login = "Registration Error";
        });
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        height: 300,
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            border: Border.all(width: 1),
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 20)]),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                onChanged: (v) {
                  _user_name = v;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter username'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  _user_password = value;
                },
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(error_login),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                height: 50,
                width: 300,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
                  onPressed: () {
                    doSignup();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xd0bcff)),
                  ),
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
