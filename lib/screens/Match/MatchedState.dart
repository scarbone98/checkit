import 'package:flutter/material.dart';
import 'dart:ui';
class MatchedStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.indigo,
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    'We found a match!',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: Container(
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            bottom: 25,
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(200),
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Stack(
                                    children: <Widget>[
                                      Image.network(
                                          "https://img.memecdn.com/just-imagine-this-hot-chick-xd-have-to-be-your-girlfriend_o_2275557.jpg"),
                                      Positioned.fill(
                                        child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 20, sigmaY: 20),
                                            child: Container(
                                                color: Colors.black
                                                    .withOpacity(0))),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            child: Container(
                              constraints:
                                  BoxConstraints(maxHeight: 50, maxWidth: 100),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: Text(
                                  '4.98',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            alignment: Alignment.bottomCenter,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
