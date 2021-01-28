import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  var fireStore = FirebaseFirestore.instance;

  var fcon = new TextEditingController();
  var scon = new TextEditingController();
  var econ = new TextEditingController();

  File _image;
  String imageurl;

  Future getImage() async {
    print("in getImage");
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

        print("Image path $_image");
      } else {
        print('No image selected.');
      }
    });

    updateImage(context);
  }

  void initState() {
    super.initState();
    imageurl =
        "https://firebasestorage.googleapis.com/v0/b/collab-627c8.appspot.com/o/images%2Fdownload.jpg?alt=media&token=a4f8c09d-af58-45f2-a34c-5c05eb007334";
    getUserDetail();
  }

  void getUserDetail() async {
    var qn =
        await fireStore.collection('users').doc(auth.currentUser.email).get();

    fcon.text = qn.get("first name");
    scon.text = qn.get("last name");
    econ.text = auth.currentUser.email;

    imageurl =
        await storage.ref('images/' + auth.currentUser.email).getDownloadURL();
    setState(() {
      print("get image");
    });
  }

  void updateImage(BuildContext context) async {
    String fileName = 'images/' + auth.currentUser.email;
    await storage.ref(fileName).putFile(_image);
    print("profile picture uploaded");
    imageurl = await storage.ref(fileName).getDownloadURL();

    setState(() {
      print('File Uploaded');
    });
  }

  void updateUserDetail() async {
    await fireStore
        .collection('users')
        .doc(auth.currentUser.email)
        .update({'first name': fcon.text, 'last name': scon.text})
        .then((value) => print("User updated"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
        actions: [
          Container(
            margin: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                updateUserDetail();
              },
              child: Text('Update'),
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: (_image != null)
                              ? FileImage(_image)
                              : NetworkImage(
                                  imageurl,
                                ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            getImage();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Container(
                margin: EdgeInsets.all(5.0),
                child: TextField(
                  controller: fcon,
                  decoration: InputDecoration(
                    labelText: "First name",
                    filled: true,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(5.0),
                child: TextField(
                  controller: scon,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: "Last name",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(5.0),
                child: TextField(
                  controller: econ,
                  decoration: InputDecoration(
                    enabled: false,
                    labelText: "Email",
                    filled: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
