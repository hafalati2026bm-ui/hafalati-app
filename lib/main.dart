import 'package:flutter/material.dart';
void main() => runApp(MaterialApp(debugShowCheckedModeBanner:false, home: Home()));
class Home extends StatefulWidget { @override _HomeState createState() => _HomeState(); }
class _HomeState extends State<Home> {
  int i=2; final gold=Color(0xFFD4AF37);
  String price='5,000'; String solo='10,000'; String chikhat='20,000';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F0F),
      body: i==0 ? clientView() : i==1 ? bandView() : adminView(),
      bottomNavigationBar: BottomNavigationBar(backgroundColor: Color(0xFF0F0F0F), selectedItemColor: gold, unselectedItemColor: Colors.white38, currentIndex: i, onTap: (v)=> setState(()=> i=v), items: [
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'زبون'),
        BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'فرقة'),
        BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'أنا الأدمن'),
      ]),
    );
  }
  // 1 - وجه الزبون
  Widget clientView() => ListView(padding: EdgeInsets.all(16), children: [
    SizedBox(height:30), Text('HAFALATI - كيفاش كيطلع للزبون', style: TextStyle(color: gold, fontSize:20, fontWeight: FontWeight.bold)),
    SizedBox(height:10),
    _card('أوركسترا سفيان اوفقير', 'بني ملال - شعبي', '10,000 MAD Solo / 20,000 Chikhat - 4.8 ★'),
    _card('أوركسترا الأندلس', 'مراكش - أندلسي', '5,000 MAD / حفلة - 4.9 ★'),
    _card('قاعة الرياض', 'الرباط', '8,000 MAD / ليلة - 5.0 ★'),
  ]);
  // 2 - وجه الفرقة
  Widget bandView() => ListView(padding: EdgeInsets.all(16), children: [
    SizedBox(height:30), Text('صفحتي - أنا كنحدد الثمن والتواريخ', style: TextStyle(color: gold, fontSize:18, fontWeight: FontWeight.bold)),
    SizedBox(height:10),
    TextField(decoration: InputDecoration(labelText: 'الثمن: $price MAD', labelStyle: TextStyle(color: gold), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: gold))), style: TextStyle(color: Colors.white), onChanged: (v)=> setState(()=> price=v)),
    SizedBox(height:10),
    TextField(decoration: InputDecoration(labelText: 'Solo: $solo MAD', labelStyle: TextStyle(color: gold), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: gold))), style: TextStyle(color: Colors.white)),
    SizedBox(height:10),
    TextField(decoration: InputDecoration(labelText: 'Chikhat: $chikhat MAD', labelStyle: TextStyle(color: gold), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: gold))), style: TextStyle(color: Colors.white)),
    SizedBox(height:15), Text('التواريخ:', style: TextStyle(color: gold)), ListTile(title: Text('26 Oct محجوز - قاعة الرياض', style: TextStyle(color: Colors.white)), trailing: Icon(Icons.block, color: Colors.red)), ListTile(title: Text('27 Oct خاوي', style: TextStyle(color: Colors.white)), trailing: Icon(Icons.check, color: Colors.green)),
    ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: gold), onPressed: (){}, child: Text('زيد تاريخ جديد', style: TextStyle(color: Colors.black))),
    SizedBox(height:15), Text('فيديوهاتي:', style: TextStyle(color: gold)), ListTile(leading: Icon(Icons.play_circle, color: gold), title: Text('فيديو عرس 2:34', style: TextStyle(color: Colors.white)), trailing: Icon(Icons.delete, color: Colors.red)), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: gold), onPressed: (){}, child: Text('رفع فيديو جديد', style: TextStyle(color: Colors.black))),
  ]);
  // 3 - وجهك انت
  Widget adminView() => ListView(padding: EdgeInsets.all(16), children: [
    SizedBox(height:30),
    Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12), border: Border(left: BorderSide(color: gold, width:4))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('أرباحي أنا', style: TextStyle(color: Colors.white70)), Text('248,750 DH', style: TextStyle(color: Colors.white, fontSize:32, fontWeight: FontWeight.bold)), Text('Escrow: 125,420 DH | عمولات: 12,542 DH', style: TextStyle(color: gold)),
      SizedBox(height:8), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: gold), onPressed: (){}, child: Text('سحب فلوسي إلى Attijariwafa ****4521', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
    ])),
    SizedBox(height:15), Text('نقبل ولا نرفض', style: TextStyle(color: gold, fontWeight: FontWeight.bold)),
    _dem('أوركسترا الأندلس - بغا يطلع الثمن من 5,000 إلى 6,000 MAD'), _dem('أوركسترا نجوم سوس - زاد 2 فيديو جداد'),
    SizedBox(height:15), Text('الفرق باغين يسحبو', style: TextStyle(color: gold)), ListTile(title: Text('سفيان يطلب سحب 6,000 DH', style: TextStyle(color: Colors.white)), subtitle: Text('GPS وصل + خدمة مكتملة - إلى Attijariwafa', style: TextStyle(color: Colors.white54, fontSize:11)), trailing: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: (){}, child: Text('أوافق'))),
  ]);
  Widget _card(String n, String c, String p) => Container(margin: EdgeInsets.only(bottom:10), padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(10), border: Border.all(color: gold)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(n, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text(c, style: TextStyle(color: Colors.white54, fontSize:12)), Text(p, style: TextStyle(color: gold, fontSize:12, fontWeight: FontWeight.bold))]));
  Widget _dem(String t) => Container(margin: EdgeInsets.only(top:8), padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(10), border: Border.all(color: gold)), child: Row(children: [Expanded(child: Text(t, style: TextStyle(color: Colors.white, fontSize:12))), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: (){}, child: Text('أقبل')), SizedBox(width:5), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: (){}, child: Text('أرفض'))]));
}
