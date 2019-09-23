import 'package:flutter/material.dart';
import 'screens/Login.dart';
import 'screens/Home.dart';
import 'screens/Match.dart';

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
            child: child),
      ),
    );
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => WidgetWrapper(
            child: Login(),
            bottomBar: true,
            pageTitle: 'Login',
          ),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => WidgetWrapper(
            child: Home(),
            pageTitle: 'Home',
          ),
        );
        break;
      case '/match':
        MatchPageArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => WidgetWrapper(
            child: Match(roomId: args.roomId),
            pageTitle: 'Match',
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
