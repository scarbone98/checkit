import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'LoginScreen.dart';
import 'SignUpScreen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int _selectedTabIndex;

  void goBackToLogin() {
    setState(() {
      _selectedTabIndex = 0;
    });
  }

  void goToSignUp() {
    setState(() {
      _selectedTabIndex = 1;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedTabIndex = 0;
//    _auth.currentUser().then((user) {
//      Navigator.pushNamed(context, '/home');
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
      child: AnimatedCrossFade(

        crossFadeState: _selectedTabIndex == 0 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: Duration(milliseconds: 300),
        firstChild: Container(
          child: Column(
            children: <Widget>[
              LoginScreen(
                goToSignUp: () => this.goToSignUp(),
              ),
            ],
          ),
        ),
        secondChild:Container(
          child: Column(
            children: <Widget>[
              SignUpScreen(
                goBackToLogin: () => this.goBackToLogin(),
              )
            ],
          ),
        ) ,
      ),
    );
  }
}