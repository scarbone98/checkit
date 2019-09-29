import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:checkit/Router.dart';
import '../../components/Button.dart';

class LoginScreen extends StatefulWidget {
  final Function goToSignUp;

  LoginScreen({@required this.goToSignUp});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  FocusNode _emailNode = FocusNode();
  FocusNode _passwordNode = FocusNode();
  bool _passwordVisible = false;
  PlatformException _error;

  void _signIn() async {
//    try {
//      final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
//        email: _email.text,
//        password: _password.text,
//      ))
//          .user;
//      Navigator.pushNamed(context, '/home');
//    } catch (e) {
//      setState(() {
//        _error = e;
//      });
//    }
    Navigator.pushNamed(context, "/match",
        arguments: MatchPageArguments(roomId: "purdue-brother's"));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned.fill(
          top: 0,
          left: -70,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: FlareActor(
              "assets/flow_background.flr",
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: "Flow",
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 150,
                  ),
                  Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Welcome',
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                          Text(
                            'Back',
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Email'),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Password'),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign In',
                        style:
                            TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.8),
                        ),
                        width: 75,
                        height: 75,
                        child: IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_right,
                            size: 35,
                            color: Colors.white,
                          ),
                          onPressed: () => this._signIn(),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 75,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign up',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Forgot Password',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
