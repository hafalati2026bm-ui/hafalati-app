import 'package:flutter/material.dart';
class ClientApp extends StatelessWidget {
  final gold = Color(0xFFD4AF37);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F0F),
      appBar: AppBar(backgroundColor: Color(0xFF0F0F0F), title: Text('HAFALATI - زبون', style: TextStyle(color: gold))),
      body: ListView(padding: EdgeInsets.all(16), children: [
        Text('اختر فرقتك', style: TextStyle(color: Colors.white, fontSize: 18)),
        SizedBox(height: 10),
        _card('أوركسترا سفيان اوفقير', 'بني ملال', '10,000 MAD Solo - 20,000 Chikhat', gold),
        _card('أوركسترا الأندلس', 'مراكش', '5,000 MAD / حفلة', gold),
        _card('قاعة الرياض', 'الرباط', '8,000 MAD', gold),
      ]),
    );
  }
  Widget _card(String n, String c, String p, Color g) => Container(margin: EdgeInsets.only(bottom:10), padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(10), border: Border.all(color: g)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(n, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text(c, style: TextStyle(color: Colors.white54)), Text(p, style: TextStyle(color: g, fontWeight: FontWeight.bold))]));
}
