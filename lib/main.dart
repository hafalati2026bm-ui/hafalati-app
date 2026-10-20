import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main()=> runApp(const HafalatiApp());

enum ProviderType { client, orchestre, neggafa, traiteur, daqayqia, salle }
enum DayStatus { disponible, reserve, attente }

extension Ext on ProviderType {
  String get ar {
    switch(this){
      case ProviderType.client: return "زبون";
      case ProviderType.orchestre: return "فرقة موسيقية";
      case ProviderType.neggafa: return "نگافة";
      case ProviderType.traiteur: return "ترايتور";
      case ProviderType.daqayqia: return "دقايقية وعيساوة";
      case ProviderType.salle: return "قاعة حفلات";
    }
  }
  String get fr {
    switch(this){
      case ProviderType.client: return "Client";
      case ProviderType.orchestre: return "Orchestre";
      case ProviderType.neggafa: return "Neggafa";
      case ProviderType.traiteur: return "Traiteur";
      case ProviderType.daqayqia: return "Dqayqia";
      case ProviderType.salle: return "Salle des fetes";
    }
  }
  String get icon {
    switch(this){
      case ProviderType.client: return "👰";
      case ProviderType.orchestre: return "🎻";
      case ProviderType.neggafa: return "👘";
      case ProviderType.traiteur: return "🍽️";
      case ProviderType.daqayqia: return "🥁";
      case ProviderType.salle: return "🏰";
    }
  }
}

class HafalatiApp extends StatelessWidget {
  const HafalatiApp({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HAFALATI V2',
      theme: ThemeData(scaffoldBackgroundColor: Color(0xFF0A0A0A), colorScheme: ColorScheme.dark(primary: Color(0xFFD4AF37))),
      home: OnboardingV2(),
    );
  }
}

class OnboardingV2 extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    final types = ProviderType.values;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text('HAFALATI', style: TextStyle(color: Color(0xFFD4AF37), fontSize:34, fontWeight: FontWeight.bold)),
              Text('سوق الأعراس المغربية - Narjiss Trifali', style: TextStyle(color: Colors.white70, fontSize:12)),
              SizedBox(height:10),
              Text('مرحبا! كيف تريد الانضمام؟', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFD4AF37), fontSize:16)),
              SizedBox(height:20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2, childAspectRatio:1.0, crossAxisSpacing:12, mainAxisSpacing:12),
                  itemCount: types.length,
                  itemBuilder: (c,i){
                    final t = types[i];
                    final isClient = t==ProviderType.client;
                    return GestureDetector(
                      onTap: (){
                        if(isClient) Navigator.push(context, MaterialPageRoute(builder:(_)=> ClientSearchScreen()));
                        else Navigator.push(context, MaterialPageRoute(builder:(_)=> ProviderCalendarScreen(type: t)));
                      },
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(color: Color(0xFFD4AF37), width: isClient?2:1), borderRadius: BorderRadius.circular(16), color: isClient? Color(0xFFD4AF37).withOpacity(0.15): Colors.white.withOpacity(0.05)),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children:[
                          Text(t.icon, style: TextStyle(fontSize:30)),
                          SizedBox(height:8),
                          Text(t.ar, style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize:13)),
                          Text(t.fr, style: TextStyle(color: Colors.white60, fontSize:11)),
                          SizedBox(height:6),
                          Container(padding: EdgeInsets.symmetric(horizontal:8, vertical:2), decoration: BoxDecoration(color: isClient? Color(0xFFD4AF37): Colors.transparent, border: Border.all(color: Color(0xFFD4AF37)), borderRadius: BorderRadius.circular(8)), child: Text(isClient? "أبحث عن خدمة":"أقدم خدمة - أنا كنصايب جدولي", style: TextStyle(color: isClient? Colors.black: Color(0xFFD4AF37), fontSize:8))),
                        ]),
                      ),
                    );
                  },
                ),
              ),
              Text('كل مقدم خدمة يصايب جدول ديالو براسو\nChaque prestataire gere son calendrier', textAlign: TextAlign.center, style: TextStyle(color: Colors.white38, fontSize:11)),
            ],
          ),
        ),
      ),
    );
  }
}

class ProviderCalendarScreen extends StatefulWidget {
  final ProviderType type;
  const ProviderCalendarScreen({super.key, required this.type});
  @override
  State<ProviderCalendarScreen> createState()=> _ProviderCalendarState();
}
class _ProviderCalendarState extends State<ProviderCalendarScreen>{
  DateTime _focused = DateTime.now();
  Map<String, DayStatus> _days = {};
  String _key(DateTime d)=> "${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}";
  DayStatus _get(DateTime d)=> _days[_key(d)] ?? DayStatus.disponible;
  Color _color(DayStatus s){
    switch(s){ case DayStatus.disponible: return Colors.green.shade600; case DayStatus.reserve: return Colors.red.shade700; case DayStatus.attente: return Color(0xFFD4AF37); }
  }
  void _toggle(DateTime day){
    final k=_key(day);
    final cur=_days[k] ?? DayStatus.disponible;
    setState((){
      if(cur==DayStatus.disponible) _days[k]=DayStatus.reserve;
      else if(cur==DayStatus.reserve) _days[k]=DayStatus.attente;
      else _days[k]=DayStatus.disponible;
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, title: Text("${widget.type.ar} - جدولي", style: TextStyle(color: Color(0xFFD4AF37))), iconTheme: IconThemeData(color: Color(0xFFD4AF37))),
      body: Column(children:[
        Container(margin: EdgeInsets.all(12), padding: EdgeInsets.all(12), decoration: BoxDecoration(border: Border.all(color: Color(0xFFD4AF37)), borderRadius: BorderRadius.circular(12)), child: Row(children:[Text(widget.type.icon, style: TextStyle(fontSize:28)), SizedBox(width:12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(widget.type.ar+" • "+widget.type.fr, style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)), Text("كليكي على النهار باش تبدل: خاوي/عامر - انت كتصايب جدولك براسك", style: TextStyle(color: Colors.white54, fontSize:11))]))])),
        TableCalendar(firstDay: DateTime.utc(2024,1,1), lastDay: DateTime.utc(2028,12,31), focusedDay: _focused, selectedDayPredicate: (d)=> false, onDaySelected: (s,f){ setState(()=> _focused=f); _toggle(s); }, onPageChanged: (f)=> _focused=f, calendarFormat: CalendarFormat.month, calendarBuilders: CalendarBuilders(defaultBuilder: (ctx, day, focused){ final st=_get(day); return Container(margin: EdgeInsets.all(4), decoration: BoxDecoration(color: _color(st), shape: BoxShape.circle), alignment: Alignment.center, child: Text("${day.day}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))); }), calendarStyle: CalendarStyle(defaultTextStyle: TextStyle(color: Colors.white), weekendTextStyle: TextStyle(color: Colors.white)), headerStyle: HeaderStyle(titleTextStyle: TextStyle(color: Color(0xFFD4AF37)), formatButtonVisible: false)),
        Padding(padding: EdgeInsets.all(12), child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children:[_leg(Colors.green.shade600, "خاوي Disponible"), _leg(Colors.red.shade700, "عامر Reserve"), _leg(Color(0xFFD4AF37), "Attente")])),
        Spacer(),
        Padding(padding: EdgeInsets.all(16), child: ElevatedButton(onPressed: (){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم حفظ الجدول ✅ - الزبون غادي يشوف النهارات الخاوية ديالك"))); }, style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFD4AF37), minimumSize: Size(double.infinity, 50)), child: Text("حفظ الجدول - Enregistrer", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))),
      ]),
    );
  }
  Widget _leg(Color c, String t)=> Row(children:[Container(width:12,height:12, decoration: BoxDecoration(color:c, shape:BoxShape.circle)), SizedBox(width:4), Text(t, style: TextStyle(color: Colors.white70, fontSize:10))]);
}

class ClientSearchScreen extends StatefulWidget {
  @override
  State<ClientSearchScreen> createState()=> _ClientSearchState();
}
class _ClientSearchState extends State<ClientSearchScreen>{
  DateTime selDate = DateTime(2026,7,20);
  String query="";
  ProviderType? filterType;
  List<Map<String,dynamic>> get data => [
    {"name":"Salle Al Andalous","type":ProviderType.salle,"ville":"Beni Mellal","price":12000,"status":DayStatus.disponible,"rating":4.8,"icon":"🏰"},
    {"name":"Neggafa Fatima Zohra","type":ProviderType.neggafa,"ville":"Beni Mellal","price":3500,"status":DayStatus.disponible,"rating":4.9,"icon":"👘"},
    {"name":"Orchestre Nass El Ghiwan","type":ProviderType.orchestre,"ville":"Beni Mellal","price":8000,"status":DayStatus.reserve,"rating":4.6,"icon":"🎻"},
    {"name":"Traiteur Al Amal","type":ProviderType.traiteur,"ville":"Beni Mellal","price":8500,"status":DayStatus.disponible,"rating":4.7,"icon":"🍽️"},
    {"name":"Dqayqia Beni Mellal","type":ProviderType.daqayqia,"ville":"Beni Mellal","price":2000,"status":DayStatus.disponible,"rating":4.9,"icon":"🥁"},
  ];
  List<Map<String,dynamic>> get filtered {
    return data.where((p){
      if(query.isNotEmpty && !p["name"].toString().toLowerCase().contains(query.toLowerCase())) return false;
      if(filterType!=null && p["type"]!=filterType) return false;
      return true;
    }).toList();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, title: Text("HAFALATI - بحث الزبون", style: TextStyle(color: Color(0xFFD4AF37))), iconTheme: IconThemeData(color: Color(0xFFD4AF37))),
      body: Column(children:[
        Padding(padding: EdgeInsets.all(16), child: TextField(onChanged: (v)=> setState(()=> query=v), style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: "ابحث... Rechercher salle, neggafa, orchestre...", hintStyle: TextStyle(color: Colors.white38), prefixIcon: Icon(Icons.search, color: Color(0xFFD4AF37)), filled: true, fillColor: Colors.white.withOpacity(0.08), border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Color(0xFFD4AF37)))))),
        SingleChildScrollView(scrollDirection: Axis.horizontal, padding: EdgeInsets.symmetric(horizontal:16), child: Row(children:[
          _chip(Icons.calendar_today, "Date\n${selDate.day} Juillet", () async { final p=await showDatePicker(context: context, initialDate: selDate, firstDate: DateTime.now(), lastDate: DateTime(2028)); if(p!=null) setState(()=> selDate=p); }),
          _chip(Icons.location_on, "Ville\nBeni Mellal", (){}),
          _chip(Icons.stars, "Type\n${filterType?.fr ?? 'Tous'}", (){ showModalBottomSheet(context: context, builder:(_)=> Container(color: Colors.black, child: Column(mainAxisSize: MainAxisSize.min, children: [ListTile(title: Text("Tous - الكل", style: TextStyle(color: Colors.white)), onTap: (){ setState(()=> filterType=null); Navigator.pop(context); }), ...ProviderType.values.where((t)=>t!=ProviderType.client).map((t)=> ListTile(title: Text(t.ar+" - "+t.fr, style: TextStyle(color: Color(0xFFD4AF37))), onTap: (){ setState(()=> filterType=t); Navigator.pop(context); }))]))); }),
          _chip(Icons.sell, "Prix", (){}),
        ])),
        Padding(padding: EdgeInsets.all(16), child: Row(children:[Expanded(child: Text("واش ${selDate.day} خاوية؟ - Disponibilité le ${selDate.day} Juillet", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize:13))), Text("${filtered.length} trouvés", style: TextStyle(color: Color(0xFFD4AF37)))])),
        Expanded(child: ListView.builder(padding: EdgeInsets.all(16), itemCount: filtered.length, itemBuilder: (c,i){ final p=filtered[i]; final isFree=p["status"]==DayStatus.disponible; return Container(margin: EdgeInsets.only(bottom:12), padding: EdgeInsets.all(12), decoration: BoxDecoration(border: Border.all(color: Color(0xFFD4AF37).withOpacity(0.4)), borderRadius: BorderRadius.circular(12), color: Colors.white.withOpacity(0.05)), child: Row(children:[Container(width:55,height:55, alignment: Alignment.center, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)), child: Text(p["icon"], style: TextStyle(fontSize:28))), SizedBox(width:12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(p["name"], style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)), Text("${p["ville"]} • ${(p["type"] as ProviderType).fr}", style: TextStyle(color: Colors.white54, fontSize:11)), SizedBox(height:4), Row(children:[Container(padding: EdgeInsets.symmetric(horizontal:8, vertical:2), decoration: BoxDecoration(color: isFree? Colors.green: Colors.red, borderRadius: BorderRadius.circular(12)), child: Text(isFree? "Disponible خاوي":"Complet عامر", style: TextStyle(color: Colors.white, fontSize:10))), SizedBox(width:8), Text("${p["price"]} DH", style: TextStyle(color: Colors.white, fontSize:12))])])), Column(children:[Text("⭐ ${p["rating"]}", style: TextStyle(color: Colors.white70, fontSize:11)), SizedBox(height:8), Icon(Icons.circle, size:10, color: isFree? Colors.green: Colors.red)])])); })),
      ]),
    );
  }
  Widget _chip(IconData ic, String label, VoidCallback onTap)=> GestureDetector(onTap: onTap, child: Container(margin: EdgeInsets.only(right:8), padding: EdgeInsets.symmetric(horizontal:12, vertical:8), decoration: BoxDecoration(border: Border.all(color: Color(0xFFD4AF37)), borderRadius: BorderRadius.circular(12)), child: Column(children:[Icon(ic, color: Color(0xFFD4AF37), size:18), SizedBox(height:4), Text(label, textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize:9))]))); 
}
