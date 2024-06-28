import 'dart:convert';

import 'package:adopt_uas/class/Pets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Decision extends StatefulWidget {
  int petID;
  Decision({super.key, required this.petID});
  @override
  State<StatefulWidget> createState() {
    return DecisionState();
  }
}

class DecisionState extends State<Decision> {
  Pets? _pets;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Propose"),
      ),
      body: Center(
        child: Text("This is Propose."),
      ),
    );
  }
}
