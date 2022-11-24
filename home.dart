// ignore_for_file: import_of_legacy_library_into_null_safe, camel_case_types, library_private_types_in_public_api, depend_on_referenced_packages, use_build_context_synchronously, avoid_unnecessary_containers

import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:get/get.dart';
import 'package:monitoring_kebersihan/ceklis2.dart';
import 'package:monitoring_kebersihan/qhse.dart';
import 'package:monitoring_kebersihan/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:month_picker_dialog_2/month_picker_dialog_2.dart';
import 'app/url.dart';
import 'ceklis.dart';
import 'package:http/http.dart' as http;
import 'verif.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  late TextEditingController nama, alamat, namaMgr, nikMgr, namaSpv, nikSpv;
  final TextEditingController textEditingController = TextEditingController();
  String? select;

  List? truck;
  List<String> selections = [];
  List<dynamic> qhse = [];
  List? _foundUsers;
  late String ctt;
  final _catatan = TextEditingController();

  String? namaUser, namaKantor, jabatan, foto;

  late List data2; //edited line
  late Future<List<Items>> future2;
  Items? _currentItem1;
  late List data4;
  late Future<List<Items4>> future;
  Items4? _currentItem;

  late Future<List<Items>> future4;
  Items? _currentItem2;
  late Future<List<Items>> future5;
  Items? _currentItem4;
  late Future<List<Items>> future6;
  Items? _currentItem5;

  late Future<List<Items>> future7;
  Items? _currentItem6;
  late Future<List<Items>> future8;
  Items? _currentItem7;
  late Future<List<Items>> future9;
  Items? _currentItem8;

  late int _toi;
  late String _natoi;
  late TextEditingController dateCtl = TextEditingController();

  late int loginx;
  late String idj;
  late List<Widget> listViews;
  late List<int> menu;
  late List<String> iconListDataText;
  late List<String> iconListData;
  late List<String> iconListDataDesc;

  late List data3;
  late Future<List<Items3>> future3;
  Items3? _currentItem3;
  late int _idk;
  late String _nak;

  Future<List<Items3>> _getItemsData3() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? idKantor = pref.getString("id_kantor");
    final respose = await http.post(urlAPI + phpListKantor,
        body: {'access': 'apickb', 'id_kantor': idKantor});
    var listData = jsonDecode(respose.body);

    return (listData['kantor'] as List).map((p) => Items3.fromJson(p)).toList();
  }

  Future<void> data() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    loginx = preferences.getInt('ID') ?? 0;
    idj = preferences.getString('id_jabatan') ?? '-';
    namaUser = preferences.getString("nama_user") ?? '-';
    namaKantor = preferences.getString("nama_kantor") ?? '-';
    jabatan = preferences.getString("nama_jabatan") ?? '-';
    foto = preferences.getString("foto") ?? '-';

    if (idj == '3') {
      menu = [1, 3];
      iconListData = ["assets/clipart/ceklis.png", "assets/clipart/report.png"];
      iconListDataText = ["Checklist Inspeksi", "Laporan Kebersihan"];
      iconListDataDesc = [
        "Mengisi laporan\nkebersihan setiap hari.",
        "Lihat laporan\ncatatan kebersihan"
      ];
    } else {
      menu = [1, 2, 3, 4, 5, 6, 7, 8, 9];
      iconListData = [
        "assets/clipart/user.gif",
        "assets/clipart/clipboard.gif",
        "assets/clipart/tiress.gif",
        "assets/clipart/idea.gif",
        "assets/clipart/laborers.gif",
        "assets/clipart/repair-tools.gif",
        "assets/clipart/truckk.gif",
        "assets/clipart/big-truck.gif",
        "assets/clipart/customer.gif"
      ];
      iconListDataText = [
        "QHSE",
        "documents",
        "wheel",
        "lighting",
        "PPE",
        "DG Equipt",
        "vehicle Equipt",
        "Truck Security",
        "Driver interview"
      ];
      iconListDataDesc = [
        "Mengisi Laporan\nTruck Type.",
        "mengisi Laporan\nKondisi wheels",
        "mengisi Laporan\nKondisi wheels",
        "Mengisi Laporan\nKondisi lighting",
        "Mengisi Laporan\nKondisi PPE",
        "Mengisi Laporan\nkondisi DG Equipt",
        "Mengisi Laporan\nKondisi vehicle Equipt",
        "Mengisi Laporan\nKondisi vehicle Equipt",
        "mengisi Laporan\nNama Driver"
      ];
    }
    return;
  }

  todayDate() {
    var now = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    String formattedTime = DateFormat('kk:mm:a').format(now);
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  Future getAllCategory() async {
    var baseUrl = urlPlat;

    final response = await http.get(
      Uri.parse(baseUrl),
    );

    final output = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var data12 = json.decode(response.body);
      setState(() {
        qhse = data12['data'];
      });
    }
  }

  Future<List<Items>> _getItemsData2() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // String? idKantor = pref.getString("id_kantor");
    final respose = await http.post(urlAPI + phpkategorilist,
        body: {'access': 'apickb', 'id_kantor': "2"});
    var listData = jsonDecode(respose.body);

    return (listData['toilet'] as List).map((p) => Items.fromJson(p)).toList();
  }

  Future<List<Items>> _getItemsData4() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // String? idKantor = pref.getString("id_kantor");
    final respose = await http.post(urlAPI + phpkategorilist,
        body: {'access': 'apickb', 'id_kantor': "3"});
    var listData = jsonDecode(respose.body);

    return (listData['toilet'] as List).map((p) => Items.fromJson(p)).toList();
  }

  Future<List<Items>> _getItemsData5() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // String? idKantor = pref.getString("id_kantor");
    final respose = await http.post(urlAPI + phpkategorilist,
        body: {'access': 'apickb', 'id_kantor': "4"});
    var listData = jsonDecode(respose.body);

    return (listData['toilet'] as List).map((p) => Items.fromJson(p)).toList();
  }

  Future<List<Items>> _getItemsData6() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // String? idKantor = pref.getString("id_kantor");
    final respose = await http.post(urlAPI + phpkategorilist,
        body: {'access': 'apickb', 'id_kantor': "5"});
    var listData = jsonDecode(respose.body);

    return (listData['toilet'] as List).map((p) => Items.fromJson(p)).toList();
  }

  Future<List<Items>> _getItemsData7() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // String? idKantor = pref.getString("id_kantor");
    final respose = await http.post(urlAPI + phpkategorilist,
        body: {'access': 'apickb', 'id_kantor': "6"});
    var listData = jsonDecode(respose.body);

    return (listData['toilet'] as List).map((p) => Items.fromJson(p)).toList();
  }

  Future<List<Items>> _getItemsData8() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // String? idKantor = pref.getString("id_kantor");
    final respose = await http.post(urlAPI + phpkategorilist,
        body: {'access': 'apickb', 'id_kantor': "7"});
    var listData = jsonDecode(respose.body);

    return (listData['toilet'] as List).map((p) => Items.fromJson(p)).toList();
  }

  Future<List<Items>> _getItemsData9() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // String? idKantor = pref.getString("id_kantor");
    final respose = await http.post(urlAPI + phpkategorilist,
        body: {'access': 'apickb', 'id_kantor': "8"});
    var listData = jsonDecode(respose.body);

    return (listData['toilet'] as List).map((p) => Items.fromJson(p)).toList();
  }

  Future<void> _signOut() async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    pref.setInt('ID', 0);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => LoginView(),
    ));
  }

  void _kirim2() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? idKan = pref.getString("id_kantor");
    String? idUsr = pref.getString("id_user");

    final respose = await http.post(urlAPI + phpins2, body: {
      'access': 'apickb',
      'id_kantor': idKan.toString(),
      'id_toilet': '1',
      'platmobil': select.toString(),
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

  int selectedIndex = 1;
  @override
  void initState() {
    // getAllCategory();
    super.initState();

    data().whenComplete(() {
      setState(() {});
    }).catchError((error, stackTrace) {});

    nama = TextEditingController();
    alamat = TextEditingController();
    namaMgr = TextEditingController();
    nikMgr = TextEditingController();
    namaSpv = TextEditingController();
    nikSpv = TextEditingController();
    getAllCategory();

    _getItemsData2();
    _getItemsData3();
    _getItemsData4();
    _getItemsData5();
    _getItemsData6();
    _getItemsData7();
    _getItemsData8();
    _getItemsData9();
    future2 = _getItemsData2();
    future3 = _getItemsData3();
    future4 = _getItemsData4();
    future5 = _getItemsData5();
    future6 = _getItemsData6();
    future7 = _getItemsData7();
    future8 = _getItemsData8();
    future9 = _getItemsData9();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var img = urlFoto + foto.toString();
    return Scaffold(
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Colors.white,
          selectedItemBorderColor: Colors.blue,
          selectedItemBackgroundColor: Colors.blue,
          selectedItemIconColor: Colors.white,
          selectedItemLabelColor: Colors.blue,
          unselectedItemIconColor: const Color(0XFFC3E1FF),
          unselectedItemTextStyle: const TextStyle(fontSize: 8),
          unselectedItemLabelColor: const Color(0xFFDEE1E6),
          selectedItemTextStyle: const TextStyle(fontSize: 8),
        ),
        selectedIndex: selectedIndex,
        onSelectTab: (index) {
          setState(() {
            selectedIndex = index;

            print(selectedIndex);
            if (selectedIndex == 2) {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Informasi!'),
                    content: const Text(
                        'Apakah anda yakin untuk keluar dari akun ini?'),
                    actions: <Widget>[
                      ElevatedButton(
                          child: const Text('Batal'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      ElevatedButton(
                          child: const Text('Keluar'),
                          onPressed: () {
                            _signOut();
                          }),
                    ],
                  );
                },
              );
            } else if (selectedIndex == 1) {
            } else if (selectedIndex == 0) {
              if (idj == '1') {
                _updData();
              } else {
                _develDialog();
              }
            }
          });
        },
        items: [
          FFNavigationBarItem(
            iconData: Icons.settings,
            label: 'Pengaturan',
          ),
          FFNavigationBarItem(
            iconData: Icons.notifications_none,
            label: 'Notifikasi',
          ),
          FFNavigationBarItem(
            iconData: Icons.exit_to_app,
            label: 'Keluar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClipPath(
              clipper: OvalBottomBorderClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Warna1,
                      Warna2,
                    ],
                  ),
                ),
                child: Column(children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.02),
                        child: const Text(
                          "Daily Inspection QHSE",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3.0),
                  CircleAvatar(
                    radius: 35,
                    child: ClipOval(
                      child: Image.network(img),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    namaUser!,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    jabatan!,
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  Text(
                    namaKantor!,
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ]),
              ),
            ),
            GridView(
              //main menu
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 0, bottom: 10),
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: (5 / 1.4),
                mainAxisSpacing: 15.0,
                crossAxisSpacing: 10.0,
              ),
              children: List.generate(menu.length, (index) {
                return buildIconMenu(menu[index], iconListData[index],
                    iconListDataText[index], iconListDataDesc[index]);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIconMenu(
      final int menu, String imagepath, String imageText, String desc) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8.0),
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
            topRight: Radius.circular(8.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              offset: const Offset(1.1, 1.2),
              blurRadius: 10.0),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          splashColor: Colors.lightBlue.withOpacity(0.2),
          onTap: () {
            //mengatasi klik untuk masing-masing icon
            if (menu == 1) {
              _pilihInspeksi();
            }
            if (menu == 2) {
              _pilihInspeksi2();
            }
            if (menu == 3) {
              _pilihInspeksi3();
            }
            if (menu == 4) {
              _pilihInspeksi4();
            }
            if (menu == 5) {
              _pilihInspeksi5();
            }
            if (menu == 6) {
              _pilihInspeksi6();
            }
            if (menu == 7) {
              _pilihInspeksi7();
            }
            if (menu == 8) {
              _pilihInspeksi8();
            }

            if (menu == 9) {
              _pilihInspeksi9();
            }
          },
          child: Row(
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 12, left: 15),
                      child: Text(
                        imageText,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.black87,
                            letterSpacing: 0.1,
                            fontFamily: 'Poppins'),
                      ),
                    ),
                    const SizedBox(
                      height: 1.3,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 15),
                      child: Text(
                        desc,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            letterSpacing: 0.1,
                            fontFamily: 'Poppins'),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: Divider(),
              ),
              Container(
                child: Image.asset(
                  imagepath,
                  height: 110.0,
                  width: 110.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _pilihInspeksi() {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // ignore: prefer_interpolation_to_compose_strings
          Text("Tanggal : " + todayDate()),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Text("QHSE :"),
              DropdownButton2(
                isExpanded: true,
                hint: Text(
                  'Select Item',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: qhse
                    .map((item) => DropdownMenuItem<String>(
                          value: item['no_polisi'].toString(),
                          child: Text(
                            item['no_polisi'].toString(),
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
                value: select,
                onChanged: (value) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() {
                    select = value;
                    print(select);
                  });
                },
                buttonHeight: 40,
                buttonWidth: 200,
                itemHeight: 40,
                dropdownMaxHeight: 200,
                searchController: textEditingController,
                searchInnerWidget: Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 4,
                    right: 8,
                    left: 8,
                  ),
                  child: TextFormField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      hintText: 'Search for an item...',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  return (item.value.toString().contains(searchValue));
                },
                //This to clear the search value when you close the menu
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    textEditingController.clear();
                  }
                },
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),

          const Text(
            "Wajib pilih.",
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text(
                "Send Data",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _kirim2();
              }),

          // const Text(
          //   "Wajib pilih.",
          //   style: TextStyle(color: Colors.red, fontSize: 15),
          // ),
        ],
      ),
    ));
  }

  _pilihInspeksi2() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // ignore: prefer_interpolation_to_compose_strings
            Text("Tanggal : " + todayDate()),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Text("Document :"),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                    future: future2,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Items>> snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        return SizedBox(
                            width: 100,
                            child: DropdownButton<Items>(
                                items: snapshot.data
                                    ?.map((items) => DropdownMenuItem<Items>(
                                          child: Text(items.name),
                                          value: items,
                                        ))
                                    .toList(),
                                onChanged: (Items? value) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  setState(() {
                                    _currentItem1 = value!;
                                    _toi = value.id;
                                    _natoi = value.name;
                                    print(_natoi);
                                  });
                                },
                                isExpanded: true,
                                value: _currentItem1,
                                hint: Text('Pilih jenis')));
                      }
                    }),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            const Text(
              "Wajib pilih.",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  "Lanjut Ceklis",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  // ignore: unnecessary_null_comparison
                  if (_natoi != null) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Ceklis2(toilet: _toi, nama: _natoi),
                    ));
                  } else {
                    print("else");
                  }
                }),
          ],
        ),
      ),
    );
  }

  _pilihInspeksi3() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // ignore: prefer_interpolation_to_compose_strings
            Text("Tanggal : " + todayDate()),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Text("Wheel :"),
                FutureBuilder(
                    future: future4,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Items>> snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        return SizedBox(
                            width: 150,
                            child: DropdownButton<Items>(
                                items: snapshot.data
                                    ?.map((items) => DropdownMenuItem<Items>(
                                          child: Text(items.name),
                                          value: items,
                                        ))
                                    .toList(),
                                onChanged: (Items? value) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  setState(() {
                                    _currentItem2 = value!;
                                    _toi = value.id;
                                    _natoi = value.name;
                                    print(_natoi);
                                  });
                                },
                                isExpanded: true,
                                value: _currentItem2,
                                hint: Text('Pilih Jenis')));
                      }
                    }),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            const Text(
              "Wajib pilih.",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  "Lanjut Ceklis",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  // ignore: unnecessary_null_comparison
                  if (_natoi != null) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Ceklis2(toilet: _toi, nama: _natoi),
                    ));
                  } else {
                    print("else");
                  }
                }),
          ],
        ),
      ),
    );
  }

  _pilihInspeksi4() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // ignore: prefer_interpolation_to_compose_strings
            Text("Tanggal : " + todayDate()),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Text("Lighting :"),
                FutureBuilder(
                    future: future5,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Items>> snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        return SizedBox(
                            width: 100,
                            child: DropdownButton<Items>(
                                items: snapshot.data
                                    ?.map((items) => DropdownMenuItem<Items>(
                                          child: Text(items.name),
                                          value: items,
                                        ))
                                    .toList(),
                                onChanged: (Items? value) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  setState(() {
                                    _currentItem4 = value!;
                                    _toi = value.id;
                                    _natoi = value.name;
                                    print(_natoi);
                                  });
                                },
                                isExpanded: true,
                                value: _currentItem4,
                                hint: Text('pilih jenis')));
                      }
                    }),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            const Text(
              "Wajib pilih.",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  "Lanjut Ceklis",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  // ignore: unnecessary_null_comparison
                  if (_natoi != null) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Qhse(toilet: _toi, nama: _natoi),
                    ));
                  } else {
                    print("else");
                  }
                }),
          ],
        ),
      ),
    );
  }

  _pilihInspeksi5() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // ignore: prefer_interpolation_to_compose_strings
            Text("Tanggal : " + todayDate()),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Text("PPE :"),
                FutureBuilder(
                    future: future6,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Items>> snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        return SizedBox(
                            width: 100,
                            child: DropdownButton<Items>(
                                items: snapshot.data
                                    ?.map((items) => DropdownMenuItem<Items>(
                                          child: Text(items.name),
                                          value: items,
                                        ))
                                    .toList(),
                                onChanged: (Items? value) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  setState(() {
                                    _currentItem5 = value!;
                                    _toi = value.id;
                                    _natoi = value.name;
                                    print(_natoi);
                                  });
                                },
                                isExpanded: true,
                                value: _currentItem5,
                                hint: Text('Pilih Jenis')));
                      }
                    }),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            const Text(
              "Wajib pilih.",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  "Lanjut Ceklis",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  // ignore: unnecessary_null_comparison
                  if (_natoi != null) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Ceklis2(toilet: _toi, nama: _natoi),
                    ));
                  } else {
                    print("else");
                  }
                }),
          ],
        ),
      ),
    );
  }

  _pilihInspeksi6() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // ignore: prefer_interpolation_to_compose_strings
            Text("Tanggal : " + todayDate()),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Text("DG Equipt :"),
                FutureBuilder(
                    future: future7,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Items>> snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        return SizedBox(
                            width: 100,
                            child: DropdownButton<Items>(
                                items: snapshot.data
                                    ?.map((items) => DropdownMenuItem<Items>(
                                          child: Text(items.name),
                                          value: items,
                                        ))
                                    .toList(),
                                onChanged: (Items? value) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  setState(() {
                                    _currentItem6 = value!;
                                    _toi = value.id;
                                    _natoi = value.name;
                                    print(_natoi);
                                  });
                                },
                                isExpanded: true,
                                value: _currentItem6,
                                hint: Text('Pilih Jenis')));
                      }
                    }),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            const Text(
              "Wajib pilih.",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  "Lanjut Ceklis",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  // ignore: unnecessary_null_comparison
                  if (_natoi != null) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Ceklis2(toilet: _toi, nama: _natoi),
                    ));
                  } else {
                    print("else");
                  }
                }),
          ],
        ),
      ),
    );
  }

  _pilihInspeksi7() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // ignore: prefer_interpolation_to_compose_strings
            Text("Tanggal : " + todayDate()),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Text("Vehicle Equipt :"),
                FutureBuilder(
                    future: future8,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Items>> snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        return SizedBox(
                            width: 150,
                            child: DropdownButton<Items>(
                                items: snapshot.data
                                    ?.map((items) => DropdownMenuItem<Items>(
                                          child: Text(items.name),
                                          value: items,
                                        ))
                                    .toList(),
                                onChanged: (Items? value) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  setState(() {
                                    _currentItem7 = value!;
                                    _toi = value.id;
                                    _natoi = value.name;
                                    print(_natoi);
                                  });
                                },
                                isExpanded: true,
                                value: _currentItem7,
                                hint: Text('Pilih Jenis')));
                      }
                    }),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            const Text(
              "Wajib pilih.",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  "Lanjut Ceklis",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  // ignore: unnecessary_null_comparison
                  if (_natoi != null) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Ceklis2(toilet: _toi, nama: _natoi),
                    ));
                  } else {
                    print("else");
                  }
                }),
          ],
        ),
      ),
    );
  }

  _pilihInspeksi8() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // ignore: prefer_interpolation_to_compose_strings
            Text("Tanggal : " + todayDate()),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Text("Truck Security :"),
                FutureBuilder(
                    future: future9,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Items>> snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        return SizedBox(
                            width: 100,
                            child: DropdownButton<Items>(
                                items: snapshot.data
                                    ?.map((items) => DropdownMenuItem<Items>(
                                          child: Text(items.name),
                                          value: items,
                                        ))
                                    .toList(),
                                onChanged: (Items? value) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  setState(() {
                                    _currentItem8 = value!;
                                    _toi = value.id;
                                    _natoi = value.name;
                                    print(_natoi);
                                  });
                                },
                                isExpanded: true,
                                value: _currentItem8,
                                hint: Text('Pilih Jenis')));
                      }
                    }),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            const Text(
              "Wajib pilih.",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  "Lanjut Ceklis",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  // ignore: unnecessary_null_comparison
                  if (_natoi != null) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Ceklis2(toilet: _toi, nama: _natoi),
                    ));
                  } else {
                    print("else");
                  }
                }),
          ],
        ),
      ),
    );
  }

  _pilihInspeksi9() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // ignore: prefer_interpolation_to_compose_strings
            Text("Tanggal : " + todayDate()),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Text("Truck Security :"),
                FutureBuilder(
                    future: future9,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Items>> snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        return SizedBox(
                            width: 100,
                            child: DropdownButton<Items>(
                                items: snapshot.data
                                    ?.map((items) => DropdownMenuItem<Items>(
                                          child: Text(items.name),
                                          value: items,
                                        ))
                                    .toList(),
                                onChanged: (Items? value) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  setState(() {
                                    _currentItem8 = value!;
                                    _toi = value.id;
                                    _natoi = value.name;
                                    print(_natoi);
                                  });
                                },
                                isExpanded: true,
                                value: _currentItem8,
                                hint: Text('Pilih Jenis')));
                      }
                    }),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            const Text(
              "Wajib pilih.",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  "Lanjut Ceklis",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  // ignore: unnecessary_null_comparison
                  if (_natoi != null) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Qhse(toilet: _toi, nama: _natoi),
                    ));
                  } else {
                    print("else");
                  }
                }),
          ],
        ),
      ),
    );
  }

  _updData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? idKantor = pref.getString("id_kantor");
    final respose = await http.post('${urlAPI}cek_data_kantor.php',
        body: {'access': 'apickb', 'id_kantor': idKantor});
    var data = jsonDecode(respose.body);
    print(data);
    setState(() {
      nama.text = data['nama_kantor'];
      alamat.text = data['alamat'];
      namaMgr.text = data['nama_manager'];
      nikMgr.text = data['nik_manager'];
      namaSpv.text = data['nama_supervisor'];
      nikSpv.text = data['nama_kantor'];
    });
    Get.dialog(
      AlertDialog(
        title: const Text('Pengaturan'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: nama,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: "Divisi",
                  hintText: "Masukan Nama Kantor",
                ),
              ),
              TextFormField(
                controller: namaSpv,
                decoration: const InputDecoration(
                  labelText: "Jabatan",
                  hintText: "",
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    "Simpan Data",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _kirim();
                  }),
            ],
          ),
        ),
      ),
    );
  }

  _pilihLaporan() {
    Get.dialog(
      AlertDialog(
        title: const Text('Laporan Kebersihan'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: dateCtl,
              decoration: const InputDecoration(
                labelText: "Pilih Periode",
                hintText: "",
              ),
              onTap: () async {
                DateTime? date = DateTime(2022);
                FocusScope.of(context).requestFocus(new FocusNode());
                date = await showMonthPicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2022),
                    lastDate: DateTime(2025));

                dateCtl.text = date.toString().substring(0, 7);
              },
            ),
            Row(
              children: <Widget>[
                const Text("Kantor :"),
                FutureBuilder(
                    future: future3,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Items3>> snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        return Container(
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
                                    _nak = value.name;
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
                  "Download Laporan",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (_idk != null) {
                    // ignore: prefer_interpolation_to_compose_strings
                    final Uri toLaunch = Uri.parse(urlAPI +
                        "reportpdf.php?kantor=$_idk&periode=${dateCtl.text}");
                    _Call(toLaunch);
                  } else {}
                }),
          ],
        ),
      ),
    );
  }

  _develDialog() {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Informasi!'),
            content: const Text('Maaf, Menu ini hanya untuk Admin.'),
            actions: <Widget>[
              ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void _kirim() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final respose = await http.post('${urlAPI}upd_data.php', body: {
      'access': 'apickb',
      'alamat': alamat.text.toString(),
      'nama_manager': namaMgr.text.toString(),
      'nik_manager': nikMgr.text.toString(),
      'nama_supervisor': namaSpv.text.toString(),
      'nik_supervisor': nikSpv.text.toString(),
      'id_kantor': preferences.getString('id_kantor').toString(),
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
                    builder: (context) => home(),
                  )),
              child: const Text('Selesai')),
        ],
      ));
    } else {
      Get.dialog(AlertDialog(
        title: const Text('Informasi'),
        content: const Text('Data GAGAL disimpan.'),
        actions: [
          ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => home(),
                  )),
              child: const Text('Selesai')),
        ],
      ));
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> _Call(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  void _onCategorySelected(bool? selected, categoryId) {
    if (selected == true) {
      setState(() {
        truck?.add(categoryId);
        selections.add((categoryId.toString()));
      });
    } else {
      setState(() {
        truck?.remove(categoryId);
        selections.remove((categoryId.toString()));
      });
    }
  }
}

//
class Items {
  int id;
  String name;

  Items({required this.id, required this.name});

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(id: json['id_toilet'], name: json['nama_toilet']);
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

class Items4 {
  String id;
  String nopolis;
  Items4({required this.nopolis, required this.id});
  factory Items4.fromJson(Map<String, dynamic> json) {
    return Items4(nopolis: json['no_polisi'], id: json['idmobil']);
  }
}
