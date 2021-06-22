import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ete_quiz_app/views/Home.dart';
import 'package:ete_quiz_app/views/Login.dart';

void main(){
  runApp(MaterialApp(
    home: Login(),
    theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.blue
    ),
    debugShowCheckedModeBanner: false,
  ));

}
