import 'package:adopt_uas/Home.dart';
import 'package:adopt_uas/adopt.dart';
import 'package:adopt_uas/browse.dart';
import 'package:adopt_uas/login.dart';
import 'package:adopt_uas/offer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String active_user = "";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '') {
      runApp(LoginForm());
    } else {
      active_user = result;
      runApp(MainApp());
    }
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'home': (context) => Home(),
        'browse': (context) => Browse(
              username: active_user,
            ),
        'offer': (context) => Offer(
              username: active_user,
            ),
        'adopt': (context) => Adopt(
              username: active_user,
            ),
        'login': (context) => LoginForm(),
      },
      home: const HomePage(title: 'Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Home'),
      ),
      body: Home(),
      drawer: Drawer(
        elevation: 16.0,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(active_user),
                accountEmail: Text(active_user),
              ),
              ListTile(
                title: new Text("Browse Pet"),
                leading: new Icon(Icons.search_outlined),
                onTap: () {
                  Navigator.popAndPushNamed(
                    context,
                    'browse',
                  );
                },
              ),
              ListTile(
                title: new Text("Offer Pet"),
                leading: new Icon(Icons.assignment_ind_outlined),
                onTap: () {
                  Navigator.popAndPushNamed(
                    context,
                    'offer',
                  );
                },
              ),
              ListTile(
                title: new Text("Adopt Pet"),
                leading: new Icon(Icons.card_giftcard_outlined),
                onTap: () {
                  Navigator.popAndPushNamed(
                    context,
                    'adopt',
                  );
                },
              ),
              Divider(
                height: 10,
              ),
              ListTile(
                title: new Text(active_user != "" ? "Logout" : "Login"),
                leading:
                    new Icon(active_user != "" ? Icons.logout : Icons.login),
                onTap: () {
                  if (active_user != "") {
                    doLogout();
                  } else {
                    Navigator.popAndPushNamed(context, 'login');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_name = prefs.getString("user_name") ?? '';
  return user_name;
}

void doLogout() async {
  final prefs = await SharedPreferences.getInstance();
  active_user = "";
  prefs.remove("user_name");
  main();
}
