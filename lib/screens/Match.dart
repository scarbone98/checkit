import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../components/ConditionalBuilder.dart';

enum MatchState { CONNECTING, SEARCHING, CONNECTED }

class Match extends StatefulWidget {
  final String roomId;

  Match({Key key, this.roomId}) : super(key: key);

  @override
  _MatchState createState() => _MatchState();
}

class _MatchState extends State<Match> {
  TextEditingController _controller = TextEditingController();
  WebSocketChannel _socketChannel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _socketChannel = IOWebSocketChannel.connect('ws://10.0.0.106:8080/ws',
        headers: {"room-id": widget.roomId});
    setState(() {});
  }

  Widget connectingState() {
    return Container();
  }

  Widget searchingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 200,
          width: 200,
          child: Container(
            color: Colors.amber,
          ),
        ),
        Text('Searching for match...')
      ],
    );
  }

  Widget matchedState(Map<String, dynamic> partnerData) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          print(snapshot);
                          break;
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
                  return Container(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text('No connection, please try again.'),
                          IconButton(
                            icon: Icon(Icons.refresh),
                            onPressed: () {},
                          )
                        ],
                      ),
                    ),
                  );
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
