import 'dart:convert';

import 'package:flutter/cupertino.dart';
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
    bacaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Decision"),
      ),
      body: ListView(children: <Widget>[
        tampilDataPet(),
      ],)
    );
  }

  Future<String> fetchDataPet() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421050/uas/detail_pet.php"),
        body: {'id': widget.petID.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    fetchDataPet().then((value) {
      Map json = jsonDecode(value);
      _pets = Pets.fromJson(json['data']);
      setState(() {});
    });
  }

  Widget tampilDataPet(){
    if(_pets == null){
      return const CircularProgressIndicator();
    }
    return Column(
      children: [
        Card(
          elevation: 10,
          margin: EdgeInsets.all(10),
          child: Column(children: <Widget>[
            Text(_pets!.nama.toString(), style: const TextStyle(fontSize: 25)),
            Text(_pets!.jenis.toString(), style: const TextStyle(fontSize: 15)),
            Image.network(_pets!.foto, scale: 5,),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(_pets!.keterangan),
            ),
          ],),
        ),
        Padding(
            padding: EdgeInsets.all(10),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: _pets?.user_tertarik?.length,
              itemBuilder: (BuildContext cnxt, int index) {
                return new Card(
                  margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text(_pets?.user_tertarik?[index]['username']),
                        trailing: ElevatedButton(
                          child: Text("Choose Adopter"),
                          onPressed: () {
                            insertAdopter(_pets?.user_tertarik?[index]['username']);
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ],
                  ),
                );
              }
          ),
        )
      ],
    );
  }

  Future<String> insertAdopter(adopter) async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421050/uas/insert_adopter.php"),
        body: {'id': widget.petID.toString(), 'adopter': adopter});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }
}
