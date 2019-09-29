import 'dart:async';

import 'package:checkit/components/Button.dart';
import 'package:checkit/components/RadialPainter.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class MatchedStateWidget extends StatefulWidget {
  final Function declineMatch;
  final Function acceptMatch;

  MatchedStateWidget({@required this.declineMatch, @required this.acceptMatch});

  @override
  _MatchedStateWidgetState createState() => _MatchedStateWidgetState();
}

class _MatchedStateWidgetState extends State<MatchedStateWidget>
    with TickerProviderStateMixin {
  double percentage = 0.0;
  double newPercentage = 0.0;
  AnimationController percentageAnimationController;
  AnimationController slideAnimationController;
  Animation<Offset> _slideAnimationValue;
  bool _isInitialized = false;
  Timer _timer;

  Widget getBlurredImage() {
    return SizedBox(
      height: 135,
      width: 135,
      child: Container(
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Stack(
                      children: <Widget>[
                        Image.network(
                            "https://img.memecdn.com/just-imagine-this-hot-chick-xd-have-to-be-your-girlfriend_o_2275557.jpg"),
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Container(
                              color: Colors.black.withOpacity(0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      percentage = 0.0;
    });
    percentageAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1000))
      ..addListener(() {
        setState(() {
          percentage = lerpDouble(
              percentage, newPercentage, percentageAnimationController.value);
        });
      });
    slideAnimationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _slideAnimationValue =
        Tween<Offset>(begin: Offset(0.0, -2.0), end: Offset.zero)
            .animate(slideAnimationController);
    _slideAnimationValue.addListener(() => setState(() {}));
    slideAnimationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    percentageAnimationController.dispose();
    slideAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (newPercentage > 100) {
            widget.declineMatch();
          }
          percentage = newPercentage;
          newPercentage += 100 / 60;
          percentageAnimationController.forward(from: 0.0);
        });
      });
      _isInitialized = true;
    }
    return SlideTransition(
      position: _slideAnimationValue,
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            constraints: BoxConstraints(
                minWidth: double.infinity, minHeight: 450, maxHeight: 500),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 75,
                  ),
                  CustomPaint(
                    foregroundPainter: RadialPainter(
                      lineColor: Colors.transparent,
                      completeColor: Colors.redAccent,
                      completePercent: percentage,
                      width: 8.0,
                    ),
                    child: getBlurredImage(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    constraints: BoxConstraints(maxHeight: 40, maxWidth: 75),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '4.98',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Hot Bitch',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    'likes sri lankan men that work for apple',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            '68',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'matches',
                            style: TextStyle(color: Colors.white70),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Button(
                        text: 'Accept',
                        borderColor: Colors.white,
                        onPressed: () => widget.acceptMatch(),
                      ),
                      Button(
                        text: 'Decline',
                        fillColor: Colors.redAccent,
                        onPressed: () => widget.declineMatch(),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
