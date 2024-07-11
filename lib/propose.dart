import 'dart:convert';

import 'package:adopt_uas/browse.dart';
import 'package:adopt_uas/class/Pets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Propose extends StatefulWidget {
  int petID;
  String username;
  Propose({super.key, required this.petID, required this.username});
  @override
  State<StatefulWidget> createState() {
    return ProposeState();
  }
}

class ProposeState extends State<Propose> {
  Pets? _pets;
  String keterangan = "";
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
        body: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Keterangan',
                    ),
                    onChanged: (value) {
                      keterangan = value;
                    })),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (keterangan == "") {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Harap Isian diperbaiki')));
                  } else {
                    submit();
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ));
  }

  String user_name = "";

  void checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    user_name = prefs.getString("user_name") ?? '';
  }

  void submit() async {
    checkUser();
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421050/uas/new_propose.php"),
        body: {
          'user_name': user_name,
          'id_pet': widget.petID.toString(),
          'keterangan': keterangan,
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses Menambah Data')));

        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Browse(username: widget.username),
            ),
          );
        });
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error')));
      throw Exception('Failed to read API');
    }
  }
}
