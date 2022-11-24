// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/url.dart';
import 'package:http/http.dart' as http;

class Inspeksi extends StatefulWidget {
  const Inspeksi({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InspeksiState createState() => _InspeksiState();
}

class _InspeksiState extends State<Inspeksi> {
  List? data;
  late TextEditingController nama, nama2;

  List? data3;
  late Future<List<Items3>> future3;
  Items3? _currentItem3;
  late int _idk;

  Future<String> getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? idKantor = pref.getString("id_kantor");
    var res = await http.post('${urlAPI}list_toilet.php',
        body: {'access': 'apickb', 'id_kantor': idKantor});
    setState(() {
      var content = json.decode(res.body);
      data = content['toilet'];
    });
    throw 'error';
  }

  Future<List<Items3>> _getItemsData3() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? idKantor = pref.getString("id_kantor");
    final respose = await http.post(urlAPI + phpListKantor,
        body: {'access': 'apickb', 'id_kantor': idKantor});
    var listData = jsonDecode(respose.body);
    return (listData['kantor'] as List).map((p) => Items3.fromJson(p)).toList();
  }

  @override
  void initState() {
    super.initState();
    getData();
    nama = TextEditingController();
    nama2 = TextEditingController();
    future3 = _getItemsData3();
  }

  void _gagal() {
    Get.dialog(AlertDialog(
        title: const Text('Informasi'),
        content: const Text('Gagal.'),
        actions: [
          ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const Inspeksi(),
                  )),
              child: const Text('Selesai'))
        ]));
  }

  void _berhasil() {
    Get.dialog(AlertDialog(
      title: const Text('Informasi'),
      content: const Text('Berhasil'),
      actions: [
        ElevatedButton(
            onPressed: () =>
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const Inspeksi(),
                )),
            child: const Text('Selesai'))
      ],
    ));
  }

  void _kirim() async {
    final respose = await http.post('${urlAPI}ins_toilet.php', body: {
      'access': 'apickb',
      'nama_toilet': nama.text,
      'id_kantor': _idk.toString()
    });
    var res = json.decode(respose.body);
    if (res['message'] == 200) {
      _berhasil();
    } else {
      _gagal();
    }
  }

  void _updhapus(id) async {
    final respose = await http.post('${urlAPI}updhpstoilet.php', body: {
      'access': 'apickb',
      'aksi': 'hapus',
      'id_toilet': id.toString()
    });
    var res = json.decode(respose.body);
    if (res['message'] == 200) {
      _berhasil();
    } else {
      _gagal();
    }
  }

  void _updkirim(id) async {
    final respose = await http.post('${urlAPI}updhpstoilet.php', body: {
      'access': 'apickb',
      'aksi': 'update',
      'nama': nama2.text,
      'id_toilet': id.toString()
    });
    var res = json.decode(respose.body);
    if (res['message'] == 200) {
      _berhasil();
    } else {
      _gagal();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Toilet"),
        actions: <Widget>[
          ElevatedButton(
              onPressed: () => _tambahToilet(),
              child: const Text(
                'Tambah',
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  // ignore: unnecessary_null_comparison
                  itemCount: data == null ? 0 : data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.all(0.5),
                      child: GestureDetector(
                        onTap: () {
                          _pushToilet(data![index]['id'].toString(),
                              data![index]['nama_toilet'].toString());
                        },
                        child: Card(
                            child: ListTile(
                          title: Text(data![index]["nama_toilet"]),
                          subtitle: Text(data![index]['nama_kantor']),
                          isThreeLine: true,
                          trailing: const Icon(Icons.navigate_next),
                        )),
                      ),
                    );
                  })),
        ],
      ),
    );
    //
  }

  _pushToilet(String id, String nama) async {
    nama2.text = nama;
    Get.dialog(
      AlertDialog(
        title: const Text('Edit/Hapus Toilet'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: nama2,
              decoration: const InputDecoration(
                labelText: "Nama Toilet",
                hintText: "Masukan Nama Toilet",
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        "UPDATE",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _updkirim(id);
                      }),
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text(
                        "HAPUS",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _updhapus(id);
                      }),
                ])
          ],
        ),
      ),
    );
  }

  _tambahToilet() {
    Get.dialog(
      AlertDialog(
        title: const Text('Tambah Pengguna'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: nama,
              decoration: const InputDecoration(
                labelText: "Nama Toilet",
                hintText: "Masukan Nama Toilet",
              ),
            ),
            Row(
              children: <Widget>[
                const Text("Kantor :"),
                FutureBuilder(
                    future: future3,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Items3>> snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      } else {
                        return SizedBox(
                            width: 180,
                            child: DropdownButton<Items3>(
                                items: snapshot.data
                                    ?.map((items) => DropdownMenuItem<Items3>(
                                          value: items,
                                          child: Text(items.name),
                                        ))
                                    .toList(),
                                onChanged: (Items3? value) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  setState(() {
                                    _currentItem3 = value!;
                                    _idk = value.id;
                                  });
                                },
                                isExpanded: true,
                                value: _currentItem3,
                                hint: const Text('Pilih Kantor')));
                      }
                    }),
              ],
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  "Tambah",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _kirim();
                }),
          ],
        ),
      ),
    );
  }
}

class Items3 {
  int id;
  String name;
  Items3({required this.id, required this.name});
  factory Items3.fromJson(Map<String, dynamic> json) {
    return Items3(id: json['id'], name: json['nama']);
  }
}
