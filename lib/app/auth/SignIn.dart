import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/services/firebase_auth_service.dart';

class SignInPage extends StatelessWidget {
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final auth = Provider.of<FirebaseAuthService>(context, listen: false);
      await auth.signInWithGoogle();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: FittedBox(
                  child: Text(
                    'UNICOLLAB',
                    style: GoogleFonts.poppins(
                      fontSize: 80,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Container(
                child: ElevatedButton(
                  child: Text('Continue with Google'),
                  onPressed: () => _signInWithGoogle(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
