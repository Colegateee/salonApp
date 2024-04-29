import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'adminMainPage.dart';
import 'main.dart';
import 'User.dart';

class RegisterUserPage extends StatelessWidget {
  RegisterUserPage({Key? key}) : super(key: key);

  static bool _initialized = false;

  Future<void> initializeFirebase() async {
    if (!_initialized) {
      await Firebase.initializeApp();
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    TextEditingController _usernameController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    final _cloudFireStore = FirebaseFirestore.instance;

    DocumentReference clients =
        FirebaseFirestore.instance.collection('Users').doc('Clients');

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(30, screenWidth * 0.1, 30, 1),
                child: Text(
                  "CITY SALONS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.12,
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30, 0.2, 30, 1),
                child: Divider(
                  color: Colors.white,
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(30, 1, 30, 1),
                  child: Text(
                    "CITY OF BRISTOL COLLEGE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.060,
                      fontFamily: "Montserrat",
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30, screenHeight * 0.08, 30, 10),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    hintText: "Username",
                    fillColor: Colors.white,
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30, screenHeight * 0.01, 30, 10),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    hintText: "Password",
                    fillColor: Colors.white,
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30, screenHeight * 0.01, 30, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Text(
                      "Already Have an account?",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.brown,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(60, screenHeight * 0.02, 60, 10),
                child: ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: _usernameController.text.trim(),
                      password: _passwordController.text.trim(),
                    )
                        .then((userCredential) {
                      // If user creation successful, create user document in Firestore
                      FirebaseFirestore.instance
                          .collection('Users')
                          .doc(userCredential
                              .user!.uid) // Use UID as document ID
                          .set({
                        'email': _usernameController.text.trim(),
                        'accountType': 'client', // Set default account type
                        'password': _passwordController.text.trim(),
                        // Add other user details here if needed
                      }).then((_) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: Container(
                                color: Colors.black54.withOpacity(0.7),
                                child: AlertDialog(
                                  backgroundColor: Colors.black,
                                  title: Text(
                                    "Registration Success -- Please Login",
                                    style: TextStyle(
                                      color: Colors.brown,
                                      fontFamily: "Montserrat",
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ActualApp(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Close',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                        // Navigate to desired page after user creation
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ActualApp(),
                        //   ),
                        // );
                      }).catchError((error) {
                        // Handle error while creating user document
                        print("Error creating user document: $error");
                      });
                    }).catchError((error) {
                      print('Error during registration: $error');
                      if (error.toString() ==
                          "[firebase_auth/weak-password] Password should be at least 6 characters") {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: Container(
                                color: Colors.black54.withOpacity(0.7),
                                child: AlertDialog(
                                  backgroundColor: Colors.black,
                                  title: Text(
                                    "Password must be at least 6 characters",
                                    style: TextStyle(
                                      color: Colors.brown,
                                      fontFamily: "Montserrat",
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Close',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: Container(
                                color: Colors.black54.withOpacity(0.7),
                                child: AlertDialog(
                                  backgroundColor: Colors.black,
                                  title: Text(
                                    "Invalid Email",
                                    style: TextStyle(
                                      color: Colors.brown,
                                      fontFamily: "Montserrat",
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Close',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    });
                  },
                  child: Text("Register"),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.brown),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      TextStyle(fontSize: 12, fontFamily: 'Montserrat'),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.all(20)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
