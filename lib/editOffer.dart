import 'dart:convert';
import 'dart:io';

import 'package:adopt_uas/class/Pets.dart';
import 'package:adopt_uas/class/Types.dart';
import 'package:adopt_uas/offer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditOffer extends StatefulWidget {
  int petID;
  EditOffer({super.key, required this.petID});

  @override
  State<EditOffer> createState() => _EditOfferState();
}

class _EditOfferState extends State<EditOffer> {
  final _formKey = GlobalKey<FormState>();
  int _jenis = 1;
  TextEditingController _nama = TextEditingController();
  TextEditingController _keterangan = TextEditingController();
  File? _image;
  File? _imageProses;

  Widget comboType = Text("Jenis Hewan");

  void generateComboType() {
    List<Types> types;
    var data = daftarType();
    data.then((value) {
      types = List<Types>.from(value.map((i) {
        return Types.fromJson(i);
      }));
      setState(() {
        comboType = DropdownButton(
            dropdownColor: Colors.grey[100],
            hint: Text("Jenis Hewan"),
            isDense: false,
            items: types.map((type) {
              return DropdownMenuItem(
                child: Column(
                  children: <Widget>[
                    Text(type.name, overflow: TextOverflow.visible),
                  ],
                ),
                value: type.id,
              );
            }).toList(),
            onChanged: (value) {
              _jenis = value!;
            });
      });
    });
  }

  Future<List> daftarType() async {
    Map json;
    final response = await http
        .post(Uri.parse("https://ubaya.me/flutter/160421050/uas/typelist.php"));

    if (response.statusCode == 200) {
      print(response.body);
      json = jsonDecode(response.body);
      return json['data'];
    } else {
      throw Exception('Failed to read API');
    }
  }

  @override
  void initState() {
    super.initState();
    bacaData();

    generateComboType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Offer"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(10), child: comboType),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                decoration: InputDecoration(labelText: "Nama Hewan"),
                onChanged: (value) {
                  pet.nama = value;
                },
                controller: _nama,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                decoration: InputDecoration(labelText: "Keterangan Hewan"),
                onChanged: (value) {
                  pet.keterangan = value;
                },
                controller: _keterangan,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Keterangan hewan tidak boleh kosong";
                  }
                  return null;
                },
              ),
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: _imageProses != null
                      ? Image.file(
                          _imageProses!,
                          scale: 3,
                        )
                      : Image.network(
                          "https://ubaya.me/flutter/160421050/uas/images/${widget.petID}.jpg",
                          scale: 3,
                        ),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState != null &&
                      !_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Harap Isian diperbaiki')));
                  }
                  submit();
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String user_name = "";

  void checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    user_name = prefs.getString("user_name") ?? '';
  }

  void submit() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421050/uas/edit_pet.php"),
        body: {
          'jenis': _jenis.toString(),
          'nama': pet.nama,
          'keterangan': pet.keterangan,
          'id': widget.petID.toString()
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses Mengubah Data')));

        if (_imageProses == null) return;
        List<int> imageBytes = _imageProses!.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        final response2 = await http.post(
          Uri.parse(
              'https://ubaya.me/flutter/160421050/uas/uploadpetphoto.php'),
          body: {
            'id': widget.petID.toString(),
            'image': base64Image,
          },
        );
        if (response2.statusCode == 200) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response2.body),
            ),
          );
          Navigator.of(context).pop();
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Offer(
              username: user_name,
            ),
          ),
        );
      }
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              color: Colors.white,
              child: new Wrap(
                children: <Widget>[
                  ListTile(
                      tileColor: Colors.white,
                      leading: Icon(Icons.photo_library),
                      title: Text('Galeri'),
                      onTap: () {
                        _imgGaleri();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: new Text('Kamera'),
                    onTap: () {
                      _imgKamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgGaleri() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 600,
        maxWidth: 600);
    if (image == null) return;
    setState(() {
      _image = File(image.path);
      prosesFoto();
    });
  }

  _imgKamera() async {
    final picker = ImagePicker();
    final image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 20);
    if (image == null) return;
    setState(() {
      _image = File(image.path);
      prosesFoto();
    });
  }

  void prosesFoto() {
    Future<Directory?> extDir = getTemporaryDirectory();
    extDir.then((value) {
      String _timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String filePath = '${value?.path}/$_timestamp.jpg';
      _imageProses = File(filePath);
      img.Image? temp = img.readJpg(_image!.readAsBytesSync());
      img.Image temp2 = img.copyResize(temp!, width: 480, height: 640);
      setState(() {
        _imageProses?.writeAsBytesSync(img.writeJpg(temp2));
      });
    });
  }

  late Pets pet;
  Future<String> fetchData() async {
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
    fetchData().then((value) {
      Map json = jsonDecode(value);
      pet = Pets.fromJson(json['data']);
      setState(() {
        _nama.text = pet.nama;
        _jenis = pet.type_id;
        _keterangan.text = pet.keterangan;
      });
    });
  }
}
