import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:checkit/screens/Match/MatchedState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../components/ConditionalBuilder.dart';
import 'package:flare_flutter/flare_actor.dart';

enum MatchState { CONNECTING, SEARCHING, CONNECTED }

class Match extends StatefulWidget {
  final String roomId;

  Match({Key key, this.roomId}) : super(key: key);

  @override
  _MatchState createState() => _MatchState();
}

enum ChatRenderSide { RIGHT, LEFT }

class _MatchState extends State<Match> {
  TextEditingController _controller = TextEditingController();
  WebSocketChannel _socketChannel;

  int colorIndex = 0;
  List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.pink,
    Colors.orange
  ];

  // CHATTING STUFF

  ScrollController _scrollController = ScrollController();
  TextEditingController _textEditingController = TextEditingController();

  List<Map<String, dynamic>> messages = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSocket();
  }

  void initSocket() {
    _socketChannel = IOWebSocketChannel.connect('ws://10.0.2.2:8080/ws',
        headers: {"room-id": widget.roomId});
  }

  Widget serverDisconnected() {
    return Container(
      child: Center(
        child: Text(
          'Server issues, please try again later.',
          style: prefix0.TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget connectingState() {
    return Container();
  }

  Widget renderMessage(String message, ChatRenderSide side) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          mainAxisAlignment: side == ChatRenderSide.RIGHT
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 1.5),
              padding: EdgeInsets.all(8),
              child: Text(
                message,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: side == ChatRenderSide.RIGHT ? Colors.blue : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chattingState() {
    Timer(
      Duration(milliseconds: 250),
      () =>
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent),
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                  controller: _scrollController,
                  children: List.generate(messages.length, (index) {
                    String from = messages[index]["from"];
                    String message = messages[index]["message"];
                    return renderMessage(
                        message,
                        from == "USER"
                            ? ChatRenderSide.RIGHT
                            : ChatRenderSide.LEFT);
                  })),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Send Message',
                      hintStyle: prefix0.TextStyle(color: Colors.white),
                    ),
                    controller: _textEditingController,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  tooltip: 'Send',
                  onPressed: () {
                    if (_textEditingController.text.isNotEmpty) {
                      _socketChannel.sink.add(
                        jsonEncode({
                          "Type": "SEND_MESSAGE",
                          "Payload": {"message": _textEditingController.text}
                        }),
                      );
                      _textEditingController.text = "";
                      setState(() {});
                    }
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget searchingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 200,
            child: FlareActor("assets/meteor.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: "Idle"),
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            'Searching for a match...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(
            height: 200,
          )
        ],
      ),
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
      body: ConditionalBuilder(
        conditional: _socketChannel != null,
        truthyBuilder: () {
          return Container(
            color: Colors.black87,
            child: StreamBuilder(
              stream: _socketChannel.stream,
              builder: (context, snapshot) {
                print(snapshot);
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                    Map<String, dynamic> data = jsonDecode(snapshot.data);
                    switch (data["Type"]) {
                      case "PARTNER_DECLINED":
                      case "DECLINED_MATCH":
                      case "NO_MATCH":
                      case "PARTNER_DISCONNECTED":
                        return searchingState();
                      case "MESSAGE_RECEIVED":
                        if (!messages.isNotEmpty) {
                          messages.add(data["Payload"]);
                        } else if (messages.last["time"] !=
                            data["Payload"]["time"]) {
                          messages.add(data["Payload"]);
                        }
                        continue joinedMatch;
                      joinedMatch:
                      case "JOINED_MATCH":
                        return chattingState();
                      case "MATCH_FOUND":
                      case "PARTNER_ACCEPTED":
                        return MatchedStateWidget(
                          acceptMatch: () => this.acceptMatch(),
                          declineMatch: () => this.declineMatch(),
                        );
                      case "JOINED_MATCH":
                        return joinedMatch();
                      case "ACCEPTED_MATCH":
                        return Container(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 200,
                                  child: FlareActor("assets/loading_orb.flr",
                                      alignment: Alignment.center,
                                      fit: BoxFit.contain,
                                      animation: "Aura"),
                                ),
                                Text(
                                  'Waiting for partner to accept...',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 200,
                                )
                              ],
                            ),
                          ),
                        );
                    }
                    break;
                  case ConnectionState.done:
                    return serverDisconnected();
                    break;
                  case ConnectionState.waiting:
                    return serverDisconnected();
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

  void acceptMatch() {
    _socketChannel.sink.add(
      jsonEncode({"Type": "ACCEPT_MATCH", "Payload": null}),
    );
  }

  void declineMatch() {
    _socketChannel.sink.add(
      jsonEncode({"Type": "DECLINE_MATCH", "Payload": null}),
    );
  }

  @override
  void dispose() {
    _socketChannel.sink.close();
    super.dispose();
  }
}
