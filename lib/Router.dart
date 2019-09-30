import 'package:checkit/screens/Home.dart';
import 'package:flutter/material.dart';

import 'screens/Login/LandingPage.dart';
import 'screens/Match/Match.dart';
import 'screens/Profile/ProfilePage.dart';

class MatchPageArguments {
  final String roomId;

  MatchPageArguments({this.roomId});
}

class WidgetWrapper extends StatelessWidget {
  final Widget child;
  final String pageTitle;
  final bool bottomBar;

  const WidgetWrapper(
      {Key key, @required this.child, this.bottomBar = false, this.pageTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: child,
        ),
      ),
    );
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Login(),
            resizeToAvoidBottomInset: false,
          ),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => DefaultTabController(
            initialIndex: 2,
            length: 3,
            child: Scaffold(
              backgroundColor: Colors.white,
              bottomNavigationBar: TabBar(
                tabs: <Widget>[
                  Tab(icon: Icon(Icons.history)),
                  Tab(icon: Icon(Icons.camera_alt)),
                  Tab(icon: Icon(Icons.person)),
                ],
              ),
              body: TabBarView(
                children: <Widget>[
                  Home(),
                  Home(),
                  ProfilePage()
                ],
              )
            ),
          ),
        );
        break;
      case '/match':
        MatchPageArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Match(roomId: args.roomId),
          ),
        );
        break;
      default:
        return MaterialPageRoute(
          builder: (_) => WidgetWrapper(child: Login()),
        );
    }
  }
}
