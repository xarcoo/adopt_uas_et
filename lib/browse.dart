import 'dart:async';
import 'dart:convert';

import 'package:adopt_uas/propose.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'class/Pets.dart';

class Browse extends StatefulWidget {
  String username;
  Browse({super.key, required this.username});
  @override
  State<StatefulWidget> createState() {
    return BrowseState();
  }
}

class BrowseState extends State<Browse> {
  Pets? _pets;
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
        body: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 200,
              child: FutureBuilder(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text("Error! ${snapshot.error}");
                    } else if (snapshot.hasData) {
                      return DaftarPet(snapshot.data.toString());
                    } else {
                      return const Text("No data");
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )
          ],
        ));
  }

  List<Pets> pets = [];
  String _txtCari = "";

  Widget DaftarPet(data) {
    List<Pets> listPet2 = [];
    Map json = jsonDecode(data);
    for (var pets in json['data']) {
      Pets pet = Pets.fromJson(pets);
      listPet2.add(pet);
    }
    return ListView.builder(
      itemCount: listPet2.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                  leading: Image.network(
                      "https://ubaya.me/flutter/160421050/uas/images/${listPet2[index].id}.jpg"),
                  title: Text(listPet2[index].nama),
                  subtitle: Text(
                      "${listPet2[index].keterangan}\nProposer: ${listPet2[index].likes}"),
                  trailing: ElevatedButton(
                    child: Text('Propose'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Propose(
                            petID: listPet2[index].id,
                            username: widget.username,
                          ),
                        ),
                      ).then(onGoBack);
                      ;
                    },
                  ))
            ],
          ),
        );
      },
    );
  }

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.me/flutter/160421050/uas/pet_list_no_adopt.php"),
        body: {'owner': widget.username});

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to read API");
    }
  }

  Future onGoBack(dynamic value) async {
    setState(() {
      bacaData();
    });
  }

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      _pets = Pets.fromJson(json['data']);
      setState(() {});
    });
  }
}
