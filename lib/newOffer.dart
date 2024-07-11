import 'dart:convert';
import 'dart:io';

import 'package:adopt_uas/class/Types.dart';
import 'package:adopt_uas/offer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class NewOffer extends StatefulWidget {
  String username;
  NewOffer({super.key, required this.username});

  @override
  State<NewOffer> createState() => _NewOfferState();
}

class _NewOfferState extends State<NewOffer> {
  final _formKey = GlobalKey<FormState>();
  int _jenis = 1;
  String _nama = "";
  String _keterangan = "";
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
          },
        );
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

    generateComboType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Offer"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: comboType,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                decoration: InputDecoration(labelText: "Nama Hewan"),
                onChanged: (value) {
                  _nama = value;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                decoration: InputDecoration(labelText: "Keterangan Hewan"),
                onChanged: (value) {
                  _keterangan = value;
                },
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
                          "https://ubaya.me/blank.jpg",
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
                  } else {
                    submit();
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submit() async {
    final response = await http.post(
      Uri.parse("https://ubaya.me/flutter/160421050/uas/new_pet.php"),
      body: {
        'jenis': _jenis.toString(),
        'nama': _nama,
        'keterangan': _keterangan,
        'owner': widget.username
      },
    );
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      String id = json['id'].toString();
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses Menambah Data')));

        if (_imageProses == null) return;
        List<int> imageBytes = _imageProses!.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);

        final response2 = await http.post(
          Uri.parse(
              'https://ubaya.me/flutter/160421050/uas/uploadpetphoto.php'),
          body: {
            'id': id,
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
              username: widget.username,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("${_jenis}, ${_nama}, ${_keterangan}, ${widget.username}"),
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
}
