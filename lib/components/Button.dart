import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color fillColor;
  final Color splashColor;
  final Color borderColor;

  Button(
      {@required this.onPressed,
      @required this.text,
      this.fillColor,
      this.splashColor,
      this.borderColor});

  Widget getMaterialButton() {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
            border: borderColor != null
                ? Border.all(color: borderColor, width: 3.0)
                : Border.all(color: Colors.transparent, width: 3.0),
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: fillColor != null ? fillColor : null),
        child: InkWell(
          //This keeps the splash effect within the circle
          borderRadius: BorderRadius.circular(1000.0),
          //Something large to ensure a circle
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.fromLTRB(40, 10.0, 40, 10.0),
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return getMaterialButton();
  }
}
