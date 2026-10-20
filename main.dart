import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(HafalatiApp());
}

class HafalatiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF121212),
        primaryColor: Color(0xFFFFD700),
      ),
      home: Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.celebration, size: 80, color: Color(0xFFFFD700)),
              SizedBox(height: 20),
              Text('حفلاتي - HAFALATI', style: TextStyle(color: Color(0xFFFFD700), fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Wifi حقيقي - Firebase - يعمل!', style: TextStyle(color: Colors.white)),
              SizedBox(height: 20),
              CircularProgressIndicator(color: Color(0xFFFFD700)),
            ],
          ),
        ),
      ),
    );
  }
}
