import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:checkit/Router.dart';

class LoginScreen extends StatefulWidget {
  final Function goToSignUp;
  final FirebaseAuth auth;

  LoginScreen({@required this.goToSignUp, @required this.auth});

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
    try {
      final FirebaseUser user = (await widget.auth.signInWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      ))
          .user;
      Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
    } catch (e) {
      print(e.toString());
      setState(() {
        _error = e;
      });
    }
//    Navigator.pushNamed(context, "/match",
//        arguments: MatchPageArguments(roomId: "purdue-brother's"));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned.fill(
          top: -10,
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
          padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
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
                  if (_error != null) ...[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            _error.message,
                            style: TextStyle(
                                fontSize: 18, color: Colors.redAccent),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Email'),
                    controller: _email,
                    focusNode: _emailNode,
                    onFieldSubmitted: (term) {
                      _emailNode.unfocus();
                      FocusScope.of(context).requestFocus(_passwordNode);
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () => setState(
                            () => _passwordVisible = !_passwordVisible),
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    controller: _password,
                    focusNode: _passwordNode,
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
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
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
                      GestureDetector(
                        onTap: () => widget.goToSignUp(),
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
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
