import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

const black = Color(0xFF111111);
const white = Colors.white;
const bg = Color(0xFF1A1A1A);
const greenWA = Color(0xFF25D366);
const amber = Colors.amber;
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
    if(approved.isEmpty && pending.isEmpty){
      approved=[
        {'name':'أوركسترا العسري','user':'asri_0000','phone':'0600000000','type':'أركيسترا','cin':'','videos':[],'schedule':[{'date':'20 دجنبر','price':'15000','status':'متاح'}]},
        {'name':'نكافة بريستيج','user':'prestige_1111','phone':'0611111111','type':'نݣافة','cin':'','videos':[],'schedule':[]},
        {'name':'تموين الرحالي','user':'rahali_2222','phone':'0622222222','type':'تريتور','cin':'','videos':[],'schedule':[]},
        {'name':'المصور أمين','user':'amine_3333','phone':'0633333333','type':'مصور','cin':'','videos':[],'schedule':[]},
        {'name':'دقايقية مراكش','user':'daqayq_4444','phone':'0644444444','type':'دقايقي','cin':'','videos':[],'schedule':[]},
        {'name':'قصر الأفراح','user':'qasr_5555','phone':'0655555555','type':'قاعة','cin':'','videos':[],'schedule':[]},
      ];
      await save();
    }
    notifyListeners();
  }
  Future<void> save() async { final p=await SharedPreferences.getInstance(); await p.setString('pending', jsonEncode(pending)); await p.setString('approved', jsonEncode(approved)); await p.setString('bookings', jsonEncode(bookings)); }
  void addPending(Map<String, dynamic> f){ pending.add(f); save(); notifyListeners(); }
  void approve(int i){ approved.add(pending[i]); pending.removeAt(i); save(); notifyListeners(); }
  void reject(int i){ pending.removeAt(i); save(); notifyListeners(); }
  void addBooking(Map<String, dynamic> b){ bookings.add(b); save(); notifyListeners(); }
  void addVideo(String user, String path){ for(var f in approved){ if(f['user']==user){ (f['videos'] as List).add(path); save(); notifyListeners(); return; } } }
  void addSchedule(String user, Map<String, dynamic> s){ for(var f in approved){ if(f['user']==user){ (f['schedule'] as List).add(s); save(); notifyListeners(); return; } } }
  void delSchedule(String user, int idx){ for(var f in approved){ if(f['user']==user){ (f['schedule'] as List).removeAt(idx); save(); notifyListeners(); return; } } }
  void delVideo(String user, int idx){ for(var f in approved){ if(f['user']==user){ (f['videos'] as List).removeAt(idx); save(); notifyListeners(); return; } } }
  int idxByPhone(String phone){ for(int i=0;i<approved.length;i++){ if(approved[i]['phone']==phone) return i; } return -1; }
  int idxByUser(String user){ for(int i=0;i<approved.length;i++){ if(approved[i]['user']==user) return i; } return -1; }
}

void main()=> runApp(const HafalatiApp());
class HafalatiApp extends StatelessWidget{ const HafalatiApp({super.key}); @override Widget build(BuildContext c){ return ChangeNotifierProvider(create: (_)=> AppState()..load(), child: MaterialApp(title: 'Hafalati', debugShowCheckedModeBanner:false, theme: ThemeData(primarySwatch: Colors.amber, scaffoldBackgroundColor: black), home: const MainNavigationScreen())); } }

class MainNavigationScreen extends StatefulWidget{ const MainNavigationScreen({super.key}); @override State<MainNavigationScreen> createState()=> _MainNavState(); }
class _MainNavState extends State<MainNavigationScreen>{
  int _selectedIndex = 0;
  final List<Widget> _screens = [const TikTokVideoScreen(), const RegisterScreen(), const AdminLoginScreen()];
  @override Widget build(BuildContext c){
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.grey[900],
        selectedItemColor: amber,
        unselectedItemColor: Colors.white60,
        onTap: (i)=> setState(()=> _selectedIndex=i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.play_circle_fill), label: 'تيك توك الأعراس'),
          BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'تسجيل الحسابات'),
          BottomNavigationBarItem(icon: Icon(Icons.security), label: 'دخول الأدمن السري'),
        ],
      ),
    );
  }
}

class TikTokVideoScreen extends StatelessWidget{
  const TikTokVideoScreen({super.key});
  void _openWhatsApp(BuildContext context, Map<String, dynamic> ferqa) async {
    final msg='السلام بغيت نحجز ${ferqa['name']} - ${ferqa['type']} - ${ferqa['phone']}';
    final url=Uri.parse('https://wa.me/$waNumber?text=${Uri.encodeComponent(msg)}');
    await launchUrl(url, mode: LaunchMode.externalApplication);
    final p=await SharedPreferences.getInstance();
    final cPhone=p.getString('cPhone')??'زبون';
    final cName=p.getString('cName')??'زبون';
    context.read<AppState>().addBooking({'clientName':cName,'clientPhone':cPhone,'ferqaName':ferqa['name'],'ferqaType':ferqa['type'],'ferqaPhone':ferqa['phone'],'date':DateTime.now().toString()});
  }
  @override Widget build(BuildContext c){
    final st=c.watch<AppState>();
    if(st.approved.isEmpty){ return const Center(child: CircularProgressIndicator(color: amber)); }
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: st.approved.length,
      itemBuilder: (context, index){
        final item=st.approved[index];
        final vids=item['videos'] as List;
        final sched=item['schedule'] as List;
        return Stack(children:[
          Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [black, Colors.blueGrey[900]!], begin: Alignment.topCenter, end: Alignment.bottomCenter)), child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children:[const Icon(Icons.play_arrow, size:90, color: Colors.white38), const SizedBox(height:10), Text('${vids.length} فيديو - ${sched.length} جدول', style: const TextStyle(color: Colors.white38, fontSize:12))]))),
          Positioned(bottom: 50, left:20, right:110, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
            Row(children:[const Icon(Icons.verified, color: amber, size:20), const SizedBox(width:5), Expanded(child: Text(item['name'], style: const TextStyle(color: white, fontSize:18, fontWeight: FontWeight.bold)))]),
            const SizedBox(height:5),
            Container(padding: const EdgeInsets.symmetric(horizontal:10, vertical:4), decoration: BoxDecoration(color: amber, borderRadius: BorderRadius.circular(5)), child: Text('${item['type']} - ${item['phone']}', style: const TextStyle(color: black, fontWeight: FontWeight.bold, fontSize:12))),
            const SizedBox(height:8),
            ...sched.take(2).map((s)=> Text('${s['date']} - ${s['price']} - ${s['status']}', style: const TextStyle(color: Colors.white70, fontSize:11))).toList(),
          ])),
          Positioned(bottom: 50, right:20, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: greenWA, shape: const CircleBorder(), padding: const EdgeInsets.all(15)), onPressed: ()=> _openWhatsApp(context, item), child: const Column(mainAxisSize: MainAxisSize.min, children:[Icon(Icons.phone, color: white, size:28), SizedBox(height:2), Text('حجز', style: TextStyle(color: white, fontSize:10, fontWeight: FontWeight.bold))]))),
        ]);
      },
    );
  }
}

class RegisterScreen extends StatefulWidget{ const RegisterScreen({super.key}); @override State<RegisterScreen> createState()=> _RegState(); }
class _RegState extends State<RegisterScreen>{
  String _selectedRole='1 تسجيل ك زبون';
  final _roles=['1 تسجيل ك زبون','2 تسجل ك مصور','3 سجل ك اركيسترا','4 سجل ك نݣافة','5 سجل ك تريتور','6 سجل ك دقايقي','7 سجل كصاحب قاعة حفلات','سجل ك صاحب اتطبيق ادمين'];
  final groupName=TextEditingController(); final phone=TextEditingController(); String? cinPath; bool sent=false;
  Future<void> pick() async { final x=await ImagePicker().pickImage(source: ImageSource.gallery); if(x!=null){ setState(()=> cinPath=x.path); } }
  @override Widget build(BuildContext c){
    if(sent){ return Scaffold(backgroundColor: Colors.grey[950], body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children:[const Icon(Icons.check_circle, color: amber, size:60), const SizedBox(height:12), const Text('تم الإرسال - الأدمين غادي يقبل ولا يرفض', style: TextStyle(color:white)), const SizedBox(height:20), ElevatedButton(onPressed: ()=> setState(()=> sent=false), style: ElevatedButton.styleFrom(backgroundColor: amber), child: const Text('رجوع', style: TextStyle(color:black)))]))); }
    return Scaffold(backgroundColor: Colors.grey[950], appBar: AppBar(title: const Text('تسجيل مستخدم جديد', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: amber, centerTitle:true),
      body: Padding(padding: const EdgeInsets.all(20), child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
        const Text('اختر صفتك فالتطبيق أولاً:', style: TextStyle(color:white, fontSize:16)),
        const SizedBox(height:10),
        Container(padding: const EdgeInsets.symmetric(horizontal:12), decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(10), border: Border.all(color: amber)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value:_selectedRole, dropdownColor: Colors.grey[900], isExpanded:true, style: const TextStyle(color:white, fontSize:16, fontWeight: FontWeight.bold), icon: const Icon(Icons.arrow_drop_down, color: amber), items: _roles.map((r)=> DropdownMenuItem(value:r, child: Text(r))).toList(), onChanged: (v)=> setState(()=> _selectedRole=v!)))),
        const SizedBox(height:20),
        if(_selectedRole.contains('زبون')) ...[
          TextField(controller: phone, keyboardType: TextInputType.phone, style: const TextStyle(color:white), decoration: InputDecoration(labelText: 'رقم الهاتف والواتساب - نمرتو', labelStyle: const TextStyle(color:Colors.grey), enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color:amber), borderRadius: BorderRadius.circular(10)))),
          const SizedBox(height:20),
          SizedBox(width: double.infinity, height:50, child: ElevatedButton(onPressed: () async { if(phone.text.isEmpty) return; final p=await SharedPreferences.getInstance(); await p.setString('cPhone', phone.text.trim()); await p.setString('cName', phone.text.trim()); if(!mounted) return; ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم دخول زبون - كيشوف الفيديوهات ويحجز عندك 0704246107'))); }, style: ElevatedButton.styleFrom(backgroundColor: amber), child: const Text('دخول ك زبون - يشوف الفيديوهات', style: TextStyle(color:black, fontWeight: FontWeight.bold)))),
        ] else ...[
          TextField(controller: groupName, style: const TextStyle(color:white), decoration: InputDecoration(labelText: 'اسم المجموعة ديالو', labelStyle: const TextStyle(color:Colors.grey), enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color:amber), borderRadius: BorderRadius.circular(10)))),
          const SizedBox(height:15),
          TextField(controller: phone, keyboardType: TextInputType.phone, style: const TextStyle(color:white), decoration: InputDecoration(labelText: 'نمرتو', labelStyle: const TextStyle(color:Colors.grey), enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color:amber), borderRadius: BorderRadius.circular(10)))),
          const SizedBox(height:15),
          GestureDetector(onTap: pick, child: Container(height:110, width: double.infinity, decoration: BoxDecoration(color: cinPath!=null? black: Colors.grey[900], borderRadius: BorderRadius.circular(10), border: Border.all(color:amber)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children:[Icon(cinPath!=null? Icons.check_circle: Icons.badge, color: cinPath!=null? amber: white, size:30), const SizedBox(height:6), Text(cinPath!=null? cinPath!.split('/').last : 'بطاقة هوية - اضغط لرفع', style: TextStyle(color: cinPath!=null? amber: Colors.grey, fontSize:11))]))),
          const SizedBox(height:20),
          SizedBox(width: double.infinity, height:50, child: ElevatedButton(onPressed: (){ if(groupName.text.isEmpty||phone.text.isEmpty||cinPath==null) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('عمر اسم المجموعة + نمرتو + بطاقة هوية'))); return; } final type=_selectedRole.contains('مصور')? 'مصور': _selectedRole.contains('اركيسترا')? 'فرقة': _selectedRole.contains('نݣافة')? 'نگافة': _selectedRole.contains('تريتور')? 'تريتور': _selectedRole.contains('دقايقي')? 'فنان': _selectedRole.contains('قاعة')? 'قاعة': 'فرقة'; context.read<AppState>().addPending({'name':groupName.text.trim(),'user':groupName.text.trim().toLowerCase().replaceAll(' ','_')+'_'+phone.text.trim().substring(phone.text.trim().length-4),'phone':phone.text.trim(),'type':type,'cin':cinPath,'videos':[],'schedule':[]}); setState(()=> sent=true); }, style: ElevatedButton.styleFrom(backgroundColor: amber), child: const Text('إرسال - الأدمين يقبل ولا يرفض', style: TextStyle(color:black, fontWeight: FontWeight.bold)))),
          const SizedBox(height:10),
          SizedBox(width: double.infinity, height:44, child: OutlinedButton(onPressed: (){ final idx=context.read<AppState>().idxByPhone(phone.text.trim()); if(idx==-1){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('مازال ما تقبلتيش'))); return; } Navigator.push(context, MaterialPageRoute(builder: (_)=> ProDashboard(user: context.read<AppState>().approved[idx]['user']))); }, child: const Text('عندي حساب - دخول نعمر الصفحة فيديوهات', style: TextStyle(color: amber)))),
        ]
      ]))));
  }
}

class AdminLoginScreen extends StatefulWidget{ const AdminLoginScreen({super.key}); @override State<AdminLoginScreen> createState()=> _AdminLoginState(); }
class _AdminLoginState extends State<AdminLoginScreen>{
  final pass=TextEditingController();
  @override Widget build(BuildContext c){
    return Scaffold(backgroundColor: Colors.grey[950], appBar: AppBar(title: const Text('دخول الأدمن السري'), backgroundColor: amber),
      body: Padding(padding: const EdgeInsets.all(24), child: Column(children:[
        TextField(controller: pass, obscureText:true, style: const TextStyle(color:white), decoration: InputDecoration(labelText: 'كلمة السر hafalati2026', labelStyle: const TextStyle(color:Colors.grey), enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color:amber), borderRadius: BorderRadius.circular(10)))),
        const SizedBox(height:16),
        SizedBox(width: double.infinity, height:50, child: ElevatedButton(onPressed: (){ if(pass.text.trim()=='hafalati2026'){ Navigator.push(c, MaterialPageRoute(builder: (_)=> const AdminPage())); } else { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('كلمة السر غالطة'))); } }, style: ElevatedButton.styleFrom(backgroundColor: amber), child: const Text('دخول - عندي الجداول كاملين', style: TextStyle(color:black, fontWeight: FontWeight.bold)))),
      ])));
  }
}

class AdminPage extends StatefulWidget{ const AdminPage({super.key}); @override State<AdminPage> createState()=> _AdminPageState(); }
class _AdminPageState extends State<AdminPage>{
  Future<void> addSched(String user) async {
    final d=TextEditingController(); final pr=TextEditingController(); final st=TextEditingController(text:'متاح');
    showDialog(context: context, builder: (ctx)=> AlertDialog(backgroundColor: Colors.grey[900], title: const Text('إضافة جدول - أدمين عندو', style: TextStyle(color:white)), content: Column(mainAxisSize: MainAxisSize.min, children:[TextField(controller:d, style: const TextStyle(color:white), decoration: InputDecoration(labelText:'التاريخ', labelStyle: const TextStyle(color:Colors.grey), enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color:amber)))), const SizedBox(height:8), TextField(controller:pr, style: const TextStyle(color:white), decoration: InputDecoration(labelText:'الثمن', labelStyle: const TextStyle(color:Colors.grey), enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color:amber)))), const SizedBox(height:8), TextField(controller:st, style: const TextStyle(color:white), decoration: InputDecoration(labelText:'متاح/محجوز', labelStyle: const TextStyle(color:Colors.grey), enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color:amber))))]), actions:[ElevatedButton(onPressed: (){ if(d.text.isEmpty||pr.text.isEmpty) return; context.read<AppState>().addSchedule(user, {'date':d.text.trim(),'price':pr.text.trim(),'status':st.text.trim()}); Navigator.pop(ctx); }, style: ElevatedButton.styleFrom(backgroundColor: amber), child: const Text('إضافة', style: TextStyle(color:black)))]));
  }
  @override Widget build(BuildContext c){
    final st=c.watch<AppState>();
    return DefaultTabController(length:3, child: Scaffold(backgroundColor: Colors.grey[950], appBar: AppBar(backgroundColor: amber, leading: IconButton(icon: const Icon(Icons.arrow_back, color:black), onPressed: ()=> Navigator.pop(c)), title: Text('${st.pending.length} طلبات - ${st.approved.length} فرق - ${st.bookings.length} حجوزات عندي', style: const TextStyle(color:black, fontSize:10, fontWeight: FontWeight.bold)), bottom: const TabBar(labelColor:black, tabs:[Tab(text:'قبول/رفض'), Tab(text:'الجداول عندي'), Tab(text:'حجوزات')])), body: TabBarView(children:[
      st.pending.isEmpty? const Center(child: Text('لا يوجد', style: TextStyle(color:white))): ListView.builder(padding: const EdgeInsets.all(12), itemCount: st.pending.length, itemBuilder: (co,i){ final f=st.pending[i]; return Container(margin: const EdgeInsets.only(bottom:10), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12), border: Border.all(color:amber)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(f['name'], style: const TextStyle(color:white, fontWeight: FontWeight.bold)), Text('${f['type']} - نمرتو: ${f['phone']}', style: const TextStyle(color:Colors.white70, fontSize:11)), Text('بطاقة: ${f['cin'].toString().split('/').last}', style: const TextStyle(color:Colors.white30, fontSize:9)), const SizedBox(height:8), Row(children:[Expanded(child: OutlinedButton(onPressed: ()=> c.read<AppState>().reject(i), child: const Text('رفض', style: TextStyle(color:white)))), const SizedBox(width:8), Expanded(child: ElevatedButton(onPressed: ()=> c.read<AppState>().approve(i), style: ElevatedButton.styleFrom(backgroundColor: amber), child: const Text('قبول - يدخل يعمر الصفحة', style: TextStyle(color:black, fontSize:9))))])]))); },
      ListView.builder(padding: const EdgeInsets.all(12), itemCount: st.approved.length, itemBuilder: (co,i){ final f=st.approved[i]; final sched=f['schedule'] as List; final vids=f['videos'] as List; return Container(margin: const EdgeInsets.only(bottom:12), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12), border: Border.all(color:white24)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Row(children:[Expanded(child: Text('${f['name']} - ${f['phone']}', style: const TextStyle(color:white, fontWeight: FontWeight.bold, fontSize:12))), IconButton(icon: const Icon(Icons.add, color:amber), onPressed: ()=> addSched(f['user']))]), Text('${vids.length} فيديو - ${sched.length} جدول - الجداول عندي أنا أدمين', style: const TextStyle(color:Colors.white54, fontSize:10)), ...sched.asMap().entries.map((e){ return Container(margin: const EdgeInsets.only(top:6), padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: black, borderRadius: BorderRadius.circular(6)), child: Row(children:[Expanded(child: Text('${e.value['date']} - ${e.value['price']} - ${e.value['status']}', style: const TextStyle(color:white, fontSize:11))), IconButton(icon: const Icon(Icons.delete, size:16, color:Colors.red), onPressed: ()=> c.read<AppState>().delSchedule(f['user'], e.key))])); }).toList(), ])); }),
      st.bookings.isEmpty? const Center(child: Text('حجوزات عندي 0704246107', style: TextStyle(color:white))): ListView.builder(padding: const EdgeInsets.all(12), itemCount: st.bookings.length, itemBuilder: (co,i){ final b=st.bookings[i]; return Container(margin: const EdgeInsets.only(bottom:10), padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(10), border: Border.all(color:white24)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text('${b['clientName']} - ${b['clientPhone']}', style: const TextStyle(color:white, fontWeight: FontWeight.bold)), Text('${b['ferqaName']} - ${b['ferqaType']} - يحجز عندي', style: const TextStyle(color:Colors.white70, fontSize:11)), SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () async { final url=Uri.parse('https://wa.me/${b['clientPhone']}'); await launchUrl(url, mode: LaunchMode.externalApplication); }, style: ElevatedButton.styleFrom(backgroundColor: greenWA), child: const Text('رد واتساب', style: TextStyle(color:white))))])); }),
    ]))));
  }
}

class ProDashboard extends StatefulWidget{ final String user; const ProDashboard({super.key, required this.user}); @override State<ProDashboard> createState()=> _PD(); }
class _PD extends State<ProDashboard>{
  Future<void> pickVideo() async { final v=await ImagePicker().pickVideo(source: ImageSource.gallery); if(v!=null){ if(!mounted) return; context.read<AppState>().addVideo(widget.user, v.path); } }
  Future<void> addSched() async { final d=TextEditingController(); final pr=TextEditingController(); if(!mounted) return; showDialog(context: context, builder: (ctx)=> AlertDialog(backgroundColor: Colors.grey[900], title: const Text('جدول', style: TextStyle(color:white)), content: Column(mainAxisSize: MainAxisSize.min, children:[TextField(controller:d, style: const TextStyle(color:white), decoration: InputDecoration(labelText:'التاريخ', labelStyle: const TextStyle(color:Colors.grey), enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color:amber)))), const SizedBox(height:8), TextField(controller:pr, style: const TextStyle(color:white), decoration: InputDecoration(labelText:'الثمن', labelStyle: const TextStyle(color:Colors.grey), enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color:amber))))]), actions:[ElevatedButton(onPressed: (){ if(d.text.isEmpty||pr.text.isEmpty) return; context.read<AppState>().addSchedule(widget.user, {'date':d.text.trim(),'price':pr.text.trim(),'status':'متاح'}); Navigator.pop(ctx); }, style: ElevatedButton.styleFrom(backgroundColor: amber), child: const Text('إضافة', style: TextStyle(color:black)))])); }
  @override Widget build(BuildContext c){
    final st=c.watch<AppState>(); final idx=st.idxByUser(widget.user);
    if(idx==-1){ return const Scaffold(backgroundColor: black, body: Center(child: Text('Waiting', style: TextStyle(color:white)))); }
    final ferqa=st.approved[idx]; final vids=ferqa['videos'] as List; final sched=ferqa['schedule'] as List;
    return Scaffold(backgroundColor: Colors.grey[950], appBar: AppBar(backgroundColor: amber, title: Text(ferqa['name'], style: const TextStyle(color:black, fontWeight: FontWeight.bold)), actions:[IconButton(icon: const Icon(Icons.logout, color:black), onPressed: () async { final p=await SharedPreferences.getInstance(); await p.clear(); if(!mounted) return; Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> const MainNavigationScreen()), (r)=> false); })]),
      body: ListView(padding: const EdgeInsets.all(16), children:[
        Text('${ferqa['name']} - ${ferqa['phone']} - ${ferqa['type']}', style: const TextStyle(color:white, fontWeight: FontWeight.bold)),
        const SizedBox(height:12),
        Row(children:[Expanded(child: ElevatedButton(onPressed: pickVideo, style: ElevatedButton.styleFrom(backgroundColor: amber), child: const Text('لوح فيديو - شحال ما بغيتي', style: TextStyle(color:black, fontSize:10)))), const SizedBox(width:8), Expanded(child: ElevatedButton(onPressed: addSched, style: ElevatedButton.styleFrom(backgroundColor: white), child: const Text('زيد جدول', style: TextStyle(color:black, fontSize:10))))]),
        const SizedBox(height:12),
        Text('${vids.length} فيديو - ${sched.length} جدول', style: const TextStyle(color:white70, fontSize:12)),
        ...vids.map((v){ return Container(margin: const EdgeInsets.only(bottom:6), padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(6)), child: Text(v.toString().split('/').last, style: const TextStyle(color:white, fontSize:11)) ); }).toList(),
        ...sched.map((s){ return Container(margin: const EdgeInsets.only(bottom:6), padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: black, border: Border.all(color:white24), borderRadius: BorderRadius.circular(6)), child: Text('${s['date']} - ${s['price']} - ${s['status']}', style: const TextStyle(color:white, fontSize:11)) ); }).toList(),
      ]));
  }
}
