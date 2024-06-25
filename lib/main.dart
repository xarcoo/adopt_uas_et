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
    if(result == ''){
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
        home: HomePage(title: 'Home Page')
    );
  }
}

class HomePage extends StatefulWidget{
  const HomePage({
    super.key, required this.title
  });

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  int _currIndex = 0;
  final List<Widget> _screens = [Home(), Browse(), Offer(), Adopt()];
  final List<String> _titles = ["Home", "Browse", "Offer", "Adopt"];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currIndex,
        fixedColor: Colors.red,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                  Icons.home,
                color: Colors.pinkAccent,
              ),
              label: "Home",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: Colors.pinkAccent,
              ),
              label: "Browse"
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.local_offer,
                color: Colors.pinkAccent,
              ),
              label: "Offer"
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_reaction_outlined,
                color: Colors.pinkAccent,
              ),
              label: "Adopt"
          ),
        ],
        onTap: (int index) {
          setState(() {
            _currIndex = index;
          });
        },
      ),
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set  our appbar title.
        title: Text(_titles[_currIndex]),
      ),
      body: _screens[_currIndex]
    );
  }
}

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_name = prefs.getString("user_name") ?? '';
  return user_name;
}