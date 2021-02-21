import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Profile'),
        ),
        body: Container(
          color: Colors.black12,
          child: ListView(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: user.photoURL != null
                      ? NetworkImage(user.photoURL)
                      : null,
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                child: Text(
                  'Display name:',
                  style: GoogleFonts.sourceSansPro(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: Text(
                  user.displayName,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                child: Text(
                  'Email:',
                  style: GoogleFonts.sourceSansPro(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: Text(
                  user.email,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
