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
                  loginUsers
                      .loginUserSystem(
                          _usernameController.text, _passwordController.text)
                      .then((isLoggedIn) {
                    if (isLoggedIn) {
                      print("logged in");
                      CollectionReference adminsRef =
                          FirebaseFirestore.instance.collection('Admins');

                      DocumentReference adminList = adminsRef.doc('adminList');
                      adminList.get().then((adminSnapshot) {
                        Map<String, dynamic>? data =
                            adminSnapshot.data() as Map<String, dynamic>?;
                        List<dynamic>? adminListOfEmails = data?['adminList'];
                        if (adminListOfEmails != null) {
                          print("accessed list");
                          if (adminListOfEmails.contains(_passwordController)) {
                            print('checked list and it contains');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminMainPage()),
                            );
                          }
                        }
                      });

                      //     adminsRef
                      //         .doc(_usernameController.text)
                      //         .get()
                      //         .then((adminSnapshot) {
                      //       if (adminSnapshot.exists) {
                      //         Map<String, dynamic>? data =
                      //             adminSnapshot.data() as Map<String, dynamic>?;
                      //         print("Logged-in user email: $loggedInUserEmail");
                      //         if (data != null && data.containsKey('adminList')) {
                      //           List<dynamic> adminEmails = data['adminList'];
                      //           print("Admin emails: $adminEmails");
                      //           print("Logged-in user email: $loggedInUserEmail");
                      //           if (adminEmails.contains(loggedInUserEmail)) {
                      //             Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) => AdminMainPage()),
                      //             );
                      //             return; // Exit the method after navigation
                      //           }
                      //         }
                      //       } else {
                      //         // Check if the user is a client
                      //         clientsRef
                      //             .doc(loggedInUserEmail)
                      //             .get()
                      //             .then((clientSnapshot) {
                      //           if (clientSnapshot.exists) {
                      //             // User is a client, navigate to client page
                      //             Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) => ClientMainPage()),
                      //             );
                      //           } else {
                      //             // Check if the user is a hairdresser
                      //             hairdressersRef
                      //                 .doc(loggedInUserEmail)
                      //                 .get()
                      //                 .then((hairdresserSnapshot) {
                      //               if (hairdresserSnapshot.exists) {
                      //                 // User is a hairdresser, navigate to hairdresser page
                      //                 Navigator.push(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                       builder: (context) => HDMainPage()),
                      //                 );
                      //               } else {
                      //                 print("Not an admin or idk");
                      //               }
                      //             }).catchError((error) {
                      //               // Handle error while fetching hairdresser data
                      //               print(
                      //                   "Error fetching hairdresser data: $error");
                      //               // Optionally, navigate to a default page or show an error message
                      //             });
                      //           }
                      //         }).catchError((error) {
                      //           // Handle error while fetching client data
                      //           print("Error fetching client data: $error");
                      //           // Optionally, navigate to a default page or show an error message
                      //         });
                      //       }
                      //     }).catchError((error) {
                      //       // Handle error while fetching admin data
                      //       print("Error fetching admin data: $error");
                      //       // Optionally, navigate to a default page or show an error message
                      //     });
                      //   } else {
                      //     Navigator.pop(context);
                      //     showDialog(
                      //         context: context,
                      //         builder: (BuildContext context) {
                      //           return Center(
                      //               child: Container(
                      //             color: Colors.black54.withOpacity(0.7),
                      //             child: AlertDialog(
                      //               backgroundColor: Colors.black,
                      //               title: Text(
                      //                 "Incorrect Format/Password",
                      //                 style: TextStyle(
                      //                     color: Colors.brown,
                      //                     fontFamily: "Montserrat"),
                      //               ),
                      //               actions: <Widget>[
                      //                 TextButton(
                      //                   onPressed: () {
                      //                     Navigator.of(context).pop();
                      //                   },
                      //                   child: Text(
                      //                     'Close',
                      //                     style: TextStyle(
                      //                         color: Colors.white,
                      //                         fontFamily: "Montserrat"),
                      //                   ),
                      //                 )
                      //               ],
                      //             ),
                      //           ));
                      //         });
                    }
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
