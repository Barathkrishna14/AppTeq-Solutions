import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dashboard.dart';

class AlertWithButtons extends StatefulWidget {
  String uri;

  AlertWithButtons({super.key, required this.uri});

  late QRViewController controller;

  void Confirm() async {
    if (await canLaunchUrl(uri as Uri)) {
      await launchUrl(uri as Uri);
      controller.resumeCamera();
    }
  }

  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert Dialog Title Text.'),
          content: Text("Are You Sure Want To Proceed ?"),
          actions: <Widget>[
            ElevatedButton(
              child: Text("YES"),
              onPressed: () => Confirm(),
            ),
            ElevatedButton(
              child: Text("NO"),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => Dashboard()));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    showAlert(context);
    throw UnimplementedError();
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
