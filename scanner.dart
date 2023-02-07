import 'package:appteq_solutions/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class Scanner extends StatelessWidget {
  Scanner({super.key});

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;

  _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      print(scanData.code);
      final uri = Uri.parse(scanData.code as String);
      AlertDialog(
          title: Text('Redirect To The Url'),
          content: SingleChildScrollView(
            child: ListView(),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {},
              child: Text('No'),
            ),
            ElevatedButton(
              child: const Text("Confirm"),
              onPressed: () async {
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                  controller.resumeCamera();
                }
              },
            ),
          ]);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => Dashboard()));
                  },
                  child: Center(
                    child: Text(
                      ' Press Here To Go DashBoard',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              // Expanded(
              //   flex: 1,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       // showDialog(
              //       //   context: context,
              //       //   builder: (BuildContext context) {
              //       //     return AlertDialog(
              //       //       title: Text('Alert'),
              //       //       content: SingleChildScrollView(
              //       //         child: ListBody(),
              //       //       ),
              //       //       actions: <Widget>[
              //       //         ElevatedButton(
              //       //           child: const Text("Confirm"),
              //       //           onPressed: () {
              //       //             Navigator.of(context).pop();
              //       //           },
              //       //         ),
              //       //         ElevatedButton(
              //       //           child: const Text("NO"),
              //       //           onPressed: () {
              //       //             Navigator.of(context).pushReplacement(
              //       //                 MaterialPageRoute(
              //       //                     builder: (BuildContext context) =>
              //       //                         Dashboard()));
              //       //             Navigator.of(context).pop();
              //       //           },
              //       //         ),
              //       //       ],
              //       //     );
              //       // },
              //       // ).then((value) => controller.resumeCamera());
              //     },
              //     child: Center(
              //       child: Text(
              //         ' Go to Url',
              //         style:
              //             TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
