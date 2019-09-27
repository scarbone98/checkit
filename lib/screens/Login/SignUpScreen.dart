import 'package:flutter/material.dart';
import '../../components/Button.dart';

class SignUpScreen extends StatefulWidget {
  final Function goBackToLogin;
  SignUpScreen({@required this.goBackToLogin});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _passwordRetype = TextEditingController();

  String _selectedGender;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedGender = "None";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              widget.goBackToLogin();
            },
          ),
          top: -10,
          left: -15,
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: 25,
            ),
            TextFormField(
              decoration: InputDecoration(hintText: 'First Name'),
              controller: _firstName,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(hintText: 'Last Name'),
              controller: _lastName,
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text("Select Gender"),

                  value: _selectedGender,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                  items: ['None', 'Male', 'Female'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(hintText: 'Password'),
              controller: _password,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(hintText: 'Re-type password'),
              controller: _passwordRetype,
            ),
            SizedBox(
              height: 50,
            ),
            Button(
              text: 'Create',
              onPressed: () {},
            )
          ],
        ),
      ],
    );
  }
}
