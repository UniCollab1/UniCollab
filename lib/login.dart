import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool _passwordVisible = true;
  String email, password;
  static String errEmail, errPassword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: 25.0, right: 25.0),
                child: Image(
                  image: AssetImage('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                onChanged: (value) {
                  email = value.trim();
                  errEmail = null;
                },
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  String p =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  if (value.isEmpty) {
                    return 'Please enter email';
                  }
                  RegExp regExp = new RegExp(p);
                  if (!regExp.hasMatch(value)) {
                    return 'Please enter email in proper format';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: errEmail,
                  icon: Icon(Icons.email),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                onChanged: (value) {
                  password = value;
                  errPassword = null;
                },
                obscureText: _passwordVisible,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(Icons.vpn_key_sharp),
                  errorText: errPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Container(
                width: 300.0,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: CircularProgressIndicator(
                                semanticsLabel: 'Logging you in',
                              ),
                            );
                          });
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        if (user != null) {
                          Navigator.pop(context);
                          print("Successfully Logged in");
                          Navigator.pushNamed(context, 'homepage');
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                child: AlertDialog(
                                  title: Text('Do you want to register?'),
                                  content: Text(
                                      'Looks like that you are new to Unicollab. Click register to continue with our services.'),
                                  actions: [
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: Text('CANCEL'),
                                    ),
                                    FlatButton(
                                      onPressed: () async {
                                        try {
                                          final newUser = await _auth
                                              .createUserWithEmailAndPassword(
                                                  email: email,
                                                  password: password);
                                          if (newUser != null) {
                                            Navigator.pop(context);
                                            print("Successfully registered");
                                            Navigator.pushNamed(
                                                context, 'homepage');
                                          }
                                        } on FirebaseAuthException catch (e) {
                                          if (e.code == 'weak-password') {
                                            setState(() {
                                              errPassword = e.message;
                                            });
                                            print(
                                                'Please enter strong password');
                                            Navigator.pop(context);
                                          }
                                        }
                                      },
                                      child: Text('REGISTER'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else if (e.code == 'wrong-password') {
                          setState(() {
                            errPassword = e.message;
                          });
                          print(errPassword);
                          Navigator.pop(context);
                        }
                        //Navigator.pop(context);
                      } catch (e) {
                        print(e);
                        print('in catch');
                      }
                    }
                  },
                  child: Text('CONTINUE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
