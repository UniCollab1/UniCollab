import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowComments extends StatefulWidget {
  final DocumentSnapshot document;
  ShowComments(this.document);
  @override
  _ShowCommentsState createState() => _ShowCommentsState();
}

class _ShowCommentsState extends State<ShowComments> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  sendComment(String cmt) {
    firestore
        .collection('classes')
        .doc(widget.document.data()['class code'])
        .collection('general')
        .doc(widget.document.id)
        .collection('comments')
        .add({
      'comment': cmt,
      'sender': auth.currentUser.email,
      'create': DateTime.now(),
    });
  }

  getComments() {
    return firestore
        .collection('classes')
        .doc(widget.document.data()['class code'])
        .collection('general')
        .doc(widget.document.id)
        .collection('comments')
        .orderBy(
          'create',
        )
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    String cmt;
    String type;

    var textcon = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments of " + widget.document.data()['title']),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder(
                stream: getComments(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final comments = snapshot.data.docs.reversed;
                    List<commentwidget> commentwidgets = [];
                    for (var comment in comments) {
                      final message = comment['comment'];
                      final sender = comment['sender'];
                      if (auth.currentUser.email == sender) {
                        type = "sender";
                      } else {
                        type = "receiver";
                      }
                      final commentWidget = commentwidget(
                        message,
                        sender,
                        type,
                        DateFormat("dd MMMM yy")
                            .format(comment['create'].toDate()),
                      );
                      commentwidgets.add(commentWidget);
                    }
                    return Expanded(
                      child: Scrollbar(
                        child: ListView.builder(
                          reverse: true,
                          itemCount: commentwidgets.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: (commentwidgets[index].type == "receiver"
                                  ? EdgeInsets.only(
                                      left: 14, right: 50, top: 5, bottom: 5)
                                  : EdgeInsets.only(
                                      left: 50, right: 14, top: 5, bottom: 5)),
                              child: Align(
                                alignment:
                                    (commentwidgets[index].type == "receiver"
                                        ? Alignment.topLeft
                                        : Alignment.topRight),
                                child: Column(
                                  crossAxisAlignment:
                                      (commentwidgets[index].type == "receiver"
                                          ? CrossAxisAlignment.start
                                          : CrossAxisAlignment.end),
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: (commentwidgets[index]
                                                    .type ==
                                                "receiver"
                                            ? BorderRadius.only(
                                                topRight: Radius.circular(20.0),
                                                bottomLeft:
                                                    Radius.circular(20.0),
                                                bottomRight:
                                                    Radius.circular(20.0),
                                              )
                                            : BorderRadius.only(
                                                topLeft: Radius.circular(20.0),
                                                bottomLeft:
                                                    Radius.circular(20.0),
                                                bottomRight:
                                                    Radius.circular(20.0),
                                              )),
                                        color: (commentwidgets[index].type ==
                                                "receiver"
                                            ? Colors.black12
                                            : Theme.of(context).cardColor),
                                      ),
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            (commentwidgets[index].type ==
                                                    "receiver"
                                                ? CrossAxisAlignment.start
                                                : CrossAxisAlignment.end),
                                        children: [
                                          Text(
                                            (commentwidgets[index].type ==
                                                    "receiver"
                                                ? commentwidgets[index].sender
                                                : "You"),
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            commentwidgets[index].comment,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          Text(
                                            commentwidgets[index].time,
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                color: Colors.black45),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: [],
                  );
                }),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textcon,
                      onChanged: (value) {
                        cmt = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        hintText: 'Type your comment here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (cmt != null) {
                        sendComment(cmt);
                      }
                      textcon.clear();
                    },
                    child: Text(
                      'Send',
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class commentwidget extends StatelessWidget {
  final String comment;
  final String sender;
  final String type;
  final String time;

  commentwidget(this.comment, this.sender, this.type, this.time);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
