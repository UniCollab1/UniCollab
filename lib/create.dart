import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Create {
  final _firestore = FirebaseFirestore.instance;
  String name;
  FirebaseAuth auth = FirebaseAuth.instance;
  String code;

  createAlert(BuildContext context) async {
    code = randomAlphaNumeric(7);

    // If by chance code is already generated.
    try {
      while (true) {
        var event = await _firestore
            .collection('classes')
            .where("code", isEqualTo: code)
            .get();
        if (event.docs.isNotEmpty) {
          code = randomAlphaNumeric(7);
        } else {
          break;
        }
      }
    } catch (e) {
      print(e);
    }

    Navigator.pop(context);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Create Class"),
          content: TextField(
            decoration: InputDecoration(
              hintText: "Enter ClassName",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
            onChanged: (value) {
              name = value;
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
                  await _firestore.collection('classes').add({
                    'code': code,
                    'name': name,
                    'createby': auth.currentUser.email
                  });
                  await _firestore.collection('JoinedClasses').add(
                    {
                      'code': code,
                      'name': auth.currentUser.email,
                    },
                  );
                  Navigator.pop(context);
                } catch (e) {
                  print(e);
                }
              },
              child: Text(
                "Create",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        );
      },
    );
  }
}
