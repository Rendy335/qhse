// ignore_for_file: import_of_legacy_library_into_null_safe, unnecessary_this

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/url.dart';
import 'package:http/http.dart' as http;
import 'home.dart';

class Verif extends StatefulWidget {
  final int toilet;
  final String nama;
  final String tgl;
  const Verif(
      {Key? key, required this.toilet, required this.nama, required this.tgl})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VerifState createState() => _VerifState(this.toilet, this.tgl);
}

class _VerifState extends State<Verif> {
  int? toilet;
  String? tgl;
  String? tggl;
  String? petugas;
  String? ctt;
  _VerifState(this.toilet, this.tgl);
  List? data;
  List<int>? selections = [];

  void getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? idKan = pref.getString("id_kantor");
    var res = await http.post(urlAPI + phpverif, body: {
      'access': 'apickb',
      'id_kantor': idKan.toString(),
      'id_toilet': toilet.toString(),
      'tgl': tgl
    });
    var content = json.decode(res.body);
    setState(() {
      petugas = content['petugas'];
      tggl = content['createdon'];
      data = content['verif'];
      ctt = content['catatan'];
      if (content['message'] == 404) {
        Get.dialog(AlertDialog(
          title: Text('Informasi'),
          content: Text('Maaf, data tidak ditemukan!'),
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
    });
  }

  void _kirim() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? idUsr = pref.getString("id_user");
    final respose = await http.post(urlAPI + phpinsverif, body: {
      'access': 'apickb',
      'idk': selections.toString(),
      'id_user': idUsr
    });
    var listData = jsonDecode(respose.body);
    Get.dialog(AlertDialog(
      title: const Text('Informasi'),
      content: const Text('Data berhasil disimpan.'),
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

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verifikasi  ${widget.nama}"),
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Petugas Kebersihan :  ${petugas}'),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Tanggal : ${tggl}'),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Catatan : $ctt'),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: data?.length,
                itemBuilder: (BuildContext context, int i) {
                  return Card(
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          CheckboxListTile(
                            value: data?[i]['ok'.toString()] == 0.toString()
                                ? data?.contains(data?[i]['id'.toString()])
                                : true,
                            onChanged: (bool? selected) {
                              _onCategorySelected(
                                  selected!, data?[i]["id".toString()]);
                            },
                            title: Text(data?[i]["kegiatan"]),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
    //
  }

  void _onCategorySelected(bool selected, categoryId) {
    if (selected == true) {
      setState(() {
        data?.add(categoryId);
        selections?.add(int.parse(categoryId));
      });
    } else {
      setState(() {
        data?.remove(categoryId);
        selections?.remove(int.parse(categoryId));
      });
    }
  }
}
