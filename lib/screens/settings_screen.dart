import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../services/service_locator.dart';
import '../config/theme.dart';
import '../utils/app_utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'ar';
  bool _locationEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final storage = serviceLocator.storageService;
    setState(() {
      _isDarkMode = storage.getDarkMode();
      _notificationsEnabled = storage.getBool('notifications_enabled') ?? true;
      _selectedLanguage = storage.getString('language') ?? 'ar';
      _locationEnabled = storage.getBool('location_enabled') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final storage = serviceLocator.storageService;
    await storage.setDarkMode(_isDarkMode);
    await storage.setBool('notifications_enabled', _notificationsEnabled);
    await storage.setString('language', _selectedLanguage);
    await storage.setBool('location_enabled', _locationEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('المظهر'),
          SwitchListTile(
            title: const Text('الوضع الليلي'),
            subtitle: const Text('تفعيل المظهر الداكن للتطبيق'),
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
              _saveSettings();
            },
          ),
          const Divider(),
          _buildSectionHeader('اللغة'),
          RadioListTile<String>(
            title: const Text('العربية'),
            value: 'ar',
            groupValue: _selectedLanguage,
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value!;
              });
              _saveSettings();
            },
          ),
          RadioListTile<String>(
            title: const Text('الكردية'),
            value: 'ku',
            groupValue: _selectedLanguage,
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value!;
              });
              _saveSettings();
            },
          ),
          RadioListTile<String>(
            title: const Text('English'),
            value: 'en',
            groupValue: _selectedLanguage,
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value!;
              });
              _saveSettings();
            },
          ),
          const Divider(),
          _buildSectionHeader('الإشعارات'),
          SwitchListTile(
            title: const Text('تفعيل الإشعارات'),
            subtitle: const Text('استلام إشعارات حول العروض والفعاليات'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
              _saveSettings();
            },
          ),
          const Divider(),
          _buildSectionHeader('الموقع'),
          SwitchListTile(
            title: const Text('خدمات الموقع'),
            subtitle: const Text('السماح بالوصول إلى موقعك لتحسين التجربة'),
            value: _locationEnabled,
            onChanged: (value) {
              setState(() {
                _locationEnabled = value;
              });
              _saveSettings();
            },
          ),
          const Divider(),
          _buildSectionHeader('التطبيق'),
          ListTile(
            title: const Text('مسح ذاكرة التخزين المؤقت'),
            subtitle: const Text('مسح البيانات المؤقتة للتطبيق'),
            trailing: const Icon(Icons.cleaning_services),
            onTap: _clearCache,
          ),
          ListTile(
            title: const Text('عن التطبيق'),
            trailing: const Icon(Icons.info_outline),
            onTap: _showAboutDialog,
          ),
          ListTile(
            title: const Text('سياسة الخصوصية'),
            trailing: const Icon(Icons.privacy_tip_outlined),
            onTap: () => _openPrivacyPolicy(),
          ),
          ListTile(
            title: const Text('شروط الاستخدام'),
            trailing: const Icon(Icons.description_outlined),
            onTap: () => _openTermsOfService(),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'إصدار التطبيق: ${AppConstants.appVersion}',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Future<void> _clearCache() async {
    final confirmed = await serviceLocator.showConfirmation(
      'هل أنت متأكد من رغبتك في مسح ذاكرة التخزين المؤقت؟',
    );

    if (confirmed) {
      // Show loading
      serviceLocator.showLoading();

      // Clear cache
      await serviceLocator.storageService.clearAll();

      // Hide loading
      serviceLocator.hideLoading();

      // Show success message
      if (mounted) {
        serviceLocator.showSnackBar('تم مسح ذاكرة التخزين المؤقت بنجاح');
      }
    }
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AboutDialog(
        applicationName: AppConstants.appName,
        applicationVersion: AppConstants.appVersion,
        applicationIcon: const Icon(
          Icons.landscape,
          size: 50,
          color: Colors.blue,
        ),
        children: const [
          Text(
            'تطبيق سياحي يساعدك في اكتشاف جمال إقليم كردستان العراق ومعالمه السياحية.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _openPrivacyPolicy() async {
    const url = 'https://example.com/privacy-policy';
    try {
      await AppUtils.launchURL(url);
    } catch (e) {
      if (mounted) {
        serviceLocator.showError('لا يمكن فتح سياسة الخصوصية');
      }
    }
  }

  Future<void> _openTermsOfService() async {
    const url = 'https://example.com/terms-of-service';
    try {
      await AppUtils.launchURL(url);
    } catch (e) {
      if (mounted) {
        serviceLocator.showError('لا يمكن فتح شروط الاستخدام');
      }
    }
  }
}
