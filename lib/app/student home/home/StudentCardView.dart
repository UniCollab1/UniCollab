import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unicollab/app/student%20home/material/StudentMaterial.dart';
import 'package:unicollab/app/student%20home/notice/StudentNotice.dart';

class MaterialCard extends StatelessWidget {
  MaterialCard(this.document, this.code);
  final String code;
  final DocumentSnapshot document;
  @override
  Widget build(BuildContext context) {
    var data = document.data();
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => StudentMaterial(data, code)),
          );
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
            title: Text(
                'Material${data["edited"] == true ? ("(Edited)") : ("")}: ' +
                    data["title"]),
            subtitle: Text(
              data["description"],
              overflow: TextOverflow.ellipsis,
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
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => StudentNotice(document, code)),
          );
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
            title: Text(
                'Notice${data["edited"] == true ? ("(Edited)") : ("")}: ' +
                    data["title"]),
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
      child: GestureDetector(
        onTap: () {
          /*Navigator.push(
            context,
            CupertinoPageRoute(builder: (_) => AssignmentPage(document, code)),
          );*/
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
            isThreeLine: data["description"] != null ? true : false,
            title: Text(
                'Assignment${data["edited"] == true ? ("(Edited)") : ("")}: ' +
                    data["title"]),
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
          ),
        ),
      ),
    );
  }
}
