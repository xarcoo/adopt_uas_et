import 'dart:convert';

import 'package:adopt_uas/class/Pets.dart';
import 'package:adopt_uas/decision.dart';
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

  Widget DaftarPet(data){
    List<Pets> listPet2 = [];
    Map json = jsonDecode(data);
    for(var pets in json['data']){
      Pets pet = Pets.fromJson(pets);
      listPet2.add(pet);
    }
    return ListView.builder(
      itemCount: listPet2.length,
      itemBuilder: (BuildContext context, int index) {

        if(listPet2[index].adopter != null){
          adopter = ", adopter = " + listPet2[index].adopter.toString();
        }

        return new Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Image.network(listPet2[index].foto),
                title: Text(listPet2[index].jenis),
                subtitle: Text(listPet2[index].keterangan + "\n" + "likes: " + listPet2[index].likes.toString() + adopter),
                trailing: listPet2[index].is_adopt == 0
                    ? ElevatedButton(
                  child: Text('Decision'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Decision(petID: listPet2[index].id,),
                      ),
                    );
                  },
                ) // Example trailing widget
                    : null,
              )
            ],
          ),
        );
      },
    );
  }

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421050/uas/pet_list_user.php"),
        body: {'owner': widget.username.toString()}
    );

    if(response.statusCode == 200){
      return response.body;
    }
    else{
      throw Exception("Failed to read API");
    }
  }

  newOffers() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => newOffer(),
        ),
      );
    });
  }
}
