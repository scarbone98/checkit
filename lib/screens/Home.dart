import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import '../Router.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String barcode = "";
  bool hasError = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scan();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(barcode),
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      if (barcode.length > 0) {
        Map<String, dynamic> data = jsonDecode(barcode);
        Navigator.of(context).pushNamed('/match',
            arguments: MatchPageArguments(roomId: data['name']));
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          hasError = true;
        });
      } else {
        setState(() => hasError = true);
      }
    } on FormatException {
      setState(() => hasError = true);
    } catch (e) {
      setState(() => hasError = true);
    }
  }
}
