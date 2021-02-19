import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unicollab/app/teacher%20home/assignment/EditAssignment.dart';
import 'package:unicollab/app/teacher%20home/assignment/TeacherAssignment.dart';
import 'package:unicollab/app/teacher%20home/material/EditMaterial.dart';
import 'package:unicollab/app/teacher%20home/material/TeacherMaterial.dart';
import 'package:unicollab/app/teacher%20home/notice/EditNotice.dart';
import 'package:unicollab/app/teacher%20home/notice/TeacherNotice.dart';

class MaterialCard extends StatelessWidget {
  MaterialCard(this.document, this.code);
  final String code;
  final DocumentSnapshot document;
  @override
  Widget build(BuildContext context) {
    var data = document.data();
    return Container(
      margin: EdgeInsets.fromLTRB(3.0, 1.0, 3.0, 1.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (_) => TeacherMaterial(data, code)),
          );
        },
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) => ContextMenu(document, code, 0));
        },
        child: Card(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadowColor: Colors.white,
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            leading: Icon(
              CupertinoIcons.book,
              size: 40.0,
            ),
            title: Text('Material: ' + data["title"]),
            subtitle: Text(
              data["description"],
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              onPressed: () {
                showCupertinoModalPopup(
                    context: context,
                    builder: (context) => ContextMenu(document, code, 0));
              },
              icon: Icon(Icons.more_vert),
            ),
          ),
        ),
      ),
    );
  }
}

class NoticeCard extends StatelessWidget {
  NoticeCard(this.document, this.code);
  final String code;
  final DocumentSnapshot document;
  @override
  Widget build(BuildContext context) {
    var data = document.data();
    return Container(
      margin: EdgeInsets.fromLTRB(3.0, 1.0, 3.0, 1.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (_) => TeacherNotice(document, code)),
          );
        },
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) => ContextMenu(document, code, 1));
        },
        child: Card(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadowColor: Colors.white,
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            leading: Icon(
              CupertinoIcons.bell,
              size: 40.0,
            ),
            title: Text('Notice: ' + data["title"]),
            isThreeLine: data["description"] != null ? true : false,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["description"],
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Deadline: " + data["due date"].toDate().toString(),
                ),
              ],
            ),
            trailing: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => ContextMenu(document, code, 1));
              },
              icon: Icon(Icons.more_vert),
            ),
          ),
        ),
      ),
    );
  }
}

class AssignmentCard extends StatelessWidget {
  AssignmentCard(this.document, this.code);
  final String code;
  final DocumentSnapshot document;
  @override
  Widget build(BuildContext context) {
    var data = document.data();
    return Container(
      margin: EdgeInsets.fromLTRB(3.0, 1.0, 3.0, 1.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (_) => TeacherAssignment(document, code)),
          );
        },
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) => ContextMenu(document, code, 2));
        },
        child: Card(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadowColor: Colors.white,
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            leading: Icon(
              CupertinoIcons.doc_chart,
              size: 40.0,
            ),
            title: Text('Assignment: ' + data["title"]),
            isThreeLine: data["description"] != null ? true : false,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["description"],
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Marks: " + data['marks'].toString() + " marks",
                ),
                Text(
                  "Deadline: " + data['due date'].toDate().toString(),
                ),
              ],
            ),
            trailing: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => ContextMenu(document, code, 2));
              },
              icon: Icon(Icons.more_vert),
            ),
          ),
        ),
      ),
    );
  }
}

class ContextMenu extends StatelessWidget {
  const ContextMenu(this.data, this.code, this.type);
  final DocumentSnapshot data;
  final String code;
  final int type;

  Widget pushTo() {
    var _list = [
      EditMaterial(data, code),
      EditNotice(data, code),
      EditAssignment(data, code),
    ];
    return _list[type];
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('I want to'),
      children: [
        ListTile(
          leading: Icon(Icons.assignment),
          title: Text('Edit'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => pushTo(),
                // fullscreenDialog: true,
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.announcement),
          title: Text('Delete'),
          onTap: () {},
        ),
      ],
    );
  }
}
