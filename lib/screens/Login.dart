import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../Router.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  FocusNode _emailNode = FocusNode();
  FocusNode _passwordNode = FocusNode();
  bool _passwordVisible = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  PlatformException _error;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth.currentUser().then((user) {
      Navigator.pushNamed(context, '/home');
    });
  }

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
    Navigator.pushNamed(context, "/match", arguments: MatchPageArguments(roomId: "purdue-brother's"));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
        decoration: BoxDecoration(color: Colors.yellow),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_error != null) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Error',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _error.message,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              )
            ],
            TextFormField(
              decoration: InputDecoration(hintText: 'Email'),
              textInputAction: TextInputAction.next,
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
              focusNode: _passwordNode,
              decoration: InputDecoration(
                  hintText: 'Password',
                  suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _passwordVisible = !_passwordVisible),
                      icon: Icon(!_passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off))),
              controller: _password,
              obscureText: !_passwordVisible,
            ),
            SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: () => _signIn(),
              child: Container(
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18),
                ),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.indigoAccent),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              child: GestureDetector(
                child: Text(
                  'Don\'t have an account? Sign up.',
                  style: TextStyle(color: Colors.lightBlueAccent),
                ),
                onTap: () => print('Create a new accout'),
              ),
            ),
            SizedBox(
              height: 150,
            )
          ],
        ),
      ),
    );
  }
}
