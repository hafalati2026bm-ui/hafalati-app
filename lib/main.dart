import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

const waNumber = "212704246107";

class AppState extends ChangeNotifier {
  List<Map<String, dynamic>> pending = [];
  List<Map<String, dynamic>> approved = [];
  List<Map<String, dynamic>> bookings = [];
  
  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    try {
      pending = List<Map<String, dynamic>>.from(jsonDecode(p.getString('pending') ?? '[]'));
      approved = List<Map<String, dynamic>>.from(jsonDecode(p.getString('approved') ?? '[]'));
      bookings = List<Map<String, dynamic>>.from(jsonDecode(p.getString('bookings') ?? '[]'));
    } catch(e){ pending=[]; approved=[]; bookings=[]; }
    if(approved.isEmpty){
      approved=[
        {'name':'أوركسترا العسري','user':'asri','phone':'0600000000','type':'فرقة','cin':'','videos':[],'schedule':[]},
        {'name':'نكافة بريستيج','user':'nagafa','phone':'0611111111','type':'نگافة','cin':'','videos':[],'schedule':[]},
        {'name':'تريتور الرحالي','user':'traiteur','phone':'0622222222','type':'تريتور','cin':'','videos':[],'schedule':[]},
        {'name':'المصور أمين','user':'mosawir','phone':'0633333333','type':'مصور','cin':'','videos':[],'schedule':[]},
        {'name':'دقايقية مراكش','user':'daqayqi','phone':'0644444444','type':'فنان','cin':'','videos':[],'schedule':[]},
        {'name':'قاعة قصر الأفراح','user':'qaa','phone':'0655555555','type':'قاعة','cin':'','videos':[],'schedule':[]},
      ];
      save();
    }
    notifyListeners();
  }
  Future<void> save() async { final p=await SharedPreferences.getInstance(); await p.setString('pending', jsonEncode(pending)); await p.setString('approved', jsonEncode(approved)); await p.setString('bookings', jsonEncode(bookings)); }
  void addPending(Map<String, dynamic> f){ pending.add(f); save(); notifyListeners(); }
  void approve(int i){ approved.add(pending[i]); pending.removeAt(i); save(); notifyListeners(); }
  void reject(int i){ pending.removeAt(i); save(); notifyListeners(); }
  void addVideo(String u, String path){ for(var f in approved){ if(f['user']==u){ (f['videos'] as List).add(path); save(); notifyListeners(); return; } } }
  void addSchedule(String u, Map<String, dynamic> s){ for(var f in approved){ if(f['user']==u){ (f['schedule'] as List).add(s); save(); notifyListeners(); return; } } }
  void delSchedule(String u, int idx){ for(var f in approved){ if(f['user']==u){ (f['schedule'] as List).removeAt(idx); save(); notifyListeners(); return; } } }
  int idxByPhone(String ph){ for(int i=0;i<approved.length;i++){ if(approved[i]['phone']==ph) return i; } return -1; }
  int idxByUser(String u){ for(int i=0;i<approved.length;i++){ if(approved[i]['user']==u) return i; } return -1; }
  void addBooking(Map<String, dynamic> b){ bookings.add(b); save(); notifyListeners(); }
}

void main()=> runApp(const MyApp());
class MyApp extends StatelessWidget{ const MyApp({super.key}); @override Widget build(BuildContext c){ return ChangeNotifierProvider(create: (_)=> AppState()..load(), child: MaterialApp(debugShowCheckedModeBanner:false, theme: ThemeData(scaffoldBackgroundColor: Colors.black), home: const MainScreen())); } }

class MainScreen extends StatefulWidget{ const MainScreen({super.key}); @override State<MainScreen> createState()=> _M(); }
class _M extends State<MainScreen>{
  int idx=0;
  final screens=[const TikTokScreen(), const RegisterScreen(), const AdminLogin()];
  @override Widget build(BuildContext c){ return Scaffold(body: screens[idx], bottomNavigationBar: BottomNavigationBar(currentIndex: idx, backgroundColor: Colors.grey[900], selectedItemColor: Colors.amber, unselectedItemColor: Colors.white60, onTap: (i)=> setState(()=> idx=i), items: const [BottomNavigationBarItem(icon: Icon(Icons.play_circle), label: 'تيك توك'), BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'تسجيل'), BottomNavigationBarItem(icon: Icon(Icons.security), label: 'أدمين')])); }
}

class TikTokScreen extends StatelessWidget{
  const TikTokScreen({super.key});
  @override Widget build(BuildContext c){
    final st=c.watch<AppState>();
    if(st.approved.isEmpty) return const Center(child: CircularProgressIndicator());
    return PageView.builder(scrollDirection: Axis.vertical, itemCount: st.approved.length, itemBuilder: (ctx,i){
      final f=st.approved[i];
      return Stack(children:[
        Container(color: Colors.black, child: Center(child: Icon(Icons.play_arrow, size:80, color: Colors.white24))),
        Positioned(bottom:60, left:20, right:110, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
          Text(f['name'], style: const TextStyle(color:Colors.white, fontSize:18, fontWeight: FontWeight.bold)),
          Container(padding: const EdgeInsets.symmetric(horizontal:8, vertical:4), color: Colors.amber, child: Text('${f['type']} - ${f['phone']}', style: const TextStyle(color:Colors.black, fontSize:11))),
          const SizedBox(height:6),
          Text('${(f['videos'] as List).length} فيديو - ${(f['schedule'] as List).length} جدول', style: const TextStyle(color:Colors.white70, fontSize:11)),
          ...(f['schedule'] as List).take(2).map((s)=> Text('${s['date']} - ${s['price']}', style: const TextStyle(color:Colors.white54, fontSize:10))).toList(),
        ])),
        Positioned(bottom:60, right:20, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366), shape: const CircleBorder(), padding: const EdgeInsets.all(16)), onPressed: () async { final msg='بغيت نحجز ${f['name']}'; final url=Uri.parse('https://wa.me/$waNumber?text=${Uri.encodeComponent(msg)}'); await launchUrl(url, mode: LaunchMode.externalApplication); final p=await SharedPreferences.getInstance(); c.read<AppState>().addBooking({'clientPhone':p.getString('cPhone')??'زبون','ferqaName':f['name'],'ferqaType':f['type'],'date':DateTime.now().toString()}); }, child: const Column(children:[Icon(Icons.phone, color:Colors.white), Text('حجز', style: TextStyle(color:Colors.white, fontSize:9))]))),
      ]);
    });
  }
}

class RegisterScreen extends StatefulWidget{ const RegisterScreen({super.key}); @override State<RegisterScreen> createState()=> _R(); }
class _R extends State<RegisterScreen>{
  String role='فرقة';
  final roles=['فرقة','مصور','تريتور','فنان','نگافة','قاعة'];
  final name=TextEditingController(); final phone=TextEditingController(); String? cin; bool done=false;
  Future<void> pick() async { final x=await ImagePicker().pickImage(source: ImageSource.gallery); if(x!=null) setState(()=> cin=x.path); }
  @override Widget build(BuildContext c){
    if(done) return Scaffold(backgroundColor: Colors.grey[950], body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children:[const Icon(Icons.check, color:Colors.amber, size:50), const Text('تم - الأدمين يقبل ولا يرفض', style: TextStyle(color:Colors.white)), ElevatedButton(onPressed: ()=> setState(()=> done=false), child: const Text('رجوع'))])));
    return Scaffold(backgroundColor: Colors.grey[950], appBar: AppBar(title: const Text('تسجيل'), backgroundColor: Colors.amber), body: Padding(padding: const EdgeInsets.all(16), child: Column(children:[
      DropdownButton<String>(value: role, dropdownColor: Colors.grey[900], style: const TextStyle(color:Colors.white), isExpanded:true, items: roles.map((r)=> DropdownMenuItem(value:r, child: Text(r))).toList(), onChanged: (v)=> setState(()=> role=v!)),
      const SizedBox(height:12),
      TextField(controller: name, style: const TextStyle(color:Colors.white), decoration: InputDecoration(labelText: 'اسم المجموعة', labelStyle: const TextStyle(color:Colors.grey), enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color:Colors.amber)))),
      const SizedBox(height:12),
      TextField(controller: phone, style: const TextStyle(color:Colors.white), decoration: InputDecoration(labelText: 'نمرتو', labelStyle: const TextStyle(color:Colors.grey), enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color:Colors.amber)))),
      const SizedBox(height:12),
      GestureDetector(onTap: pick, child: Container(height:100, width: double.infinity, decoration: BoxDecoration(color: Colors.grey[900], border: Border.all(color:Colors.amber)), child: Center(child: Text(cin==null? 'بطاقة هوية - اضغط' : cin!.split('/').last, style: const TextStyle(color:Colors.white))))),
      const SizedBox(height:20),
      SizedBox(width: double.infinity, height:50, child: ElevatedButton(onPressed: (){ if(name.text.isEmpty||phone.text.isEmpty||cin==null) return; context.read<AppState>().addPending({'name':name.text.trim(),'user':phone.text.trim(),'phone':phone.text.trim(),'type':role,'cin':cin,'videos':[],'schedule':[]}); setState(()=> done=true); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.amber), child: const Text('إرسال', style: TextStyle(color:Colors.black)))),
      const SizedBox(height:10),
      SizedBox(width: double.infinity, child: OutlinedButton(onPressed: (){ final i=context.read<AppState>().idxByPhone(phone.text.trim()); if(i==-1) return; Navigator.push(c, MaterialPageRoute(builder: (_)=> Dashboard(user: context.read<AppState>().approved[i]['user']))); }, child: const Text('عندي حساب - دخول', style: TextStyle(color:Colors.amber)))),
    ])));
  }
}

class Dashboard extends StatefulWidget{ final String user; const Dashboard({super.key, required this.user}); @override State<Dashboard> createState()=> _D(); }
class _D extends State<Dashboard>{
  Future<void> pickVideo() async { final v=await ImagePicker().pickVideo(source: ImageSource.gallery); if(v!=null){ context.read<AppState>().addVideo(widget.user, v.path); } }
  Future<void> addSched() async { final d=TextEditingController(); final pr=TextEditingController(); showDialog(context: context, builder: (ctx)=> AlertDialog(title: const Text('جدول'), content: Column(mainAxisSize: MainAxisSize.min, children:[TextField(controller:d, decoration: const InputDecoration(labelText:'التاريخ')), TextField(controller:pr, decoration: const InputDecoration(labelText:'الثمن'))]), actions:[ElevatedButton(onPressed: (){ context.read<AppState>().addSchedule(widget.user, {'date':d.text,'price':pr.text,'status':'متاح'}); Navigator.pop(ctx); }, child: const Text('إضافة'))])); }
  @override Widget build(BuildContext c){ final st=c.watch<AppState>(); final idx=st.idxByUser(widget.user); if(idx==-1) return const Scaffold(body: Center(child: Text('Waiting'))); final f=st.approved[idx]; return Scaffold(backgroundColor: Colors.grey[950], appBar: AppBar(title: Text(f['name']), backgroundColor: Colors.amber), body: ListView(padding: const EdgeInsets.all(16), children:[Row(children:[Expanded(child: ElevatedButton(onPressed: pickVideo, style: ElevatedButton.styleFrom(backgroundColor: Colors.amber), child: const Text('فيديو', style: TextStyle(color:Colors.black)))), const SizedBox(width:8), Expanded(child: ElevatedButton(onPressed: addSched, child: const Text('جدول')))]), const SizedBox(height:12), Text('${(f['videos'] as List).length} فيديو', style: const TextStyle(color:Colors.white)), ...(f['videos'] as List).map((v)=> Container(margin: const EdgeInsets.only(top:6), padding: const EdgeInsets.all(8), color: Colors.grey[900], child: Text(v.toString().split('/').last, style: const TextStyle(color:Colors.white, fontSize:11)))).toList(), ...(f['schedule'] as List).map((s)=> Container(margin: const EdgeInsets.only(top:6), padding: const EdgeInsets.all(8), color: Colors.black, child: Text('${s['date']} - ${s['price']}', style: const TextStyle(color:Colors.white)))).toList(),])); }
}

class AdminLogin extends StatefulWidget{ const AdminLogin({super.key}); @override State<AdminLogin> createState()=> _A(); }
class _A extends State<AdminLogin>{ final pass=TextEditingController(); @override Widget build(BuildContext c){ return Scaffold(backgroundColor: Colors.grey[950], appBar: AppBar(title: const Text('أدمين'), backgroundColor: Colors.amber), body: Padding(padding: const EdgeInsets.all(20), child: Column(children:[TextField(controller: pass, obscureText:true, style: const TextStyle(color:Colors.white), decoration: InputDecoration(labelText: 'hafalati2026', border: OutlineInputBorder(borderSide: const BorderSide(color:Colors.amber)))), const SizedBox(height:16), SizedBox(width: double.infinity, height:50, child: ElevatedButton(onPressed: (){ if(pass.text.trim()=='hafalati2026'){ Navigator.push(c, MaterialPageRoute(builder: (_)=> const AdminPage())); } }, style: ElevatedButton.styleFrom(backgroundColor: Colors.amber), child: const Text('دخول', style: TextStyle(color:Colors.black))))]))); } }

class AdminPage extends StatefulWidget{ const AdminPage({super.key}); @override State<AdminPage> createState()=> _AP(); }
class _AP extends State<AdminPage>{
  Future<void> addSched(String user) async { final d=TextEditingController(); final pr=TextEditingController(); showDialog(context: context, builder: (ctx)=> AlertDialog(content: Column(mainAxisSize: MainAxisSize.min, children:[TextField(controller:d, decoration: const InputDecoration(labelText:'التاريخ')), TextField(controller:pr, decoration: const InputDecoration(labelText:'الثمن'))]), actions:[ElevatedButton(onPressed: (){ context.read<AppState>().addSchedule(user, {'date':d.text,'price':pr.text,'status':'متاح'}); Navigator.pop(ctx); }, child: const Text('إضافة'))])); }
  @override Widget build(BuildContext c){
    final st=c.watch<AppState>();
    return DefaultTabController(length:3, child: Scaffold(backgroundColor: Colors.grey[950], appBar: AppBar(backgroundColor: Colors.amber, title: Text('${st.pending.length}/${st.approved.length}/${st.bookings.length}', style: const TextStyle(color:Colors.black, fontSize:12)), bottom: const TabBar(labelColor:Colors.black, tabs:[Tab(text:'قبول'), Tab(text:'جداول'), Tab(text:'حجوزات')])), body: TabBarView(children:[
      st.pending.isEmpty? const Center(child: Text('لا يوجد', style: TextStyle(color:Colors.white))): ListView.builder(padding: const EdgeInsets.all(12), itemCount: st.pending.length, itemBuilder: (co,i){ final f=st.pending[i]; return Container(margin: const EdgeInsets.only(bottom:8), padding: const EdgeInsets.all(12), color: Colors.grey[900], child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(f['name'], style: const TextStyle(color:Colors.white, fontWeight: FontWeight.bold)), Text('${f['type']} - ${f['phone']}', style: const TextStyle(color:Colors.white70, fontSize:11)), Row(children:[Expanded(child: OutlinedButton(onPressed: ()=> c.read<AppState>().reject(i), child: const Text('رفض'))), const SizedBox(width:8), Expanded(child: ElevatedButton(onPressed: ()=> c.read<AppState>().approve(i), style: ElevatedButton.styleFrom(backgroundColor: Colors.amber), child: const Text('قبول', style: TextStyle(color:Colors.black))))])]))); },
      ListView.builder(padding: const EdgeInsets.all(12), itemCount: st.approved.length, itemBuilder: (co,i){ final f=st.approved[i]; return Container(margin: const EdgeInsets.only(bottom:10), padding: const EdgeInsets.all(10), color: Colors.grey[900], child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Row(children:[Expanded(child: Text('${f['name']} - ${f['phone']}', style: const TextStyle(color:Colors.white, fontSize:12))), IconButton(icon: const Icon(Icons.add, color:Colors.amber), onPressed: ()=> addSched(f['user']))]), ...(f['schedule'] as List).asMap().entries.map((e)=> Row(children:[Expanded(child: Text('${e.value['date']} - ${e.value['price']}', style: const TextStyle(color:Colors.white70, fontSize:11))), IconButton(icon: const Icon(Icons.delete, color:Colors.red, size:16), onPressed: ()=> c.read<AppState>().delSchedule(f['user'], e.key))])).toList(),])); }),
      st.bookings.isEmpty? const Center(child: Text('لا يوجد', style: TextStyle(color:Colors.white))): ListView.builder(padding: const EdgeInsets.all(12), itemCount: st.bookings.length, itemBuilder: (co,i){ final b=st.bookings[i]; return Container(margin: const EdgeInsets.only(bottom:8), padding: const EdgeInsets.all(10), color: Colors.grey[900], child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text('${b['ferqaName']} - ${b['clientPhone']}', style: const TextStyle(color:Colors.white)), ElevatedButton(onPressed: () async { final url=Uri.parse('https://wa.me/${b['clientPhone']}'); await launchUrl(url, mode: LaunchMode.externalApplication); }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366)), child: const Text('واتساب', style: TextStyle(color:Colors.white)))])); }),
    ]))));
  }
}
