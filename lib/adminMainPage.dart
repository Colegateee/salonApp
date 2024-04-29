import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'dart:convert';
import 'login.dart';
import 'registerUserToFirebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminMainPage extends StatelessWidget {
    const AdminMainPage({Key? key}) : super(key: key);

      Widget build(BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;
        return Scaffold(
          body: Center(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: FlutterLogo(size: 100,), margin: EdgeInsets.symmetric(vertical: 0.2 * screenHeight),
                  ),
                  Container(
                    child: Text("You are admin")
                  )
                  
                ],
              ),
            ),
          ),
        );
      }

}