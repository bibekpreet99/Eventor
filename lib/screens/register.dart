import 'package:flutter/material.dart';
import 'package:eventor/constants.dart';
import 'package:eventor/screens/Welcome.dart';
import 'package:eventor/Authnetication/Authenticate.dart';
import 'package:eventor/screens/homePage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {

  static const id = 'register';
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return user!=null?HomePage():Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        centerTitle: true,
        leading: Container(),
      ),
      body: Padding(
          padding: const EdgeInsets.only(left:30.0, right: 30),
          child: Center(
            child: SingleChildScrollView(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 40),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: kTextFormFieldDecoration.copyWith(
                      hintText: 'Email'
                    ),
                    onChanged: (newVal){
                      setState(() {
                        email = newVal;
                      });
                    },
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    obscureText: true,
                    decoration: kTextFormFieldDecoration.copyWith(
                      hintText: 'Password'
                    ),
                    onChanged: (newVal){
                      setState(() {
                        password = newVal;
                      });
                    },
                  ),
                  SizedBox(height: 20,),
                  FlatButton(
                    onPressed: () async {
                      final user = await registerUser(email, password);
                      if(user!=null)
                      {
                        Navigator.pushNamed(context, HomePage.id);
                      }
                    },
                    child: Text('Register', style: TextStyle(fontSize: 20),),
                    color: Colors.red,
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Have an account? ",
                      ),
                      InkWell(
                          child: Text(
                          "Sign in",
                          style: TextStyle(
                            color: Colors.red
                          ),
                        ),
                        onTap: (){
                          Navigator.pushNamed(context, Welcome.id);
                        },
                      ),
                    ],
                    ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}