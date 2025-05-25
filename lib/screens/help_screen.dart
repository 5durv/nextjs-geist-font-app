import 'package:flutter/material.dart';
import '../utils/app_utils.dart';
import '../config/constants.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المساعدة والدعم'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            title: 'الأسئلة الشائعة',
            children: _buildFAQs(),
          ),
          const Divider(height: 32),
          _buildSection(
            title: 'تواصل معنا',
            children: _buildContactInfo(context),
          ),
          const Divider(height: 32),
          _buildSection(
            title: 'معلومات التطبيق',
            children: _buildAppInfo(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  List<Widget> _buildFAQs() {
    return [
      _buildExpandableFAQ(
        question: 'كيف يمكنني حجز فندق؟',
        answer: 'يمكنك حجز فندق من خلال تصفح المدن واختيار الفندق المناسب، ثم اتباع خطوات الحجز البسيطة.',
      ),
      _buildExpandableFAQ(
        question: 'كيف يمكنني إضافة مكان إلى المفضلة؟',
        answer: 'يمكنك إضافة أي مكان إلى المفضلة بالضغط على أيقونة القلب الموجودة بجانب المكان.',
      ),
      _buildExpandableFAQ(
        question: 'هل يمكنني تغيير لغة التطبيق؟',
        answer: 'نعم، يمكنك تغيير لغة التطبيق من خلال الإعدادات واختيار اللغة المفضلة لديك.',
      ),
      _buildExpandableFAQ(
        question: 'كيف يمكنني تعديل معلومات حسابي؟',
        answer: 'يمكنك تعديل معلومات حسابك من خلال الذهاب إلى صفحة الملف الشخصي والضغط على زر التعديل.',
      ),
    ];
  }

  Widget _buildExpandableFAQ({
    required String question,
    required String answer,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(answer),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildContactInfo(BuildContext context) {
    return [
      ListTile(
        leading: const Icon(Icons.email_outlined),
        title: const Text('البريد الإلكتروني'),
        subtitle: const Text('support@kurdistantourism.com'),
        onTap: () => AppUtils.sendEmail('support@kurdistantourism.com'),
      ),
      ListTile(
        leading: const Icon(Icons.phone_outlined),
        title: const Text('رقم الهاتف'),
        subtitle: const Text('+964 750 123 4567'),
        onTap: () => AppUtils.makePhoneCall('+964750123456'),
      ),
      ListTile(
        leading: const Icon(Icons.web_outlined),
        title: const Text('الموقع الإلكتروني'),
        subtitle: const Text('www.kurdistantourism.com'),
        onTap: () => AppUtils.launchURL('https://www.kurdistantourism.com'),
      ),
      ListTile(
        leading: const Icon(Icons.location_on_outlined),
        title: const Text('العنوان'),
        subtitle: const Text('أربيل، إقليم كردستان، العراق'),
      ),
    ];
  }

  List<Widget> _buildAppInfo(BuildContext context) {
    return [
      ListTile(
        leading: const Icon(Icons.info_outline),
        title: const Text('إصدار التطبيق'),
        subtitle: Text(AppConstants.appVersion),
      ),
      ListTile(
        leading: const Icon(Icons.security_outlined),
        title: const Text('سياسة الخصوصية'),
        onTap: () => AppUtils.launchURL('https://www.kurdistantourism.com/privacy'),
      ),
      ListTile(
        leading: const Icon(Icons.description_outlined),
        title: const Text('شروط الاستخدام'),
        onTap: () => AppUtils.launchURL('https://www.kurdistantourism.com/terms'),
      ),
      ListTile(
        leading: const Icon(Icons.update_outlined),
        title: const Text('التحقق من التحديثات'),
        onTap: () => _checkForUpdates(context),
      ),
    ];
  }

  Future<void> _checkForUpdates(BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Simulate checking for updates
    await Future.delayed(const Duration(seconds: 2));

    // Hide loading indicator
    Navigator.pop(context);

    // Show result
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('التحديثات'),
          content: const Text('أنت تستخدم أحدث إصدار من التطبيق.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('حسناً'),
            ),
          ],
        ),
      );
    }
  }
}
