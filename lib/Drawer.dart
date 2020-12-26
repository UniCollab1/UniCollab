import 'package:flutter/material.dart';

class DrawerMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            child: Container(
              child: DrawerHeader(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.red,
                      backgroundImage: AssetImage('images/abc.png'),
                    ),
                    Text(
                      'Username',
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              color: Colors.blue,
            ),
            width: double.infinity,
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            title: Text(
              'Setting',
              style: TextStyle(fontSize: 20.0, color: Colors.black),
            ),
            onTap: null,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_identity,
              color: Colors.black,
            ),
            title: Text(
              'Your Profile',
              style: TextStyle(fontSize: 20.0, color: Colors.black),
            ),
            onTap: null,
          ),
          ListTile(
            leading: Icon(
              Icons.feedback,
              color: Colors.black,
            ),
            title: Text(
              'Feedback',
              style: TextStyle(fontSize: 20.0, color: Colors.black),
            ),
            onTap: null,
          ),
          ListTile(
            leading: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            title: Text(
              'Logout',
              style: TextStyle(fontSize: 20.0, color: Colors.black),
            ),
            onTap: null,
          ),
        ],
      ),
    );
  }
}
