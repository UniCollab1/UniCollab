import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          title: Text(
            'Your Profile',
            style: TextStyle(
              fontSize: 30.0,
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(30.0),
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
                  style: TextStyle(
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
                  style: TextStyle(
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
