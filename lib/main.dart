import 'package:eventor/screens/homePage.dart';
import 'package:eventor/screens/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/wrapper.dart';
import 'Authnetication/Authenticate.dart';
import 'package:eventor/screens/Welcome.dart';
import 'package:eventor/screens/register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
        value: user,
        child: MaterialApp(
        title: 'Eventor',
        theme: ThemeData.dark(),
        initialRoute: Wrapper.id,
        routes: {
          Wrapper.id: (context)=>Wrapper(),
          Welcome.id: (context)=>Welcome(),
          HomePage.id: (context)=>HomePage(),
          Register.id: (context)=>Register()
        },
      ),
    );
  }
}
