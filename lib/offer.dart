import 'dart:convert';

import 'package:adopt_uas/class/Pets.dart';
import 'package:adopt_uas/decision.dart';
import 'package:adopt_uas/editOffer.dart';
import 'package:adopt_uas/main.dart';
import 'package:adopt_uas/newOffer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Offer extends StatefulWidget {
  String username;
  Offer({super.key, required this.username});
  @override
  State<StatefulWidget> createState() {
    return OfferState();
  }
}

class OfferState extends State<Offer> {
  Pets? _pets;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Offer"),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: newOffers,
        tooltip: 'New Offer',
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Pets> pets = [];
  String adopter = "";

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
        if (listPet2[index].adopter != null) {
          adopter = ", Adopter: " + listPet2[index].adopter.toString();
        }

        return Card(
          child: Padding(
            padding: EdgeInsets.only(top: 5),
            child: Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Image.network(
                        "https://ubaya.me/flutter/160421050/uas/images/${listPet2[index].id}.jpg"),
                    title: Text(listPet2[index].nama.toString()),
                    subtitle: Text(
                        "${listPet2[index].keterangan}\nProposer: ${listPet2[index].likes}$adopter"),
                    trailing: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GenerateBtnDec(data, index),
                          GenerateBtnEdit(data, index),
                          GenerateBtnDelete(data, index)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget GenerateBtnDec(data, index) {
    List<Pets> listPet2 = [];
    Map json = jsonDecode(data);
    for (var pets in json['data']) {
      Pets pet = Pets.fromJson(pets);
      listPet2.add(pet);
    }
    if (listPet2[index].is_adopt == 0) {
      return ElevatedButton(
        child: Text('Decision'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Decision(
                petID: listPet2[index].id,
              ),
            ),
          ).then(onGoBack);
        },
      );
    } else {
      return Text("");
    }
  }

  Widget GenerateBtnEdit(data, index) {
    List<Pets> listPet2 = [];
    Map json = jsonDecode(data);
    for (var pets in json['data']) {
      Pets pet = Pets.fromJson(pets);
      listPet2.add(pet);
    }
    if (listPet2[index].likes == 0) {
      return ElevatedButton(
        child: Text('Edit'),
        onPressed: () {
          edit(listPet2, index);
        },
      );
    } else {
      return Text("");
    }
  }

  void edit(List<Pets> listPet2, index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditOffer(
          petID: listPet2[index].id,
        ),
      ),
    ).then(onGoBack);
  }

  Widget GenerateBtnDelete(data, index) {
    List<Pets> listPet2 = [];
    Map json = jsonDecode(data);
    for (var pets in json['data']) {
      Pets pet = Pets.fromJson(pets);
      listPet2.add(pet);
    }
    if (listPet2[index].likes == 0) {
      return new ElevatedButton(
        child: Text('Delete'),
        onPressed: () {
          delete(listPet2, index);
        },
      );
    } else {
      return Text("");
    }
  }

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421050/uas/pet_list_user.php"),
        body: {'owner': widget.username.toString()});

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

  newOffers() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewOffer(username: widget.username),
        ),
      ).then(onGoBack);
    });
  }

  void delete(List<Pets> listPet2, id) async {
    final response = await http.post(
      Uri.parse("https://ubaya.me/flutter/160421050/uas/delete_pet.php"),
      body: {'id': listPet2[id].id.toString()},
    );
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses Menghapus Data')));

        // bacaData();
        Navigator.pop(context);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => MainApp()),
        // );
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error')));
      throw Exception('Failed to read API');
    }
  }
}
