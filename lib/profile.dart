import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Setting UI",
      home: EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  var fname, sname, email;
  var fcon = new TextEditingController();
  var scon = new TextEditingController();
  var econ = new TextEditingController();
  var pcon = new TextEditingController();
  bool isPasswordTextField = true;
  bool showPassword = false;

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
    var firestore = FirebaseFirestore.instance;
    var qn = await firestore
        .collection('users')
        .where("email", isEqualTo: auth.currentUser.email)
        .get();

    for (var a in qn.docs) {
      print(a.get("first name"));
      fname = a.get("first name");
      fcon.text = fname;
      sname = a.get("last name");
      scon.text = sname;
      email = auth.currentUser.email;
      econ.text = email;
      print(email);
    }

    imageurl =
        await storage.ref('images/' + auth.currentUser.email).getDownloadURL();
    setState(() {});
  }

  void updateImage(BuildContext context) async {
    String fileName = 'images/' + auth.currentUser.email;
    await storage.ref(fileName).putFile(_image);

    setState(() async {
      print("profile picture uploaded");
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("profile picture uploaded")));
      imageurl = await storage.ref(fileName).getDownloadURL();
    });
    print('File Uploaded');
  }

  void updateUserDetail(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users
        .doc(auth.currentUser.email)
        .update({'first name': fcon.text, 'last name': scon.text})
        .then((value) => print("User updated"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[350],
        elevation: 5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Edit Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: (_image != null)
                                  ? FileImage(_image)
                                  : NetworkImage(
                                      imageurl,
                                    ))),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: TextField(
                  controller: fcon,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 3),
                      labelText: "First Name",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: fname,
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: TextField(
                  controller: scon,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 3),
                      labelText: "Second Name",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: sname,
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: TextField(
                  controller: econ,
                  decoration: InputDecoration(
                      enabled: false,
                      contentPadding: EdgeInsets.only(bottom: 3),
                      labelText: "Email",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: email,
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: TextField(
                  controller: pcon,
                  obscureText: isPasswordTextField ? showPassword : false,
                  decoration: InputDecoration(
                      suffixIcon: isPasswordTextField
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: Colors.blue,
                              ),
                            )
                          : null,
                      contentPadding: EdgeInsets.only(bottom: 3),
                      labelText: "password",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: "*********",
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlineButton(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("CANCEL",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black)),
                  ),
                  RaisedButton(
                    onPressed: () {
                      updateUserDetail(context);
                      FocusScope.of(context).unfocus();

                      setState(() {
                        fname = fcon.text;
                        sname = scon.text;
                        email = econ.text;

                        //getClass();
                      });
                    },
                    color: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
