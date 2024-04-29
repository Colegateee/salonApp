import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'dart:convert';

final _myFirebase = FirebaseFirestore.instance;

bool errorLoggingIn = false;

class loginUsers{
  static Future<bool> loginUserSystem(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      print('Logged in');
      return true; 
    } 
    catch (error) {
      print('Error: $error');
      return false; 
    }
}
}

