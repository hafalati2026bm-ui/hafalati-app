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
      title: 'HAFALATI',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF121212),
        primaryColor: Color(0xFFFFD700),
      ),
      home: AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (c, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFFFFD700))));
        }
        if (snap.hasData) return HomePage();
        return LoginPage();
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final pass = TextEditingController();
  bool loading = false;

  void login() async {
    setState(() => loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text.trim(), password: pass.text.trim());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.celebration, size: 80, color: Color(0xFFFFD700)),
          Text('حفلاتي - HAFALATI', style: TextStyle(color: Color(0xFFFFD700), fontSize: 28, fontWeight: FontWeight.bold)),
          SizedBox(height: 30),
          TextField(controller: email, style: TextStyle(color: Colors.white), decoration: InputDecoration(labelText: 'Email', labelStyle: TextStyle(color: Color(0xFFFFD700)), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFFFD700))))),
          SizedBox(height: 12),
          TextField(controller: pass, obscure
