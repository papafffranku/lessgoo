import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lessgoo/firesign/GoogleSignInProvider.dart';
import 'package:provider/provider.dart';

class abc extends StatefulWidget {
  const abc({Key? key}) : super(key: key);

  @override
  _abcState createState() => _abcState();
}

class _abcState extends State<abc> {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white12,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SignInButton(Buttons.Google, onPressed: () {
                goochapati();
              }),
              SignInButton(Buttons.AppleDark, onPressed: () {}),
              CupertinoButton(
                  child: Text('Sign up with Username and password'),
                  onPressed: () {})
            ],
          ),
        ),
      ),
    );
  }

  Future goochapati() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

  }
}
