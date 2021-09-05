import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lessgoo/loginsignup/NewUserDetail.dart';

class fireauthhelp {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final usersRef = FirebaseFirestore.instance.collection('users');
  final DateTime timestamp = DateTime.now();

  //google auth
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLoginHelp(BuildContext context) async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    var authResult = await _auth.signInWithCredential(credential);
    if (authResult.additionalUserInfo!.isNewUser) {
      //new user
      createUserInFirestore(context);
    }
  }

  //gives searchIndex to users which splits strings for better search query
  searchIndex(String name) async {
    List<String> indexList = [];
    List<String> splitList = name.split(' ');
    for (int i = 0; i < splitList.length; i++) {
      for (int j = 0; j < splitList[i].length + i; j++) {
        indexList.add(splitList[i].substring(0, j).toLowerCase());
      }
    }

    return indexList;
  }

  Future GoogleLogout() async {
    await googleSignIn.disconnect();
    return _auth.signOut();
  }

  //Create User in Firestore
  createUserInFirestore(BuildContext context) async {
    final fyeuser = FirebaseAuth.instance.currentUser!;
    final DocumentSnapshot doc = await usersRef.doc(fyeuser.uid).get();

    if (!doc.exists) {
      usersRef.doc(fyeuser.uid).set({
        "id": fyeuser.uid,
        "username": fyeuser.displayName,
        "avatarUrl":
            'https://firebasestorage.googleapis.com/v0/b/jvsnew-93e01.appspot.com/o/template%2FprofilePlaceholder.png?alt=media&token=42a5e4b3-175e-4b59-8aed-52ac8d93f5ae',
        "email": fyeuser.email,
        "bio": '-',
        "tag": '',
        "socialfb": '',
        "socialig": '',
        "songs": 0,
        "followers": 0,
        "following": 0,
        "timestamp": timestamp,
      });
    }
  }
}
