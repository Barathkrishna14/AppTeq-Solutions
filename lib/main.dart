import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:appteq_solutions/dashboard.dart';
import 'package:appteq_solutions/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/quickalert.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appteq Solutions',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(children: [
        Image.asset('assets/playstore.png'),
        const Text(
          ' ',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        )
      ]),
      backgroundColor: Colors.white,
      nextScreen: MyHomePage(
        title: 'Welcome',
        email: 'email',
      ),
      splashIconSize: 227,
      duration: 1000,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required String title, required this.email});

  String email;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void showSucessAlert() {
    QuickAlert.show(
        context: context,
        text: "Login Sucessfull",
        type: QuickAlertType.success);
  }

  void showFaildAlert() {
    QuickAlert.show(
        context: context,
        text: "Check  Email And Password",
        type: QuickAlertType.error);
  }

  late Permission permission;
  PermissionStatus permissionStatusStorage = PermissionStatus.denied;
  PermissionStatus permissionStatusMicrophone = PermissionStatus.denied;
  PermissionStatus permissionStatusCamera = PermissionStatus.denied;
  PermissionStatus permissionStatusLocation = PermissionStatus.denied;

  void _listenForPermission() async {
    final statusStorage = await Permission.storage.status;
    final statusMicrophone = await Permission.microphone.status;
    final statusCamera = await Permission.camera.status;
    final statusLocation = await Permission.location.status;
    setState(() {
      permissionStatusStorage = statusStorage;
      permissionStatusMicrophone = statusMicrophone;
      permissionStatusCamera = statusCamera;
      permissionStatusLocation = statusLocation;
    });
    switch (statusStorage) {
      case PermissionStatus.denied:
        requestForPermission();
        break;
      case PermissionStatus.granted:
        // nothing
        break;
      case PermissionStatus.limited:
        Navigator.pop(context);
        break;
      case PermissionStatus.restricted:
        Navigator.pop(context);
        break;
      case PermissionStatus.permanentlyDenied:
        Navigator.pop(context);
        break;
    }
    switch (statusMicrophone) {
      case PermissionStatus.denied:
        requestForPermission();
        break;
      case PermissionStatus.granted:
        // nothing
        break;
      case PermissionStatus.limited:
        Navigator.pop(context);
        break;
      case PermissionStatus.restricted:
        Navigator.pop(context);
        break;
      case PermissionStatus.permanentlyDenied:
        Navigator.pop(context);
        break;
    }
    switch (statusCamera) {
      case PermissionStatus.denied:
        requestForPermission();
        break;
      case PermissionStatus.granted:
        // nothing
        break;
      case PermissionStatus.limited:
        Navigator.pop(context);
        break;
      case PermissionStatus.restricted:
        Navigator.pop(context);
        break;
      case PermissionStatus.permanentlyDenied:
        Navigator.pop(context);
        break;
    }
    switch (statusLocation) {
      case PermissionStatus.denied:
        requestForPermission();
        break;
      case PermissionStatus.granted:
        // nothing
        break;
      case PermissionStatus.limited:
        Navigator.pop(context);
        break;
      case PermissionStatus.restricted:
        Navigator.pop(context);
        break;
      case PermissionStatus.permanentlyDenied:
        Navigator.pop(context);
        break;
    }
  }

  Future<void> requestForPermission() async {
    final statusStorage = await Permission.storage.request();
    final statusMicrophone = await Permission.microphone.request();
    final statusCamera = await Permission.camera.request();
    final statusLocation = await Permission.location.request();
    setState(() {
      permissionStatusStorage = statusStorage;
      permissionStatusMicrophone = statusMicrophone;
      permissionStatusCamera = statusCamera;
      permissionStatusLocation = statusLocation;
    });
  }

  @override
  void initState() {
    _listenForPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.phone_android,
                    size: 100,
                  ),
                  SizedBox(height: 50),
                  Text('Hello Again!',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 52,
                      )),
                  SizedBox(height: 10),
                  Text("Welcome Back! You've Been Missed",
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 50),
                  //Email Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Email',
                          ),
                          controller: _emailController,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Please Enter Your Email";
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return "Please Enter Your Correct Email";
                            }
                            onSaved:
                            (String email) {
                              email = email;
                            };
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  //Password Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password',
                            ),
                            controller: _passwordController,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "Please Enter Your Email";
                              }
                              if (!RegExp("[0-9a-zA-Z]{6,}").hasMatch(value)) {
                                return "Enter More Than 8 Characters And At Least One letter and Number";
                              }
                              onSaved:
                              (String password) {
                                password = password;
                              };
                            }),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  //sign in Button

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: () {
                        if (!formkey.currentState!.validate()) {
                          return showFaildAlert();
                        } else {
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text)
                              .then((value) {
                            print(value);
                            var login = true;
                            print('Logged In Successfully');
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        Dashboard()));
                            if (login = true) {
                              showSucessAlert();
                            } else {
                              showFaildAlert();
                            }
                          }).catchError((e) {
                            print(e);
                            showFaildAlert();
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                            child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        )),
                      ),
                    ),
                  ),

                  SizedBox(height: 25),

                  // not a member

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Not a Member? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      RegisterPage()));
                        },
                        child: Text(
                          'Register Now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        )));
  }
}
