import 'dart:convert';

import 'package:adopt_uas/signup.dart';
import 'package:flutter/material.dart';
import 'package:adopt_uas/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String _user_name = "";
String _user_password = "";
String error_login = "Insert your username and password";

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOGIN',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  void doLogin() async {
    final response = await http.post(
      Uri.parse("https://ubaya.me/flutter/160421050/uas/login.php"),
      body: {'user_name': _user_name, 'user_password': _user_password},
    );

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("user_name", _user_name);
        setState(() {
          error_login = "Insert your username and password";
        });
        main();
      } else {
        setState(() {
          error_login = "Incorrect username or password";
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
        title: Text('Login'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        height: 380,
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
                    doLogin();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xd0bcff)),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUp()));
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
