import 'package:cloud_firestore/cloud_firestore.dart';
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
        body: Center(
      child: Text("Recents"),
    ) //ListPage(),
        );
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Future getClass() async {
    var firestore = FirebaseFirestore.instance;

    var qn = await firestore.collection('classes').get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: getClass(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading"),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  print(snapshot.data[index].get("name"));
                  return ListTile(
                    isThreeLine: true,
                    title: Text(snapshot.data[index].get("name")),
                    subtitle: Text(snapshot.data[index].get("createby")),
                  );
                },
              );
            }
          }),
    );
  }
}

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class RecentFloat extends StatefulWidget {
  @override
  _RecentFloatState createState() => _RecentFloatState();
}

class _RecentFloatState extends State<RecentFloat> {
  Join _join = Join();
  Create _create = Create();

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
                    _create.createAlert(context);
                  },
                ),
                ListTile(
                  title: Text('Join Class'),
                  onTap: () {
                    _join.joinAlert(context);
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
