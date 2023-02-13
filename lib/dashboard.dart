import 'package:appteq_solutions/main.dart';
import 'package:appteq_solutions/scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  @override
  // State<Dashboard> createState() => _DashboardState();
// class _DashboardState extends State<Dashboard> {

  String locationMessage = 'Current Location ';

  // late var lat = TextEditingController();
  late String lat;
  late String long;
  // late var long = TextEditingController();

  // void navigateNextPage(BuildContext ctx) {
  //   Navigator.of(ctx).pushNamed('/display_pg', arguments: {
  //     'lat': lat,
  //     'long': long,
  //   });
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

  final GlobalKey _globalKey = GlobalKey();
  QRViewController? controller;
  Barcode? result;

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   routes: {
    //     '/display_pg': (ctx) => Scanner(),
    //   },
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  '         Welcome Home! \n    Glad To See You Again',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      decorationThickness: 40),
                ),
                SizedBox(height: 280),
                Container(
                  child: ElevatedButton(
                    child: Text('Scan'),
                    onPressed: () {
                      // navigateNextPage(context);
                      _getCurrentLocation().then((value) {
                        lat = '${value.latitude}';
                        long = '${value.longitude}';
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
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => Scanner()));
                    },
                  ),
                ),
                SizedBox(height: 280),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 70.0),
                    child: GestureDetector(
                      onTap: () {
                        FirebaseAuth.instance.signOut().then((value) {
                          print('SignedOut');
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (BuildContext context) => MyHomePage(
                                        email: '',
                                        title: '',
                                      )));
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(13),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                            child: Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
