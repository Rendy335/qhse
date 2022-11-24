// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/url.dart';
import 'package:http/http.dart' as http;
import 'home.dart';

class Qhse extends StatefulWidget {
  final int toilet;
  final String nama;
  const Qhse({Key? key, required this.toilet, required this.nama})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _QhseState createState() => _QhseState(this.toilet);
}

class _QhseState extends State<Qhse> {
  int? toilet;
  _QhseState(this.toilet);
  String _searchText = ""; //searchname
  List<String> filteredNames = []; // names filtered by search text
  Icon _searchIcon = new Icon(Icons.search);
//  List<Map<String, dynamic>> _foundUsers = [];
  List? data;

  List? _foundUsers;
  late String ctt;
  late String ctt2;
  List<String> selections = [];
  final TextEditingController _filter = new TextEditingController();

  final _catatan = TextEditingController();

  final _catatan2 = TextEditingController();
  // late TextEditingController? _catatan;

  void getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? idKan = pref.getString("id_kantor");
    var res = await http.get(
      "https://api.bplogistics.id/index.php/store/mobil",

      // 'access': 'apickb',
      // 'id_kantor': idKan.toString(),
      // 'id_toilet': toilet.toString(),
      // // 'nama': "${widget.nama}".toString()
      // 'nama': '${widget.nama}'
    );
    var content = json.decode(res.body);

    // final Map<String, dynamic> profileMap = new Map();
    // data?.forEach((data) {
    //   profileMap[data['jenis']] = data;
    // });

    // data = profileMap.values.toList();
    // var content = json.decode(res.body);
    // List<dynamic> uniquelist =
    //     data!.where((data) => content.add(data)).toList();
    setState(() {
      data = content['data'];
      ctt = content['catatan'] ?? '';
      _foundUsers = data;

      _catatan.value = TextEditingValue(text: ctt);
    });
  }

  void _kirim() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? idKan = pref.getString("id_kantor");
    String? idUsr = pref.getString("id_user");

    final respose = await http.post(urlAPI + phpins2, body: {
      'access': 'apickb',
      'id_kantor': idKan.toString(),
      'id_toilet': toilet.toString(),
      'platmobil': selections.toString(),
      'id_user': idUsr.toString(),
      'catatan': _catatan.value.text,
    });
    var res = json.decode(respose.body);
    if (res['message'] == 200) {
      Get.dialog(AlertDialog(
        title: const Text('Informasi'),
        content:
            const Text('Data berhasil disimpan, dan dalam proses verifikasi'),
        actions: [
          ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => home(),
                  )),
              child: const Text('Selesai'))
        ],
      ));
    } else {
      Get.dialog(AlertDialog(
        title: const Text('Informasi'),
        content: const Text('Data Gagal disimpan!'),
        actions: [
          ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => home(),
                  )),
              child: const Text('Selesai'))
        ],
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _foundUsers = data;
    this.getData();
  }

  void firstMethod() {
    final removeDuplicates = _foundUsers?.toSet().toList();
    print(removeDuplicates);
  }

  void _runFilter(String enteredKeyword) {
    // List<Map<String, dynamic>> results = [];
    List? results;

    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = data!.toSet().toList();
    } else {
      results = data!
          .toSet()
          .toList()
          .where((user) => user["jenis"]
              .toUpperCase()
              .contains(enteredKeyword.toUpperCase()))
          .toSet()
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" ${widget.nama}"),
        actions: <Widget>[
          ElevatedButton(
              onPressed: () => _kirim(),
              child: const Text(
                'SIMPAN',
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                  labelText: 'Search', suffixIcon: Icon(Icons.search)),
            ),
          ),
          Expanded(
            child: _foundUsers!.toSet().toList().isNotEmpty
                ? ListView.builder(
                    itemCount: _foundUsers!.length,
                    itemBuilder: (context, i) {
                      return Card(
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              CheckboxListTile(
                                value: selections
                                    .contains(_foundUsers![i]['jenis']),
                                onChanged: (val) {
                                  _onCategorySelected(
                                      val, _foundUsers![i]['jenis']);
                                },
                                title: Text(_foundUsers?[i]["jenis"]),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                : const Text(
                    'No results found',
                    style: TextStyle(fontSize: 24),
                  ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Catatan : '),
          ),
          Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _catatan,
              maxLines: 3,
              decoration: const InputDecoration.collapsed(
                  hintText: "Masukan Catatan Kebersihan disini."),
            ),
          ))
        ],
      ),
    );
    //
  }

  void _onCategorySelected(bool? selected, categoryId) {
    if (selected == true) {
      setState(() {
        data?.add(categoryId);
        selections.add((categoryId.toString()));
      });
    } else {
      setState(() {
        data?.remove(categoryId);
        selections.remove((categoryId.toString()));
      });
    }
  }
}
