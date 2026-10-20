import 'package:flutter/material.dart';
void main() => runApp(MaterialApp(debugShowCheckedModeBanner:false, home: Home()));

class Home extends StatefulWidget { @override _HomeState createState() => _HomeState(); }
class _HomeState extends State<Home> {
  int i=2; final gold=Color(0xFFD4AF37);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F0F),
      body: i==0 ? ClientFile() : i==1 ? BandFile() : AdminFile(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF0F0F0F), selectedItemColor: gold, unselectedItemColor: Colors.white38, currentIndex: i,
        onTap: (v)=> setState(()=> i=v),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ملف زبون'),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'ملف فرقة'),
          BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'ملفي أنا'),
        ],
      ),
    );
  }
}

// ================= ملف 1: زبون كيفاش كيطلع ليه التطبيق من الداخل =================
class ClientFile extends StatelessWidget {
  final gold=Color(0xFFD4AF37);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F0F),
      appBar: AppBar(backgroundColor: Color(0xFF0F0F0F), title: Text('HAFALATI - الزبون', style: TextStyle(color: gold, fontWeight: FontWeight.bold))),
      body: ListView(padding: EdgeInsets.all(16), children: [
        SizedBox(height:20), Text('مرحبا بك - اختر فرقتك للعرس', style: TextStyle(color: Colors.white, fontSize:18)),
        SizedBox(height:15),
        _card('أوركسترا سفيان اوفقير - أنا', 'بني ملال - شعبي', '10,000 MAD Solo | 20,000 MAD Chikhat', '4.8 ★ 127 مراجعة - فيديو: Chaabi Medley 2:34 ▶️', true),
        _card('أوركسترا الأندلس', 'مراكش - أندلسي', '5,000 MAD / حفلة', '4.9 ★ 89 مراجعة - فيديو: أندلسي', false),
        _card('قاعة الرياض + نجوم سوس', 'الرباط - قاعة', '8,000 MAD / ليلة', '5.0 ★ 45 مراجعة', false),
        SizedBox(height:20),
        Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(10)), child: Text('السلة: 0 - ملي كتحجز كتخلص والفلوس كتبقى Escrow حتى تكمل الحفلة', style: TextStyle(color: Colors.white70))),
      ]),
    );
  }
  Widget _card(String n, String c, String p, String r, bool me) => Container(margin: EdgeInsets.only(bottom:12), padding: EdgeInsets.all(14), decoration: BoxDecoration(color: Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12), border: Border.all(color: me? Color(0xFFD4AF37): Colors.white24, width: me?2:1)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Expanded(child: Text(n, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))), if(me) Container(padding: EdgeInsets.symmetric(horizontal:6, vertical:2), decoration: BoxDecoration(color: Color(0xFFD4AF37), borderRadius: BorderRadius.circular(4)), child: Text('أنا', style: TextStyle(color: Colors.black, fontSize:10)))]), Text(c, style: TextStyle(color: Colors.white54, fontSize:12)), SizedBox(height:4), Text(p, style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)), Text(r, style: TextStyle(color: Colors.white60, fontSize:11)), SizedBox(height:6), SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFD4AF37)), onPressed: (){}, child: Text('احجز الآن - BOOK', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))))]));
}

// ================= ملف 2: كل فرقة تعدل وتكتب أثمنة وتواريخ وتتحكم فصفحتها =================
class BandFile extends StatefulWidget { @override _BandFileState createState() => _BandFileState(); }
class _BandFileState extends State<BandFile> {
  final gold=Color(0xFFD4AF37); String price='5,000'; String solo='10,000'; String chikhat='20,000';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F0F),
      appBar: AppBar(backgroundColor: Color(0xFF0F0F0F), title: Text('ملف فرقتي - كنعدل صفحتي', style: TextStyle(color: gold))),
      body: ListView(padding: EdgeInsets.all(16), children: [
        SizedBox(height:20), Text('الأثمنة ديالي - أنا اللي كنحدد', style: TextStyle(color: gold, fontSize:18, fontWeight: FontWeight.bold)), SizedBox(height:10),
        _edit('ثمن الحفلة العادية', price, (v)=> setState(()=> price=v)), _edit('ثمن Solo', solo, (v)=> setState(()=> solo=v)), _edit('ثمن Chikhat Group', chikhat, (v)=> setState(()=> chikhat=v)),
        SizedBox(height:10), Container(padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFF3A2E0A), borderRadius: BorderRadius.circular(8)), child: Text('غادي يبان للزبون: $price MAD / حفلة | Solo $solo | Chikhat $chikhat - ولكن ما كيبانش حتى توافق انت كأدمن', style: TextStyle(color: gold, fontSize:12))),
        Divider(color: gold.withOpacity(0.3), height:30),
        Text('التواريخ ديالي - أنا كنحكم فالجدولة', style: TextStyle(color: gold, fontSize:18, fontWeight: FontWeight.bold)), SizedBox(height:10),
        _date('26 Oct 2024 - محجوز - قاعة الرياض - 18:00-23:00', true), _date('27 Oct 2024 - خاوي - متاح', false), _date('28 Oct 2024 - خاوي - متاح', false),
        ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: gold), icon: Icon(Icons.calendar_month, color: Colors.black), label: Text('زيد تاريخ جديد / بلوكي نهار', style: TextStyle(color: Colors.black)), onPressed: (){}),
        Divider(color: gold.withOpacity(0.3), height:30),
        Text('فيديوهاتي وصفحتي', style: TextStyle(color: gold, fontSize:18, fontWeight: FontWeight.bold)), SizedBox(height:10),
        _video('فيديو عرس بني ملال - 2:34 ▶️ - 1.2K مشاهدة'), _video('Chaabi Medley Sample - 3:10 ▶️ - 890 مشاهدة'),
        ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: gold), icon: Icon(Icons.video_call, color: Colors.black), label: Text('رفع فيديو جديد من التيليفون', style: TextStyle(color: Colors.black)), onPressed: (){}),
      ]),
    );
  }
  Widget _edit(String l, String v, Function(String) c) => Padding(padding: EdgeInsets.only(bottom:10), child: Row(children: [Expanded(child: Text(l, style: TextStyle(color: Colors.white70))), SizedBox(width:80, child: TextField(decoration: InputDecoration(hintText: v, hintStyle: TextStyle(color: gold), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: gold)), contentPadding: EdgeInsets.symmetric(horizontal:8)), style: TextStyle(color: Colors.white), onSubmitted: c)), SizedBox(width:5), Text('MAD', style: TextStyle(color: gold))]));
  Widget _date(String t, bool booked) => Container(margin: EdgeInsets.only(bottom:8), padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(8)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Text(t, style: TextStyle(color: booked? Colors.redAccent: Colors.white))), Icon(booked? Icons.block: Icons.check_circle, color: booked? Colors.red: Colors.green)]));
  Widget _video(String t) => Container(margin: EdgeInsets.only(bottom:8), padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(8)), child: Row(children: [Icon(Icons.play_circle_fill, color: gold, size:30), SizedBox(width:10), Expanded(child: Text(t, style: TextStyle(color: Colors.white))), Icon(Icons.delete, color: Colors.red)]));
}

// ================= ملف 3: ملفي أنا - كنشوف كلشي وكنربح وكنخرج وندخل لي بغيت =================
class AdminFile extends StatelessWidget {
  final gold=Color(0xFFD4AF37);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F0F),
      appBar: AppBar(backgroundColor: Colors.black, title: Text('ملفي أنا - المالك', style: TextStyle(color: gold, fontWeight: FontWeight.bold))),
      body: ListView(padding: EdgeInsets.all(16), children: [
        SizedBox(height:10),
        Container(padding: EdgeInsets.all(18), decoration: BoxDecoration(color: Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(15), border: Border(left: BorderSide(color: gold, width:5))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('أرباحي الإجمالية - Revenus totaux', style: TextStyle(color: Colors.white70)), Text('248,750 DH', style: TextStyle(color: Colors.white, fontSize:34, fontWeight: FontWeight.bold)), Text('Escrow: 125,420 DH | عمولتي 10%: 12,542 DH | صافي: 87,200 DH', style: TextStyle(color: gold, fontSize:12)), SizedBox(height:12), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: gold), onPressed: (){}, child: Text('سحب فلوسي الآن → Attijariwafa ****4521', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
        ])),
        SizedBox(height:20), Text('كنقبل المعلومات ولا ما نقبلش - Demandes', style: TextStyle(color: gold, fontSize:16, fontWeight: FontWeight.bold)), SizedBox(height:10),
        _demande('أوركسترا الأندلس', 'بغا يبدل الثمن من 5,000 إلى 6,000 MAD', 'فيديو جديد: عرس مراكش', gold), _demande('أوركسترا نجوم سوس', 'أكادير - 3,500 MAD', 'زاد تاريخ 30 Oct + 2 فيديو', gold),
        SizedBox(height:20), Text('كنشوف أرصدة الفرق كاملين', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        _solde('أوركسترا سفيان اوفقير (أنا)', '87,200 DH', true), _solde('Chaabi Rabat', '62,450 DH', false), _solde('Classique Fès', '54,100 DH', false),
        SizedBox(height:20), Text('الفرق باغين يسحبو - أنا كنوافق', style: TextStyle(color: gold, fontWeight: FontWeight.bold)), SizedBox(height:8),
        Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(10)), child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('سفيان يطلب سحب 6,000 DH', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text('Attijariwafa | GPS: وصل + خدمة مكتملة | فيديو الحفلة موجود', style: TextStyle(color: Colors.white54, fontSize:11))]))]),
          SizedBox(height:8), Row(children: [Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: (){}, child: Text('أوافق - ندفع ليه'))), SizedBox(width:8), Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: (){}, child: Text('نرفض')))]),
        ])),
        SizedBox(height:20), Text('Versión 2.26.39.79 - المصمم: Soufiane Oufqir - Beni Mellal - App: com.hafalati.wedding', style: TextStyle(color: Colors.white38, fontSize:10), textAlign: TextAlign.center),
      ]),
    );
  }
  Widget _demande(String n, String d1, String d2, Color g) => Container(margin: EdgeInsets.only(bottom:10), padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12), border: Border.all(color: g.withOpacity(0.6))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(n, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text(d1, style: TextStyle(color: Colors.white70, fontSize:12)), Text(d2, style: TextStyle(color: g, fontSize:11)), SizedBox(height:8), Row(children: [Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: (){}, child: Text('أقبل Accepter'))), SizedBox(width:8), Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: (){}, child: Text('أرفض Rejeter')))])]));
  Widget _solde(String n, String s, bool me) => Container(margin: EdgeInsets.only(top:8), padding: EdgeInsets.all(10), decoration: BoxDecoration(color: me? Color(0xFF3A2E0A): Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(10), border: Border(left: BorderSide(color: Color(0xFFD4AF37), width:3))), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(n, style: TextStyle(color: me? Color(0xFFD4AF37): Colors.white, fontWeight: me? FontWeight.bold: FontWeight.normal)), Text(s, style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold))]));
}
