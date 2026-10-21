import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const HafalatiApp());
}

class HafalatiApp extends StatelessWidget {
  const HafalatiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hafalati',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Colors.black, // ستايل مظلم بحال تيك توك
      ),
      home: const MainNavigationScreen(),
    );
  }
}

// 1. شاشة التحكم الرئيسية والتنقل فالتطبيق
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const TikTokVideoScreen(),      // 1. واجهة الزبون (تيك توك)
    const RegisterScreen(),         // 2. واجهة التسجيل لجميع الحرفيين والزبائن
    const AdminLoginScreen(),       // 3. واجهة الأدمن السرية
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white60,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.play_circle_fill), label: 'تيك توك الأعراس'),
          BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'تسجيل الحسابات'),
          BottomNavigationBarItem(icon: Icon(Icons.security), label: 'دخول الأدمن السري'),
        ],
      ),
    );
  }
}

// 2. واجهة الزبون (بحال تيك توك كيتفرج ويطلع للفوق ولتحت)
class TikTokVideoScreen extends StatelessWidget {
  const TikTokVideoScreen({super.key});

  // دالة فتح الواتساب ديريكت للأدمن مع إرسال اسم الحرفي المحجوز
  void _openWhatsApp(BuildContext context, String providerName, String role) async {
    var whatsappUrl = "https://wa.me";
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح الواتساب، تأكد من تثبيته')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // هاهما الحرفيين والفرق لي طلبتي كاملين كيبانو فالتيك توك دابا
    final List<Map<String, String>> sampleVideos = [
      {"name": "أوركسترا العسري الفاسية", "role": "أركيسترا", "desc": "شاهد أقوى أجواء الأعراس المغربية الحية"},
      {"name": "نكافة بريستيج السلاوية", "role": "نݣافة", "desc": "أحدث لبسات العمارية والبرزة المغربية الفاسية"},
      {"name": "تموين ومطعم ومقاول الحفلات الرحالي", "role": "تريتور", "desc": "أرقى أطباق المناسبات والبوفيهات الفاخرة"},
      {"name": "المصور المحترف أمين", "role": "مصور", "desc": "جلسات تصوير احترافية للعروسين بجودة عالية"},
      {"name": "فرقة الدقايقية المراكشية الأصيلة", "role": "دقايقي", "desc": "تنشيط واستقبال العروسين على الطريقة المراكشية"},
      {"name": "قاعة حفلات قصر الأفراح", "role": "صاحب قاعة حفلات", "desc": "جولة داخل أفخم قاعة لتنظيم الأعراس والمناسبات"},
    ];

    return PageView.builder(
      scrollDirection: Axis.vertical, // التمرير عمودي تيك توك 100%
      itemCount: sampleVideos.length,
      itemBuilder: (context, index) {
        final item = sampleVideos[index];
        return Stack(
          children: [
            // خلفية الفيديو (هنا كيدور الفيديو، حالياً درت ألوان متدرجة باش تحركي بصبغك ويبان ليك التغيير)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.blueGrey[900]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Center(
                child: Icon(Icons.play_arrow, size: 90, color: Colors.white38),
              ),
            ),
            
            // معلومات الحرفي والفرقة (تحت على اليسار)
            Positioned(
              bottom: 50,
              left: 20,
              right: 120, // نخليو اتساع لزِر الواتساب
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.verified, color: Colors.amber, size: 20),
                      const SizedBox(width: 5),
                      Text(item["name"]!, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(5)),
                    child: Text(item["role"]!, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  const SizedBox(height: 8),
                  Text(item["desc"]!, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            
            // زر الحجز بالواتساب ديريكت للأدمن (0704246107) تحت على اليمين فوق الفيديو
            Positioned(
              bottom: 50,
              right: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366), // خضر د الواتساب
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(15),
                ),
                onPressed: () => _openWhatsApp(context, item["name"]!, item["role"]!),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.phone, color: Colors.white, size: 28),
                    SizedBox(height: 2),
                    Text('حجز', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// 3. واجهة التسجيل لجميع الفئات الـ 8 لي قلتي ليا
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _selectedRole = '1 تسجيل ك زبون';

  // هاهي اللائحة كاملة ومكتوبة بحال كيف صيفطيها ليا بالظبط!
  final List<String> _roles = [
    '1 تسجيل ك زبون',
    '2 تسجل ك مصور',
    '3 سجل ك اركيسترا',
    '4 سجل ك نݣافة',
    '5 سجل ك تريتور',
    '6 سجل ك دقايقي',
    '7 سجل كصاحب قاعة حفلات',
    'سجل ك صاحب اتطبيق ادمين'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل مستخدم جديد', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.amber, centerTitle: true),
      backgroundColor: Colors.grey[950],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('اختر صفتك فالتطبيق أولاً:', style: TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 10),
              
              // اختيار المهنة من اللائحة الـ 8
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.amber)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedRole,
                    dropdownColor: Colors.grey[900],
                    isExpanded: true,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.amber),
                    items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedRole = val!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 25),
              
              // الخانات ديال الاسم والهاتف
              TextField(style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: 'الإسم الكامل أو اسم الفرقة', labelStyle: const TextStyle(color: Colors.grey), enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.amber), borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 15),
              TextField(style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: 'رقم الهاتف والواتساب', labelStyle: const TextStyle(color: Colors.grey), enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.amber), borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 30),
              
              // الزر ديال التسجيل
              SizedBox(
                width: double.infinity,
                height: 50,
