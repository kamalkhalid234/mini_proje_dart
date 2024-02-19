// import 'dart:convert';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:proje/screens/user.add.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // State<Home> createState() => _HomeState();
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  XFile? img;
  ImagePicker imgpic = ImagePicker();

  getImg() async {
    final pic = await imgpic.pickImage(source: ImageSource.gallery);

    setState(() {
      img = XFile(pic!.path);
    });
  }

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  List list = [];

  ///-------------------------Read Data -------------
  Future ReadData() async {
    var url = "http://192.168.0.109/MCW/PFE/fun/readData.php";
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      var red = jsonDecode(res.body);

      setState(() {
        list.addAll(red);
        _streamController.add(red);
      });
      print(list);
    }
  }

  ///-------------------------Add Data -------------
  Future AddData() async {
    var url = "http://192.168.0.109/MCW/PFE/fun/addData.php";
    var res = await http.post(Uri.parse(url), body: {
      'name': name.text,
      'email': email.text,
    });

    if (res.statusCode == 200) {
      var red = jsonDecode(res.body);

      print(red);
    }
  }

  ///-------------------------Edit Data -------------
  Future EditData(id) async {
    var url = "http://192.168.0.109/MCW/PFE/fun/editData.php";
    var res = await http.post(Uri.parse(url),
        body: {'id': id, 'name': name.text, 'email': email.text});
    if (res.statusCode == 200) {
      var red = jsonDecode(res.body);

      print(red);
    }
  }

  ///-------------------------Delete Data -------------
  Future DeleteData(id) async {
    var url = "http://192.168.0.109/MCW/PFE/fun/deleteData.php";
    var res = await http.post(Uri.parse(url), body: {'id': id});

    if (res.statusCode == 200) {
      var red = jsonDecode(res.body);

      print(red);
    }
  }

  late StreamController<List<dynamic>> _streamController;
  late Stream<List<dynamic>> _stream;

  @override
  void initState() {
    super.initState();

    setState(() {
      _streamController = StreamController();
      _stream = _streamController.stream;
    });
    getData();
  }

  getData() async {
    await ReadData();
  }

  //------------------------- Addd  date ajouter
  AddUsers() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 300,
              child: Column(
                children: [
                  Text('Add User'),
                  TextFormField(
                    controller: name,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextFormField(
                    controller: email,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        print(name.text);
                        print(email.text);
                        AddData();
                        ReadData();
                        Navigator.pop(context);
                      },
                      child: Text("Send"))
                ],
              ),
            ),
          );
        });
  }

  //------------------------- Edit  data  ajouter
  EditUsers(id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 300,
              child: Column(
                children: [
                  Text('Edit User'),
                  TextFormField(
                    controller: name,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextFormField(
                    controller: email,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        print(name.text);
                        print(email.text);
                        print(id);
                        EditData(id);
                        ReadData();
                        Navigator.pop(context);
                      },
                      child: Text("Send"))
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste"),
        shadowColor: Colors.white,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: () {
                AddUsers();
              },
              icon: Icon(
                Icons.add,
                size: 35,
              )),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                getImg();
              },
              child: Text("PicImage"))
        ],
      ),
      // body: StreamBuilder<List<dynamic>>(
      //     stream: _stream,
      //     builder: (stx, snp) {
      //       if (!snp.hasData) {
      //         return Container(
      //           height: 150,
      //           child: Text("no data"),
      //         );
      //       } else if (snp.hasError) {
      //         return CircularProgressIndicator();
      //       } else {
      //         return ListView.builder(
      //             itemCount: snp.data!.length,
      //             itemBuilder: (ctx, i) {
      //               return ListTile(
      //                 title: Text(snp.data![i]['username']),
      //                 subtitle: Text(snp.data![i]["email"]),
      //                 leading: CircleAvatar(
      //                   radius: 30,
      //                   backgroundImage: AssetImage('images/006.png'),
      //                 ),
      //                 // ignore: sized_box_for_whitespace
      //                 trailing: Container(
      //                   width: 100,
      //                   child: Row(
      //                     children: [
      //                       IconButton(
      //                           onPressed: () {
      //                             EditUsers(snp.data![i]['userid']);
      //                           },
      //                           // ignore: prefer_const_constructors
      //                           icon: Icon(Icons.edit, color: Colors.teal)),
      //                       IconButton(
      //                           onPressed: () {
      //                             DeleteData(snp.data![i]['userid']);
      //                             ReadData();
      //                           },
      //                           icon: Icon(Icons.delete, color: Colors.red)),
      //                     ],
      //                   ),
      //                 ),
      //               );
      //             });
      //       }
      //     })
    );
  }
}
