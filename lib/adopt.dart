import 'dart:convert';

import 'package:adopt_uas/class/Pets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

List<String> cmb = ['Sedang Propose', 'Propose Ditolak', 'Propose Disetujui'];

class Adopt extends StatefulWidget {
  String username;
  Adopt({super.key, required this.username});
  @override
  State<StatefulWidget> createState() {
    return AdoptState();
  }
}

class AdoptState extends State<Adopt> {
  String cmbVal = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adopt"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: DropdownButton<String>(
                  dropdownColor: Colors.grey[100],
                  hint: Text("Laporan Adopt"),
                  isDense: false,
                  onChanged: (value) {
                    setState(() {
                      cmbVal = value!;
                    });
                  },
                  items: cmb.map<DropdownMenuItem<String>>(
                    (String val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    },
                  ).toList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  cmbVal,
                  style: const TextStyle(fontSize: 25),
                ),
              ),
              cmbVal == "Sedang Propose"
                  ? Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        height: MediaQuery.of(context).size.height - 200,
                        child: FutureBuilder(
                          future: fetchSedang(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return Text("Error! ${snapshot.error}");
                              } else if (snapshot.hasData) {
                                return DaftarPet(snapshot.data.toString());
                              } else {
                                return const Text("No data");
                              }
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                    )
                  : cmbVal == "Propose Ditolak"
                      ? Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            height: MediaQuery.of(context).size.height - 200,
                            child: FutureBuilder(
                              future: fetchTolak(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasError) {
                                    return Text("Error! ${snapshot.error}");
                                  } else if (snapshot.hasData) {
                                    return DaftarPet(snapshot.data.toString());
                                  } else {
                                    return const Text("No data");
                                  }
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ),
                        )
                      : cmbVal == "Propose Disetujui"
                          ? Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height - 200,
                                child: FutureBuilder(
                                  future: fetchSetuju(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasError) {
                                        return Text("Error! ${snapshot.error}");
                                      } else if (snapshot.hasData) {
                                        return DaftarPet(
                                            snapshot.data.toString());
                                      } else {
                                        return const Text("No data");
                                      }
                                    } else {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                  },
                                ),
                              ),
                            )
                          : Text(""),
              //   ],
              // ),
            ],
          ),
        ),
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
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<String> fetchSedang() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421050/uas/adopt_sedang.php"),
        body: {'username': widget.username.toString()});

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to read API");
    }
  }

  Future<String> fetchTolak() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421050/uas/adopt_tolak.php"),
        body: {'username': widget.username.toString()});

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to read API");
    }
  }

  Future<String> fetchSetuju() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421050/uas/adopt_setuju.php"),
        body: {'username': widget.username.toString()});

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to read API");
    }
  }
}
