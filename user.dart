// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/url.dart';
import 'package:http/http.dart' as http;

class User extends StatefulWidget {
  const User({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  List? data;
  late TextEditingController nama, username, password;

  List? data2; //edited line
  late Future<List<Items>> future;
  Items? _currentItem;
  late int _idjb;

  List? data3;

  late Future<List<Items3>> future3;
  Items3? _currentItem3;
  late int _idk;

  void getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? idKan = pref.getString("id_kantor");
    var res = await http
        .post(urlAPI + phpUser, body: {'access': 'apickb', 'id_kantor': idKan});
    setState(() {
      var content = json.decode(res.body);
      data = content['user'];
    });
  }

  Future<List<Items>> _getItemsData() async {
    final respose =
        await http.post(urlAPI + phpListJabatan, body: {'access': 'apickb'});
    var listData = jsonDecode(respose.body);
    return (listData['jabatan'] as List).map((p) => Items.fromJson(p)).toList();
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
    username = TextEditingController();
    password = TextEditingController();

    future = _getItemsData();
    future3 = _getItemsData3();
  }

  void _kirim() async {
    final respose = await http.post(urlAPI + phpinsUser, body: {
      'access': 'apickb',
      'nama_user': nama.text,
      'id_jabatan': _idjb.toString(),
      'username': username.text,
      'password': password.text,
      'id_kantor': _idk.toString()
    });
    var res = json.decode(respose.body);
    if (res['message'] == 200) {
      Get.dialog(AlertDialog(
        title: const Text('Informasi'),
        content: const Text('Data berhasil disimpan.'),
        actions: [
          ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const User(),
                  )),
              child: const Text('Selesai'))
        ],
      ));
    } else {
      Get.dialog(AlertDialog(
        title: const Text('Informasi'),
        content: const Text('Data GAGAL disimpan.'),
        actions: [
          ElevatedButton(
            onPressed: () => Get.toNamed('/user'),
            child: const Text('Kembali'),
          )
        ],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Pengguna"),
        actions: <Widget>[
          ElevatedButton(
              onPressed: () => _tambahUser(),
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
                        onTap: () {},
                        child: Card(
                            child: ListTile(
                          title: Text(data![index]["nama"]),
                          leading: ClipOval(
                            child: Material(
                                color: Colors.blue, // button color
                                child: CircleAvatar(
                                  backgroundColor: Colors.blueAccent,
                                  child: Text(
                                    data![index]['inisial'],
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                )),
                          ),
                          subtitle: Text(data![index]["nama_jabatan"] +
                              '\n' +
                              data![index]['nama_kantor']),
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

  _tambahUser() {
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
                labelText: "Nama Lengkap",
                hintText: "Masukan Nama",
              ),
            ),
            TextFormField(
              controller: username,
              decoration: const InputDecoration(
                labelText: "Username",
                hintText: "Masukan Username",
              ),
            ),
            TextFormField(
              controller: password,
              decoration: const InputDecoration(
                labelText: "Password",
                hintText: "Password",
              ),
            ),
            Row(
              children: <Widget>[
                const Text("Jabatan :"),
                FutureBuilder(
                    future: future,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Items>> snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      } else {
                        return SizedBox(
                            width: 170,
                            child: DropdownButton<Items>(
                                items: snapshot.data
                                    ?.map((items) => DropdownMenuItem<Items>(
                                          value: items,
                                          child: Text(items.name),
                                        ))
                                    .toList(),
                                onChanged: (Items? value) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  setState(() {
                                    _currentItem = value!;
                                    _idjb = value.id;
                                  });
                                },
                                isExpanded: true,
                                value: _currentItem,
                                hint: const Text('Pilih Jabatan')));
                      }
                    }),
              ],
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
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

class Items {
  int id;
  String name;
  Items({required this.id, required this.name});
  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(id: json['id'], name: json['nama_jabatan']);
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
