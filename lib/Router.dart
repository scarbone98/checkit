import 'package:flutter/material.dart';
import 'screens/Login.dart';
import 'screens/Home.dart';
import 'screens/Match.dart';

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
      resizeToAvoidBottomInset: false,
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
      default:
        return MaterialPageRoute(
          builder: (_) => WidgetWrapper(child: Login()),
        );
    }
  }
}
