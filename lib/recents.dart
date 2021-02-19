import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unicollab/studentSubject.dart';
import 'package:unicollab/teacherSubject.dart';

FirebaseAuth auth = FirebaseAuth.instance;
var fireStore = FirebaseFirestore.instance;

class Recent extends StatefulWidget {
  @override
  _RecentState createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Classes joined by you',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListPage('join'),
          TextButton(
            onPressed: () {},
            child: Text(
              'Classes created by you',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListPage('create'),
        ],
      ),
    );
  }
}

class ListPage extends StatefulWidget {
  final String which;
  const ListPage(this.which);
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<TextButton> l1 = [];
  getClass() {
    var lol;
    if (widget.which == 'join') {
      lol = fireStore
          .collection('classes')
          .where("students", arrayContains: auth.currentUser.email)
          .snapshots();
    } else {
      lol = fireStore
          .collection('classes')
          .where("teachers", arrayContains: auth.currentUser.email)
          .snapshots();
    }
    return lol;
  }

  TextButton textButton(data) {
    return TextButton(
      onPressed: () async {
        if (widget.which == 'join') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => StudentHome(
                data.data(),
              ),
            ),
          );
        } else {
          // print(data.data());
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => TeacherHome(
                data.data(),
              ),
            ),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(5.0),
            width: 130.0,
            height: 130.0,
            color: Colors.grey,
          ),
          Container(
            width: 130.0,
            child: Text(
              data.data()['subject'],
              maxLines: 1,
            ),
          ),
          Container(
            width: 130.0,
            child: Text(
              data.data()['created by'],
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: getClass(),
        builder: (context, snapshot) {
          l1 = [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'loading your classes',
              ),
            );
          } else {
            final allData = snapshot.data.docs;
            for (var data in allData) {
              var tb = textButton(data);
              l1.add(tb);
            }
            return SizedBox(
              height: 200.0,
              child: Container(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: l1.length,
                  itemBuilder: (context, index) {
                    return l1[index];
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
