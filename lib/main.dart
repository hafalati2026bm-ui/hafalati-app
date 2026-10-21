import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() { runApp(const HafalatiApp()); }

// البيانات العامة - فين كيتخزن القبول والرفض
List<Map<String, String>> pendingList = [];
List<Map<String, String>> acceptedProviders = [
  {"name": "أوركسترا العسري الفاسية", "role": "أركيسترا", "desc": "أجواء الأعراس المغربية الحية", "phone": "06xxxx"},
  {"name": "نكافة بريستيج السلاوية", "role": "نݣافة", "desc": "لبسات العمارية الفاسية", "phone": "06xxxx"},
  {"name": "تريتور الرحالي", "role": "تريتور", "desc": "أرقى أطباق المناسبات", "phone": "06xxxx"},
  {"name": "المصور أمين", "role": "مصور", "desc": "تصوير احترافي للعروسين", "phone": "06xxxx"},
  {"name": "الدقايقية المراكشية", "role": "دقايقي", "desc": "تنشيط العروسين", "phone": "06xxxx"},
  {"name": "قصر الأفراح", "role": "صاحب قاعة حفلات", "desc": "أفخم قاعة أعراس", "phone": "06xxxx"},
];

class HafalatiApp extends StatelessWidget {
  const HafalatiApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hafalati',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.black, primarySwatch: Colors.amber),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [const TikTokVideoScreen(), const RegisterScreen(), const AdminLoginScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white60,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.play_circle_fill), label: 'تيك توك الأعراس'),
          BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'تسجيل'),
          BottomNavigationBarItem(icon: Icon(Icons.security), label: 'أدمن'),
        ],
      ),
    );
  }
}

// 1 - تيك توك - كيبانو غير المقبولين
class TikTokVideoScreen extends StatefulWidget {
  const TikTokVideoScreen({super.key});
  @override
  State<TikTokVideoScreen> createState() => _TikTokVideoScreenState();
}

class _TikTokVideoScreenState extends State<TikTokVideoScreen> {
  void _openWhatsApp(String name, String role) async {
    final url = Uri.parse("https://wa.me/212704246107?text=سلام بغيت نحجز $role : $name");
    if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
  }
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: acceptedProviders.length,
      itemBuilder: (context, index) {
        final item = acceptedProviders[index];
        return Stack(
          children: [
            Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.black, Colors.blueGrey[900]!], begin: Alignment.topCenter, end: Alignment.bottomCenter)), child: const Center(child: Icon(Icons.play_arrow, size: 90, color: Colors.white24))),
            Positioned(bottom: 60, left: 15, right: 110, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [const Icon(Icons.verified, color: Colors.amber, size: 18), const SizedBox(width: 5), Expanded(child: Text(item["name"]!, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)))]),
              const SizedBox(height: 4),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(5)), child: Text(item["role"]!, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11))),
              const SizedBox(height: 6),
              Text(item["desc"]!, style: const TextStyle(color: Colors.white70, fontSize: 13)),
            ])),
            Positioned(bottom: 50, right: 15, child: Column(children: [
              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366), shape: const CircleBorder(), padding: const EdgeInsets.all(14)), onPressed: () => _openWhatsApp(item["name"]!, item["role"]!), child: const Icon(Icons.phone, color: Colors.white, size: 26)),
              const SizedBox(height: 5),
              const Text('حجز', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
            ])),
          ],
        );
      },
    );
  }
}

// 2 - التسجيل - 8 فئات
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _selectedRole = '1 تسجيل ك زبون';
  final List<String> _roles = ['1 تسجيل ك زبون','2 تسجل ك مصور','3 سجل ك اركيسترا','4 سجل ك نݣافة','5 سجل ك تريتور','6 سجل ك دقايقي','7 سجل كصاحب قاعة حفلات','سجل ك صاحب اتطبيق ادمين'];
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  void _register() {
    if (_nameCtrl.text.isEmpty || _phoneCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('عمر جميع الخانات')));
      return;
    }
    pendingList.add({"name": _nameCtrl.text, "role": _selectedRole, "phone": _phoneCtrl.text, "desc": "طلب جديد - في انتظار القبول"});
    _nameCtrl.clear();
    _phoneCtrl.clear();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم التسجيل - في انتظار قبول الأدمن ك: $_selectedRole'), backgroundColor: Colors.amber,));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل جديد'), backgroundColor: Colors.amber, centerTitle: true),
      backgroundColor: Colors.grey[950],
      body: Padding(padding: const EdgeInsets.all(18), child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('اختر صفتك:', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        Container(padding: const EdgeInsets.symmetric(horizontal: 10), decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.amber)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: _selectedRole, dropdownColor: Colors.grey[900], isExpanded: true, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(), onChanged: (v) => setState(() => _selectedRole = v!)))),
        const SizedBox(height: 20),
        TextField(controller: _nameCtrl, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: 'الإسم الكامل / اسم الفرقة', labelStyle: const TextStyle(color: Colors.grey), enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.amber), borderRadius: BorderRadius.circular(10)))),
        const SizedBox(height: 12),
        TextField(controller: _phoneCtrl, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: 'رقم الواتساب', labelStyle: const TextStyle(color: Colors.grey), enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.amber), borderRadius: BorderRadius.circular(10)))),
        const SizedBox(height: 25),
        SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber), onPressed: _register, child: const Text('إرسال طلب التسجيل للأدمن', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)))),
        const SizedBox(height: 10),
        Text('عدد الطلبات في الانتظار: ${pendingList.length}', style: const TextStyle(color: Colors.grey)),
      ]))),
    );
  }
}

// 3 - دخول الأدمن + القبول والرفض
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});
  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _codeCtrl = TextEditingController();
  bool _logged = false;

  void _login() {
    if (_codeCtrl.text == '0704246107' || _codeCtrl.text == 'admin123') {
      setState(() => _logged = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('كود خاطئ!')));
    }
  }

  void _accept(int index) {
    acceptedProviders.add(pendingList[index]);
    setState(() => pendingList.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم القبول - دابا كيبان فالتيك توك!'), backgroundColor: Colors.green));
  }

  void _reject(int index) {
    setState(() => pendingList.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الرفض'), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    if (!_logged) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: const Text('دخول الأدمن السري'), backgroundColor: Colors.red[900], centerTitle: true),
        body: Padding(padding: const EdgeInsets.all(25), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.security, size: 70, color: Colors.amber),
          const SizedBox(height: 15),
          const Text('كود الأدمن: 0704246107', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 20),
          TextField(controller: _codeCtrl, obscureText: true, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: 'كود الأدمن', enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.amber), borderRadius: BorderRadius.circular(10)))),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber), onPressed: _login, child: const Text('دخول لواجهة القبول والرفض', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))),
        ])),
      );
    }

    // واجهة القبول والرفض بعد الدخول
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('طلبات الانتظار (${pendingList.length})'), backgroundColor: Colors.amber, foregroundColor: Colors.black, actions: [IconButton(onPressed: () => setState(() => _logged = false), icon: const Icon(Icons.logout))]),
      body: pendingList.isEmpty
          ? const Center(child: Text('لا يوجد طلبات جديدة', style: TextStyle(color: Colors.white70, fontSize: 18)))
          : ListView.builder(
              itemCount: pendingList.length,
              itemBuilder: (context, i) {
                final p = pendingList[i];
                return Card(color: Colors.grey[900], margin: const EdgeInsets.all(10), child: ListTile(
                  title: Text(p["name"]!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text('${p["role"]!}\n${p["phone"]!}', style: const TextStyle(color: Colors.white70)),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(icon: const Icon(Icons.check_circle, color: Colors.green, size: 35), onPressed: () => _accept(i)),
                    IconButton(icon: const Icon(Icons.cancel, color: Colors.red, size: 35), onPressed: () => _reject(i)),
                  ]),
                ));
              },
            ),
    );
  }
}
