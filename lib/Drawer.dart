import 'package:flutter/material.dart';

class DrawerMain extends StatefulWidget {
  @override
  _DrawerMainState createState() => _DrawerMainState();
}

class _DrawerMainState extends State<DrawerMain> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: EdgeInsets.zero,
            child: DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 35.0,
                    backgroundColor: Colors.blue,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'someone',
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'someone@gmail.com',
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.account_circle,
            ),
            title: Text(
              'Your Profile',
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
            ),
            title: Text(
              'Setting',
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.feedback,
            ),
            title: Text(
              'Feedback',
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
            ),
            title: Text(
              'Logout',
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
