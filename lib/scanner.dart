import 'dart:ffi';

import 'package:appteq_solutions/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'dart:math' show cos, sqrt, asin;

class Scanner extends StatelessWidget {
  Scanner({super.key, uri});
  var lat;
  var long;
  var kctlat = 11.0810367;
  var kctlong = 76.9891331;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  var uri;
  var total;

  locationAccuracy() {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((kctlat - lat) * p) / 2 +
        c(lat * p) * c(kctlat * p) * (1 - c((kctlong - long) * p)) / 2;
    total = 12742 * asin(sqrt(a));
    total = (total * 1000);
    print(total);
    locationAccuracy(Double total) {
      this.total = total;
    }
  }

  void showSucessAlert(BuildContext context) {
    QuickAlert.show(
        context: context,
        text: "You Are In KCT Tech Park",
        type: QuickAlertType.success);
  }

  void showFaildAlert(BuildContext context) {
    QuickAlert.show(
        context: context,
        text: "You Are Not In KCT",
        type: QuickAlertType.error);
  }

  // double _countDistance(double userLatitude, double userLongitude) {
  //   return Distance().as(
  //     LengthUnit.Kilometer,
  //     LatLng(declaredLocation.latitude, declaredLocation.longitude),
  //     LatLng(userLatitude, userLongitude),
  //   );
  // }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location Service Disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permission Denied');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      print("Debug");
      print(scanData.code);
      uri = Uri.parse(scanData.code as String);
      controller.stopCamera();

      _onQRViewCreated(String uri) {
        this.uri = uri;
      }

      //  Navigator.of(context).pushReplacement(MaterialPageRoute(
      //                   builder: (BuildContext context) => AlertWithButtons(uri: uri,)));
      // AlertDialog(
      //     title: Text('Redirect To The Url'),
      //     content: SingleChildScrollView(
      //       child: ListView(),
      //     ),
      //     actions: <Widget>[
      //       ElevatedButton(
      //         onPressed: () {},
      //         child: Text('No'),
      //       ),
      //       ElevatedButton(
      //         child: const Text("Confirm"),
      //         onPressed: () async {
      //           if (await canLaunchUrl(uri)) {
      //             await launchUrl(uri);
      //             controller.resumeCamera();
      //           }
      //         },
      //       ),
      //     ]);
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
                    controller.stopCamera();
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
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Alert'),
                          content: SingleChildScrollView(
                            child: Text("Are You Sure To put Attendance?"),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text("No"),
                              onPressed: () {
                                controller.stopCamera();
                                Navigator.pop(context);
                                controller.pauseCamera();
                              },
                            ),
                            ElevatedButton(
                              child: const Text("Confirm"),
                              onPressed: () async {
                                _getCurrentLocation().then((value) {
                                  lat = double.parse('${value.latitude}');
                                  long = double.parse('${value.longitude}');
                                  var time = DateTime.now().toString();
                                  var dateparse = DateTime.parse(time);
                                  var formattedDate =
                                      "${dateparse.day}-${dateparse.month}-${dateparse.year}-${dateparse.hour}:${dateparse.minute}:${dateparse.second}";
                                  String uid = 'firstOne';
                                  FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc(uid)
                                      .set({
                                    'id': uid,
                                    'location': '$lat and $long',
                                    'Time': formattedDate,
                                  });
                                });
                                locationAccuracy();
                                Position location =
                                    await Geolocator.getCurrentPosition(
                                            forceAndroidLocationManager: true,
                                            desiredAccuracy:
                                                LocationAccuracy.best)
                                        .timeout(Duration(seconds: 20));
                                if (total <= 10) {
                                  print(lat);
                                  showSucessAlert(context);
                                } else {
                                  showFaildAlert(context);
                                  print(total);
                                  print(lat);
                                }
                              },
                            ),
                          ],
                        );
                      },
                    ).then((value) => controller.resumeCamera());
                  },
                  child: Center(
                    child: Text(
                      ' Confirm',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
