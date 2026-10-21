import 'package:flutter/material.dart';

void main() {
  runApp(HafalatiApp());
}

class HafalatiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HAFALATI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HAFALATI - حافلاتي', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_bus, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text('مرحبا بكم في HAFALATI', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('تطبيق حافلات بني ملال', style: TextStyle(fontSize: 18, color: Colors.grey)),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.search),
              label: Text('البحث عن الحافلات'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
