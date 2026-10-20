import 'package:flutter/material.dart';

void main() {
  runApp(const HafalatiApp());
}

class HafalatiApp extends StatelessWidget {
  const HafalatiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HAFALATI',
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      home: const GoldHome(),
    );
  }
}

class GoldHome extends StatelessWidget {
  const GoldHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('HAFALATI', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings, color: Color(0xFFD4AF37)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminPage()));
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF121212),
              border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('مرحبا، فاطمة', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 22, fontWeight: FontWeight.bold)),
                Text('جاهزة ليومك المميز؟', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('الأوركسترات - اضغطي للدخول', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          orchestraCard(context, 'أوركسترا سفيان', 'بني ملال', '10,000'),
          orchestraCard(context, 'أوركسترا نجوم الأطلس', 'خريبكة', '12,000'),
          orchestraCard(context, 'أوركسترا مراكش', 'مراكش', '15,000'),
        ],
      ),
    );
  }

  Widget orchestraCard(BuildContext context, String name, String city, String price) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(name: name, price: price)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          border: Border.all(color: const Color(0xFFD4AF37)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.music_note, color: Color(0xFFD4AF37)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text('$city • $price DH', style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Color(0xFFD4AF37), size: 14),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String name;
  final String price;
  const DetailPage({super.key, required this.name, required this.price});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, title: Text(name, style: const TextStyle(color: Color(0xFFD4AF37)))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                border: Border.all(color: const Color(0xFFD4AF37)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Icon(Icons.play_circle_fill, size: 70, color: Color(0xFFD4AF37))),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                border: Border.all(color: const Color(0xFFD4AF37)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('الباقة الذهبية', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
                  Text('$price درهم', style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37), padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage(price: price)));
                },
                child: const Text('احجزي - Pay with Coins', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final String price;
  const CartPage({super.key, required this.price});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, title: const Text('سلة التسوق', style: TextStyle(color: Color(0xFFD4AF37)))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('المجموع: $price DH', style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 24)),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37), minimumSize: const Size(double.infinity, 50)),
              onPressed: () {},
              child: const Text('إتمام الحجز', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, title: const Text('لوحة تحكم الأدمن', style: TextStyle(color: Color(0xFFD4AF37)))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFB8960C)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Admin: hafalati2026.bm@gmail.com', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                Text('رصيد الضمان: 125,420 DH', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
