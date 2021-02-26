import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/app/Drawer/Profile.dart';
import 'package:unicollab/services/firebase_auth_service.dart';

class DrawerMain extends StatefulWidget {
  @override
  _DrawerMainState createState() => _DrawerMainState();
}

class _DrawerMainState extends State<DrawerMain> {
  var isTheme = false;
  Future<void> signOut() async {
    try {
      var auth = Provider.of<FirebaseAuthService>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  adjustText(String text) {
    if (text.length > 25) {
      return text.substring(0, 22) + "...";
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context, listen: false);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: EdgeInsets.zero,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: user.photoURL != null
                        ? NetworkImage(user.photoURL)
                        : null,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: Text(
                      user.displayName,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.caption.color,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Expanded(
                    child: Text(
                      adjustText(user.email),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.caption.color,
                        fontSize: 15.0,
                      ),
                    ),
                  )
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
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
              Icons.wb_sunny,
            ),
            title: Text(
              'Dark Mode',
            ),
            trailing: Switch(
              value: isTheme,
              onChanged: (value) {
                AdaptiveTheme.of(context).toggleThemeMode();
              },
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
            ),
            title: Text(
              'Logout',
            ),
            onTap: () {
              signOut();
            },
          ),
        ],
      ),
    );
  }
}
