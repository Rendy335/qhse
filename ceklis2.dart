// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/url.dart';
import 'package:http/http.dart' as http;
import 'home.dart';

class Ceklis2 extends StatefulWidget {
  final int toilet;
  final String nama;

  const Ceklis2({Key? key, required this.toilet, required this.nama})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _Ceklis2State createState() => _Ceklis2State(this.toilet);
}

class _Ceklis2State extends State<Ceklis2> {
  int? toilet;
  bool isLoading = false;
  _Ceklis2State(this.toilet);
  List? data;
  late String ctt;
  List<int> selections = [];

  final _catatan = TextEditingController();
  // late TextEditingController? _catatan;

  void getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? idKan = pref.getString("id_kantor");
    var res = await http.post(urlAPI + phpceklis2, body: {
      'access': 'apickb',
      'id_kantor': idKan.toString(),
      'id_toilet': toilet.toString(),
    });
    var content = json.decode(res.body);
    setState(() {
      data = content['ceklis'];
      ctt = content['catatan'] ?? '';
      _catatan.value = TextEditingValue(text: ctt);
    });
  }

  void _kirim() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? idKan = pref.getString("id_kantor");
    String? idUsr = pref.getString("id_user");

    final respose = await http.post(urlAPI + phpins, body: {
      'access': 'apickb',
      'id_kantor': idKan.toString(),
      'id_toilet': toilet.toString(),
      'idk': selections.toString(),
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
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checklist ${widget.nama}"),
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
          Expanded(
              child: data!.isNotEmpty
                  ? ListView.builder(
                      itemCount: data!.length,
                      itemBuilder: (context, int i) {
                        return Card(
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                CheckboxListTile(
                                  value: data?[i]['ok'] == 0
                                      ? data?.contains(data?[i]['id'])
                                      : true,
                                  onChanged: (bool? selected) {
                                    _onCategorySelected(
                                        selected!, data?[i]["id"]);
                                  },
                                  title: Text(data?[i]["kegiatan"]),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                  : const Text(
                      'tunggu sebentar',
                      style: TextStyle(fontSize: 25),
                    )),
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

  void _onCategorySelected(bool selected, categoryId) {
    if (selected == true) {
      setState(() {
        data?.add(categoryId);
        selections.add(int.parse(categoryId.toString()));
      });
    } else {
      setState(() {
        data?.remove(categoryId);
        selections.remove(int.parse(categoryId.toString()));
      });
    }
  }
}
