import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sweetalert/sweetalert.dart';

class Join {
  final _firestore = FirebaseFirestore.instance;
  String name;
  FirebaseAuth auth = FirebaseAuth.instance;
  String code;

  joinAlert(BuildContext context) {
    Navigator.pop(context);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Join Class"),
          content: TextField(
            decoration: InputDecoration(
              hintText: "Enter Code",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
            onChanged: (value) {
              code = value;
            },
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancle",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            FlatButton(
              onPressed: () async {
                try {
                  var event = await _firestore
                      .collection('classes')
                      .where("code", isEqualTo: code)
                      .get();
                  //if class code is not found
                  if (event.docs.isNotEmpty) {
                    var event1 = await _firestore
                        .collection('JoinedClasses')
                        .where("code", isEqualTo: code)
                        .where("name", isEqualTo: auth.currentUser.email)
                        .get();
                    //If already join class
                    if (event1.docs.isEmpty) {
                      await _firestore.collection('JoinedClasses').add(
                        {
                          'code': code,
                          'name': auth.currentUser.email,
                        },
                      );
                    } else {
                      print("already in");
                      print(auth.currentUser.email);
                    }
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    SweetAlert.show(
                      context,
                      title: "No class Found",
                      subtitle: "Enter Valid code",
                      style: SweetAlertStyle.error,
                    );
                  }
                } catch (e) {
                  print(e);
                }
              },
              child: Text(
                "Join",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        );
      },
    );
  }
}
