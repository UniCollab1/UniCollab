import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unicollab/StudentMaterialPage.dart';

class StudentHome extends StatefulWidget {
  final dynamic code;
  const StudentHome(this.code);
  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.code["title"]),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Center(child: Text(widget.code["subject"])),
                  Center(child: Text(widget.code["created by"])),
                  GetClass(widget.code["class code"]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GetClass extends StatefulWidget {
  final String code;
  const GetClass(this.code);
  @override
  _GetClassState createState() => _GetClassState();
}

class _GetClassState extends State<GetClass> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var fireStore = FirebaseFirestore.instance;

  Future<dynamic> getData() async {
    var lol = await fireStore
        .collection('classes')
        .doc(widget.code)
        .collection('general')
        .get();
    return lol.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'loading your classes',
              ),
              // ignore: missing_return
            );
          } else {
            return SizedBox(
              height: 100.0,
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                StudentMaterialPage(
                                    snapshot.data[index], widget.code),
                          ),
                        );
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.description),
                              title: Text('Material: ' +
                                  snapshot.data[index].get("title")),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
