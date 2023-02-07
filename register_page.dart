import 'package:appteq_solutions/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  //text Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void showFaildAlert() {
    QuickAlert.show(
        context: context, text: "Sign Up Failed", type: QuickAlertType.error);
  }

  void showSucessAlert() {
    QuickAlert.show(
        context: context,
        text: "Sign Up Success",
        type: QuickAlertType.success);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
  }

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
                  Text('Hello There!',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 52,
                      )),
                  SizedBox(height: 10),
                  Text("Register Below With Your Details",
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
                            }),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  //New Password Field
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
                              hintText: 'New Password',
                            ),
                            controller: password,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "Please Enter Your New Password";
                              }
                              if (!RegExp("[0-9a-zA-Z]{6,}").hasMatch(value)) {
                                return "MoreThan 6 Characters";
                              }
                            }),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  //Confirm Password Field

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
                              hintText: 'Confirm Password',
                            ),
                            controller: _passwordController,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "Please Enter Your Confirm Password";
                              }
                              if (!RegExp("[0-9a-zA-Z]{6,}").hasMatch(value)) {
                                return "MoreThan 6 Characters";
                              }
                              if (value != password.text) {
                                return "Password Doesn't Match";
                              }
                            }),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  //Mobile Number
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
                              hintText: 'Mobile Number',
                            ),
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "Please Enter Your Mobile Number";
                              }
                              if (!RegExp("^[0-9]{10}").hasMatch(value)) {
                                return "Enter 10 Digit Number";
                              }
                            }),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  //sign up Button

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: () {
                        if (!formkey.currentState!.validate()) {
                          return showFaildAlert();
                        } else {
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text)
                              .then((value) => {
                                    print('Created New Acoount'),
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                MyHomePage(
                                                  title: 'Welcome',
                                                  email: 'email',
                                                )))
                                  })
                              .onError((error, stackTrace) {
                            throw ("Error ${error.toString()}");
                          });
                          showSucessAlert();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                            child: Text(
                          'Sign Up',
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
                      Text("I'm a Member! "),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (BuildContext context) => MyHomePage(
                                        title: 'Welcome',
                                        email: 'email',
                                      )));
                        },
                        child: Text(
                          'Login Now',
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
