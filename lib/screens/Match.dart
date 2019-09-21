import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, @required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();
  List<String> messages = List();
  WebSocketChannel _socketChannel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _socketChannel = IOWebSocketChannel.connect('ws://10.0.2.2:8080/ws',
        headers: {"room-id": "1"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ConditionalBuilder(
                conditional: _socketChannel != null,
                truthyBuilder: () {
                  return StreamBuilder(
                    stream: _socketChannel.stream,
                    builder: (context, snapshot) {
                      print(snapshot);
                      switch (snapshot.connectionState) {
                        case ConnectionState.active:
                          return ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children:
                            List<Widget>.generate(messages.length, (index) {
                              return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  child: Text(messages[index]));
                            }),
                          );
                        case ConnectionState.done:
                          break;
                        case ConnectionState.waiting:
                          break;
                        case ConnectionState.none:
                          break;
                      }
                      return Container();
                    },
                  );
                },
                falsyBuilder: () {
                  return Container();
                })
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _socketChannel.sink.add(jsonEncode({
        "Type": "normal",
        "Payload": {"test": _controller.text}
      }));
    }
  }

  @override
  void dispose() {
    _socketChannel.sink.close();
    super.dispose();
  }
}

class ConditionalBuilder extends StatelessWidget {
  final bool conditional;
  final Function falsyBuilder;
  final Function truthyBuilder;

  ConditionalBuilder({
    @required this.conditional,
    @required this.truthyBuilder,
    @required this.falsyBuilder,
  })  : assert(conditional != null),
        assert(truthyBuilder != null),
        assert(falsyBuilder != null);

  @override
  Widget build(BuildContext context) =>
      conditional ? truthyBuilder() : falsyBuilder();
}