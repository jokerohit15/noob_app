import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:noob_app/authetication.dart';

class SignupButton extends StatelessWidget {
  SignupButton(this.user);
  final User user;

  Future<void> signInWithGoogle() async {
    await Authentification().signInWithGoogle();
  }

  Future<void> signOut() async {
    await Authentification().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          FontAwesomeIcons.google,
          color: Colors.white,
        ),
        onPressed: () {
          if (user == null)
            signInWithGoogle();
          else
            signOut();
        });
  }
}
