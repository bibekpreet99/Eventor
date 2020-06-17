import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homePage.dart';
import 'Welcome.dart';

class Wrapper extends StatelessWidget {

  static const id = 'wrapper';
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return user==null?Welcome():HomePage();
  }
}