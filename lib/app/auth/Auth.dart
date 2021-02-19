import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unicollab/app/auth/SignIn.dart';

import '../home/home.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key key, @required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<User> userSnapshot;
  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.waiting) {
      return Scaffold(
        body: Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    } else if (userSnapshot.connectionState == ConnectionState.active) {
      return userSnapshot.hasData ? HomePage() : SignInPage();
    }
    return Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}
