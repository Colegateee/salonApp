import 'package:flutter/material.dart';
import 'package:salonapp_1/clientMainPage.dart';
import 'firebase_options.dart';
import 'dart:convert';
import 'login.dart';
import 'registerUserToFirebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'adminMainPage.dart';
import 'clientMainPage.dart';
import 'hairdresserMainPage.dart';
import 'User.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(MaterialApp(home: ActualApp()));
  } catch (e) {
    print("Firebase initialization failed: $e");
  }
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
}

class ActualApp extends StatelessWidget {
  const ActualApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    TextEditingController _usernameController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    String hintTextChangerEmail = "Email";
    String hintTextChangerPassword = "Password";

    return Scaffold(
        body: Center(
      child: Container(
        constraints: BoxConstraints.expand(),
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
                )),
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
            )),
            Container(
              margin: EdgeInsets.fromLTRB(30, screenHeight * 0.08, 30, 10),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.white,
                  )),
                  hintText: hintTextChangerEmail,
                  fillColor: Colors.white,
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
                style: TextStyle(color: Colors.black, fontFamily: "Montserrat"),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, screenHeight * 0.01, 30, 10),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.white,
                  )),
                  hintText: hintTextChangerPassword,
                  fillColor: Colors.white,
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
                style: TextStyle(color: Colors.black, fontFamily: "Montserrat"),
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
                      "Not Registered?",
                      style: TextStyle(
                          color: Colors.white, fontFamily: "Montserrat"),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterUserPage()));
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.brown,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    )
                  ]),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(60, screenHeight * 0.02, 60, 10),
              child: ElevatedButton(
                onPressed: () {
                  _handleLogin(context);
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                    email: _usernameController.text,
                    password: _passwordController.text,
                  )
                      .then((userCredential) {
                    User? user = userCredential.user;
                    if (user != null) {
                      String userId =
                          user.uid; // Get the Firebase user ID (UID)
                      print(userId);
                      CollectionReference usersRef =
                          FirebaseFirestore.instance.collection('Users');
                      usersRef.doc(userId).get().then((userDoc) {
                        if (userDoc.exists) {
                          // User document found, handle accordingly
                          print('User document found: ${userDoc.data()}');
                          // UserProfile currentUser = UserProfile.fromMap(
                          //     userDoc.data() as Map<String, dynamic>);
                          // print(currentUser.accountType);
                          Map<String, dynamic> user =
                              userDoc.data() as Map<String, dynamic>;
                          String accType = user['accountType'];
                          if (accType == 'admin') {
                            print('User is admin');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminMainPage(),
                              ),
                            );
                          } else if (accType == 'client') {
                            print('User is client');
                            // Navigate to client page or handle accordingly
                          } else if (accType == 'hairdresser') {
                            print('User is hairdresser');
                            // Navigate to hairdresser page or handle accordingly
                          } else {
                            print('Unknown account type');
                            // Handle case where account type is unknown
                          }
                        } else {
                          // User document not found
                          print('User document not found');
                        }
                      }).catchError((error) {
                        // Handle error while retrieving user document
                        print("Error retrieving user document: $error");
                      });
                    } else {
                      // User is null
                      print('User is null');
                    }
                  }).catchError((error) {
                    // Handle sign-in error
                    print("Error signing in: $error");
                  });
                }, //ONPRESSED-----------------------------------------------------------LOGIN
                child: Text("Login"),
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
    ));
  }

  void _handleLogin(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
            color: Colors.black.withOpacity(0.9),
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.brown,
              ),
            ));
      },
    );
  }
}
