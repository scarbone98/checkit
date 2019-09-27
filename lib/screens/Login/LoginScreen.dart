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
    return Column(
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
        SizedBox(
          height: MediaQuery.of(context).size.height / 5,
        ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Button(
              onPressed: () => _signIn(),
              text: 'Login',
              fillColor: Colors.greenAccent,
            ),
          ],
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
            onTap: () => widget.goToSignUp(),
          ),
        ),
      ],
    );
  }
}
