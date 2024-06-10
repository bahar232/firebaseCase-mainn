import 'package:bahar_firebase_case/model/kisi.dart';
import 'package:bahar_firebase_case/service/auth_service.dart';
import 'package:bahar_firebase_case/view/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();

  List<Kisi> kisiler = [];

  final kisilerInstance = FirebaseFirestore.instance.collection("kisiler");
  //List<Kisi> kisiler = [];

  Future<void> fetchKisiler() async {
    var response = await kisilerInstance.get();
    mapKisiler(response);
  }

  Future<void> mapKisiler(QuerySnapshot<Map<String, dynamic>> datas) async {
    var data = datas.docs
        .map((e) => Kisi(id: e.id, name: e["name"], num: e["num"]))
        .toList();

    setState(() {
      kisiler = data;
    });
  }

  Future<void> addKisi(String name, String num) async {
    var newKisi = Kisi(id: "", name: name, num: num);
    await FirebaseFirestore.instance
        .collection("kisiler")
        .add(newKisi.toJson());
  }

  Future<void> deleteKisi(String id) async {
    await FirebaseFirestore.instance.collection("kisiler").doc(id).delete();
  }

  Future<void> updateKisi(String id, String name, String num) async {
    var newKisi = Kisi(id: "", name: name, num: num);
    await FirebaseFirestore.instance
        .collection("kisiler")
        .doc(id)
        .update(newKisi.toJson());
  }

  var nameController = TextEditingController();
  var numController = TextEditingController();
  void addKisiDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Kişi Ekleme"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(hintText: "İsim"),
              ),
              TextFormField(
                controller: numController,
                decoration: InputDecoration(hintText: "Numara"),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  clear();
                },
                child: Text("Temizle")),
            TextButton(
                onPressed: () {
                  addKisi(nameController.text, numController.text);
                  clear();
                  Navigator.pop(context);
                },
                child: Text("Ekle")),
          ],
        );
      },
    );
  }

  void updateKisiDialog(String id, String name, String num) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Güncelleme"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(hintText: "İsim"),
              ),
              TextFormField(
                controller: numController,
                decoration: InputDecoration(hintText: "Numara"),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  clear();
                },
                child: Text("Temizle")),
            TextButton(
                onPressed: () {
                  updateKisi(id, nameController.text, numController.text);
                  clear();
                  Navigator.pop(context);
                },
                child: Text("Güncelle")),
          ],
        );
      },
    );
  }

  void clear() {
    setState(() {
      nameController.text = "";
      numController.text = "";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchKisiler();
    FirebaseFirestore.instance
        .collection("kisiler")
        .snapshots()
        .listen((event) {
      mapKisiler(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("CurrentUser : " + authService.authInstance.currentUser.toString());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Rehberim"),
        actions: [
          IconButton(
              onPressed: () {
                authService.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: kisiler.length == 0
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child: Container(
                  child: CircularProgressIndicator(),
                )),
              ],
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: kisiler.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 221, 165,
                              230), // Set your desired purple color
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.white, width: 2.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            kisiler[index].name,
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            kisiler[index].num,
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: MediaQuery.of(context).size.height * 0.07,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    updateKisiDialog(
                                      kisiler[index].id,
                                      kisiler[index].name,
                                      kisiler[index].num,
                                    );
                                  },
                                  icon: Icon(Icons.edit),
                                  color: Colors.white,
                                ),
                                IconButton(
                                  onPressed: () {
                                    deleteKisi(kisiler[index].id);
                                  },
                                  icon: Icon(Icons.delete),
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            addKisiDialog();
          }),
    );
  }
}
