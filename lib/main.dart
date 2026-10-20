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
      {'name': 'نگافات', 'icon': '👰', 'color': const Color(0xFFFF6B9D)},
      {'name': 'فرق موسيقية', 'icon': '🎵', 'color': const Color(0xFF4ECDC4)},
      {'name': 'قاعات', 'icon': '🏛️', 'color': const Color(0xFFFFE66D)},
      {'name': 'مصورين', 'icon': '📸', 'color': const Color(0xFF6C5CE7)},
      {'name': 'حلويات', 'icon': '🎂', 'color': const Color(0xFFA29BFE)},
      {'name': 'ديكور', 'icon': '💐', 'color': const Color(0xFFFF7675)},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('HAFALATI - حفلاتي', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF8B4513),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF8B4513), borderRadius: BorderRadius.circular(15)),
              child: const Column(
                children: [
                  Text('مرحبا بيك فـ حفلاتي', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('سوق الاعراس - كلشي ديال العرس فبلاصة وحدة', style: TextStyle(color: Colors.white70, fontSize: 14), textAlign: TextAlign.center),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.2),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: categories[index]['color'] as Color,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(categories[index]['icon'] as String, style: const TextStyle(fontSize: 40)),
                      const SizedBox(height: 8),
                      Text(categories[index]['name'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
