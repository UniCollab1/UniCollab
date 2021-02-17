import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'StudentMaterialPage.dart';

class Notice extends StatefulWidget {
  final dynamic code;
  const Notice(this.code);
  @override
  _NoticeState createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  @override
  Widget build(BuildContext context) {
    return Container(
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

  getNotice() {
    var lol =
        fireStore.collection('classes').doc(widget.code).collection('notice');
    return lol;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: getNotice().snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data.docs;
                var now = DateTime.now().millisecondsSinceEpoch / 1000;
                for (var d in data) {
                  if (now > d.data()['time'].seconds) {
                    fireStore
                        .collection('classes')
                        .doc(widget.code)
                        .collection('notice')
                        .doc(d.id)
                        .delete();
                  }
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: 'loading your Notice',
                  ),
                );
              } else {
                return SizedBox(
                  height: 250.0,
                  child: ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      return Container(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => NoticePage(
                                    document.data(), document.id, widget.code),
                              ),
                            );
                          },
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.description),
                                  title: Text(
                                      'Notice : ' + document.data()["title"]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
