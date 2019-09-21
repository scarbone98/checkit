import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _userName = TextEditingController();
  TextEditingController _password = TextEditingController();
  FocusNode _usernameNode = FocusNode();
  FocusNode _passwordNode = FocusNode();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(color: Colors.yellow),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(hintText: 'Email'),
              textInputAction: TextInputAction.next,
              controller: _userName,
              focusNode: _usernameNode,
              onFieldSubmitted: (term) {
                _usernameNode.unfocus();
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
              onTap: () => Navigator.pushNamed(context, '/home'),
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
