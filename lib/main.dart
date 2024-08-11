import 'package:chature_1/flashscreen.dart';
import 'package:chature_1/login.dart';
import 'package:chature_1/testing.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:chature_1/homepage.dart';
import 'package:chature_1/search.dart';
import 'package:flutter/material.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized(); // Ensure that Flutter bindings are initialized
  await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform
  );

  runApp( const MaterialApp(
         debugShowCheckedModeBanner: false,
         home: flashscreen(),
  ));
}



