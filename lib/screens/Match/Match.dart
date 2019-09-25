import 'dart:async';
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

enum ChatRenderSide { RIGHT, LEFT }

class _MatchState extends State<Match> {
  TextEditingController _controller = TextEditingController();
  WebSocketChannel _socketChannel;

  // CHATTING STUFF

  ScrollController _scrollController = ScrollController();
  TextEditingController _textEditingController = TextEditingController();

  List<Map<String, dynamic>> messages = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _socketChannel = IOWebSocketChannel.connect('ws://10.0.2.2:8080/ws',
        headers: {"room-id": widget.roomId});
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
                  maxWidth: MediaQuery.of(context).size.width / 2),
              padding: EdgeInsets.all(8),
              child: Text(
                message,
                style: TextStyle(fontSize: 16),
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
        () => _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent));

    return Container(
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
                  decoration: InputDecoration(hintText: 'Send Message'),
                  controller: _textEditingController,
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                tooltip: 'Send',
                onPressed: () {
                  if (_textEditingController.text.isNotEmpty) {
                    messages.add({
                      "message": _textEditingController.text,
                      "from": "USER"
                    });
                    _socketChannel.sink.add(
                      jsonEncode({"Type": "SEND_MESSAGE", "Payload": {"message":_textEditingController.text}}),
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
    );
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
              customBorder: Border(
                bottom: BorderSide(
                    color: Colors.black, width: 10, style: BorderStyle.solid),
              ),
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
              onTap: () => _socketChannel.sink
                  .add(jsonEncode({"Type": "ACCEPT_MATCH", "Payload": null})),
            ),
            InkWell(
              child: Container(
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Decline",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              borderRadius: BorderRadius.circular(2),
              onTap: () => _socketChannel.sink
                  .add(jsonEncode({"Type": "DECLINE_MATCH", "Payload": null})),
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
                        case "PARTNER_DECLINED":
                        case "DECLINED_MATCH":
                        case "NO_MATCH":
                        case "PARTNER_DISCONNECTED":
                          return searchingState();
                        case "MESSAGE_RECEIVED":
                          messages.add(data["Payload"]);
                          continue joinedMatch;
                        joinedMatch:
                        case "JOINED_MATCH":
                          return chattingState();
                        case "MATCH_FOUND":
                        case "PARTNER_ACCEPTED":
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
