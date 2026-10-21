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
        scaffoldBackgroundColor: Colors.black, // ستايل كحل بحال تيك توك
      ),
      home: const MainNavigationScreen(),
    );
  }
}

// 1. شاشة التحكم الرئيسية (التنقل بين الفيديوهات، التسجيل، والدخول السري)
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const TikTokVideoScreen(),      // صفحة الفيديوهات
    const RegisterScreen(),         // صفحة التسجيل للحرفية والزبائن
    const AdminLoginScreen(),       // صفحة الدخول السرية للأدمن
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
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'فيديوهات'),
          BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'تسجيل حساب'),
          BottomNavigationBarItem(icon: Icon(Icons.lock), label: 'الأدمن'), // خانة الأدمن
        ],
      ),
    );
  }
}

// 2. واجهة الفيديوهات (الزبون كيتفرج بحال تيك توك)
class TikTokVideoScreen extends StatelessWidget {
  const TikTokVideoScreen({super.key});

  void _openWhatsApp(BuildContext context, String providerName) async {
    var whatsappUrl = "https://wa.me";
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح الواتساب')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> sampleData = [
      {"name": "أوركسترا العسري", "role": "أوركسترا"},
      {"name": "نكافة بريستيج", "role": "نكافة"},
      {"name": "تموين ومطعم ومقاول الحفلات", "role": "تريتور"},
      {"name": "المصور المحترف رشيد", "role": "مصور"},
    ];

    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: sampleData.length,
      itemBuilder: (context, index) {
        final item = sampleData[index];
        return Stack(
          children: [
            Container(
              color: Colors.blueGrey[900],
              child: const Center(
                child: Icon(Icons.play_circle_fill, size: 80, color: Colors.white54),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item["name"]!, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(5)),
                    child: Text(item["role"]!, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 40,
              right: 20,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366), foregroundColor: Colors.white),
                onPressed: () => _openWhatsApp(context, item["name"]!),
                icon: const Icon(Icons.phone),
                label: const Text('حجز (0704246107)'),
              ),
            ),
          ],
        );
      },
    );
  }
}

// 3. صفحة التسجيل العادية للحرفية والزبناء
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _selectedRole = 'زبون';
  final List<String> _roles = ['زبون', 'مصور', 'أركيسترا', 'نݣافة', 'تريتور', 'دقايقي', 'صاحب قاعة حفلات'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب جديد'), backgroundColor: Colors.amber),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedRole,
              dropdownColor: Colors.grey[900],
              isExpanded: true,
              style: const TextStyle(color: Colors.white),
              items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (val) => setState(() => _selectedRole = val!),
            ),
            const SizedBox(height: 20),
            TextField(style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: 'الإسم', labelStyle: TextStyle(color: Colors.grey))),
            const SizedBox(height: 20),
            TextField(style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: 'الهاتف', labelStyle: TextStyle(color: Colors.grey))),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {},
              child: const Text('تسجيل الحساب', style: TextStyle(color: Colors.black)),
            )
          ],
        ),
      ),
    );
  }
}

// 4. صفحة تسجيل الدخول السرية الخاصة بالأدمن (أنتِ بوحدك)
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _loginAsAdmin() {
    // هاد الإيميل والكلمة السرية تقدري تبدليهم للي بغيتي دابا
    if (_emailController.text == "admin@hafalati.com" && _passwordController.text == "hafalati2026") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('خطأ سري! أنت لست الأدمن.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('بوابة الإدارة السرية'), backgroundColor: Colors.redAccent),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.security, size: 80, color: Colors.redAccent),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'البريد السري للأدمن', labelStyle: TextStyle(color: Colors.grey)),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'الكلمة السرية للأدمن', labelStyle: TextStyle(color: Colors.grey)),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                onPressed: _loginAsAdmin,
                child: const Text('دخول بصفتي صاحبة التطبيق', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 5. لوحة التحكم السرية للأدمن (التي تظهر بعد الدخول الناجح)
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة تحكم صاحبة التطبيق'), backgroundColor: Colors.redAccent),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _adminCard(Icons.people, "إدارة المستخدمين\n(0 حسابات)", Colors.blue),
            _adminCard(Icons.video_library, "مراجعة الفيديوهات\n(0 فيديوهات)", Colors.orange),
            _adminCard(Icons.analytics, "إحصائيات الحجز", Colors.green),
            _adminCard(Icons.settings, "إعدادات التطبيق ورقم الواتساب", Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _adminCard(IconData icon, String title, Color color) {
    return Card(
      color: Colors.black54,
      child: InkWell(
        onTap: () {},
        child: Column(
