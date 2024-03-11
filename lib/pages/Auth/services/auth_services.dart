// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_management/Model/user_model.dart';

class UserAuth {
  String? _uid;
  String get uid => _uid!;
  UserModel? _userModel;
  UserModel get userModel => _userModel!;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebasefirestore = FirebaseFirestore.instance;
  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        const SnackBar(content: Text('The email address is already in use.'));
      } else {
        SnackBar(content: Text('An error occurred: ${e.code}'));
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        const SnackBar(content: Text('Invalid email or password.'));
      } else {
        SnackBar(content: Text('An error occurred: ${e.code}'));
      }
    }
    return null;
  }

  void SaveUserDataToFireStore({
    required String email,
    required String password,
    required String name,
    required String createdAt,
    required String uid,
    required String profilepic,
    required double totalincome,
    required double totalexpense,
    required double totaleamount,
  }) async {
    try {
      await _firebasefirestore.collection("users").doc(uid).set({
        'name': name,
        'email': email,
        'password': password,
        'createdAt': createdAt,
        'uid': uid,
        'profilepic': profilepic,
        'totaleamount': totaleamount,
        'totalincome': totalincome,
        'totalexpense': totalexpense,
      });
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      SnackBar(content: Text(e.message.toString()));
    }
  }

  Future<UserModel?> getDataFromFirestore() async {
    await _firebasefirestore.collection("users").doc(_firebaseAuth.currentUser!.uid).get().then((DocumentSnapshot snapshot) {
      _userModel = UserModel(
        name: snapshot['name'],
        email: snapshot['email'],
        password: snapshot['password'],
        uid: snapshot['uid'],
        totaleamount: snapshot['totaleamount'],
        createdAt: snapshot['createdAt'],
        totalincome: snapshot['totalincome'],
        totalexpense: snapshot['totalexpense'],
        profilepic: snapshot['profilepic'],
      );
      _uid = userModel.uid;
    });
    return _userModel;
  }

  Logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
