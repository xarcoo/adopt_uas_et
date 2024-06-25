import 'package:flutter/material.dart';

class Browse extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BrowseState();
  }
}

class BrowseState extends State<Browse> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Browse"),
      ),
      body: Center(
        child: Text("This is Browse."),
      ),
    );
  }
}
