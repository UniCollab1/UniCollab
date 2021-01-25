import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Join.dart';
import 'create.dart';

class Recent extends StatefulWidget {
  @override
  _RecentState createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
  FirebaseAuth auth = FirebaseAuth.instance;
  Future getClass() async {
    var fireStore = FirebaseFirestore.instance;
    var lol;
    if (widget.which == 'join') {
      lol = await fireStore
          .collection('classes')
          .where("students", arrayContains: auth.currentUser.email)
          .get();
    } else {
      lol = await fireStore
          .collection('classes')
          .where("teachers", arrayContains: auth.currentUser.email)
          .get();
    }
    return lol.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getClass(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'loading your classes',
              ),
            );
            // ignore: missing_return
          } else {
            return Expanded(
              child: Container(
                margin: EdgeInsets.all(10.0),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.all(10.0),
                            width: 140.0,
                            height: 140.0,
                            color: Colors.grey,
                          ),
                          Text(snapshot.data[index].get("subject")),
                          Text(snapshot.data[index].get("created by"))
                        ],
                      );
                    }),
              ),
            );
          }
        },
      ),
    );
  }
}

class RecentFloat extends StatefulWidget {
  @override
  _RecentFloatState createState() => _RecentFloatState();
}

class _RecentFloatState extends State<RecentFloat> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: [
                ListTile(
                  title: Text('Create Class'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => CreateDialog(),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text('Join Class'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => JoinDialog(),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
      child: Icon(Icons.add),
    );
  }
}
