import 'dart:convert';
import 'dart:ui';

import 'package:checkit/screens/Match/MatchedState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../components/ConditionalBuilder.dart';

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
  }

  Widget connectingState() {
    return Container();
  }

  Widget searchingState() {
    return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 200,
                width: 200,
                child: Container(
                  color: Colors.red,
                ),
              ),
              Text('Searching for a match...'),
              SizedBox(
                height: 200,
              )
            ],
          ),
        ));
  }

  Widget matchedState({Map<String, dynamic> partnerData = null}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MatchedStateWidget(),
        SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              customBorder: Border(bottom: BorderSide(
                  color: Colors.black, width: 10, style: BorderStyle.solid)),
              child: Container(
                color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Accept",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              borderRadius: BorderRadius.circular(2),
              onTap: () {
                _socketChannel.sink
                    .add(jsonEncode({"Type": "ACCEPT_MATCH", "Payload": null}));
              },
            ),
            InkWell(
              child: Container(
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Accept",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              borderRadius: BorderRadius.circular(2),
              onTap: () {
                _socketChannel.sink
                    .add(
                    jsonEncode({"Type": "DECLINE_MATCH", "Payload": null}));
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget joinedMatch() {
    return Container(
      child: Center(child: Text('YO! YOU JOINED A MATCH')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ConditionalBuilder(
          conditional: _socketChannel != null,
          truthyBuilder: () {
            return Container(
              child: StreamBuilder(
                stream: _socketChannel.stream,
                builder: (context, snapshot) {
                  print(snapshot);
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                      Map<String, dynamic> data = jsonDecode(snapshot.data);
                      switch (data["Type"]) {
                        case "NO_MATCH":
                          return searchingState();
                        case "MATCH_FOUND":
                          return matchedState();
                        case "JOINED_MATCH":
                          return joinedMatch();
                      }
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
              ),
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
          },
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
