import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JoinDialog extends StatefulWidget {
  @override
  _JoinDialogState createState() => _JoinDialogState();
}

class _JoinDialogState extends State<JoinDialog> {
  String code;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join class'),
        actions: [
          Container(
            margin: EdgeInsets.all(10.0),
            child: ElevatedButton(
                onPressed: () async {
                  final _fireStore = FirebaseFirestore.instance;
                  FirebaseAuth auth = FirebaseAuth.instance;
                  bool flag = true;

                  try {
                    var event =
                        await _fireStore.collection('classes').doc(code).get();
                    if (event.exists) {
                      final docRef = _fireStore
                          .collection('users')
                          .doc(auth.currentUser.email);
                      await _fireStore
                          .collection('classes')
                          .doc(code)
                          .get()
                          .then((value) => {
                                value.get('students').forEach((element) => {
                                      print(element),
                                      if (_fireStore
                                              .collection('users')
                                              .doc(element) ==
                                          docRef)
                                        {flag = false}
                                    })
                              });
                      if (flag) {
                        await _fireStore
                            .collection('users')
                            .doc(auth.currentUser.email)
                            .update({
                          'student of': FieldValue.arrayUnion([code])
                        });
                        await _fireStore
                            .collection('classes')
                            .doc(code)
                            .update({
                          'students':
                              FieldValue.arrayUnion([auth.currentUser.email])
                        });
                        Navigator.pop(context);
                        setState(() {});
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: AlertDialog(
                                title: Text('You are already in class!'),
                                content: Text(
                                    'Looks like you are already joined the class.'),
                                actions: [
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Okay'),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Center(
                            child: AlertDialog(
                              title: Text('Class not found'),
                              content: Text(
                                  'Class with given code does not found. Try to reach you teacher for correct code.'),
                              actions: [
                                FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      code = null;
                                    });

                                    Navigator.pop(context);
                                  },
                                  child: Text('Dismiss'),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text('Join')),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(5.0),
              child: Text('Enter the code given by your teacher'),
            ),
            Container(
              margin: EdgeInsets.all(5.0),
              child: TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Class code',
                ),
                onChanged: (value) {
                  code = value;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
