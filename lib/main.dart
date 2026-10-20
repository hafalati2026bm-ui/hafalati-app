import 'package:flutter/material.dart';

void main() {
  runApp(const HafalatiApp());
}

class HafalatiApp extends StatelessWidget {
  const HafalatiApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HAFALATI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF8B4513),
        scaffoldBackgroundColor: const Color(0xFFFFF8F0),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'نگافات', 'icon': '👰', 'color': Color(0xFFFF6B9D)},
      {'name': 'فرق موسيقية', 'icon': '🎵', 'color': Color(0xFF4ECDC4)},
      {'name': 'قاعات', 'icon': '🏛️', 'color': Color(0xFFFFE66D)},
      {'name': 'مصورين', 'icon': '📸', 'color': Color(0xFF6C5CE7)},
      {'name': 'حلويات', 'icon': '🎂', 'color': Color(0xFFA29BFE)},
      {'name': 'ديكور', 'icon': '💐', 'color': Color(0xFFFF7675)},
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('HAFALATI - حفلاتي', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Color(0xFF8B4513),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(color: Color(0xFF8B4513), borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  Text('مرحبا بيك فـ حفلاتي', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('سوق الاعراس - كلشي ديال العرس فبلاصة وحدة', style: TextStyle(color: Colors.white70, fontSize: 14), textAlign: TextAlign.center),
                ],
              ),
            ),
            SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.2),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(color: categories[index]['color'] as Color, borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(categories[index]['icon'] as String, style: TextStyle(fontSize: 40)),
                      SizedBox(height: 8),
                      Text(categories[index]['name'] as String, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
