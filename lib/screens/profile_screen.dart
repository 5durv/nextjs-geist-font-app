import 'package:flutter/material.dart';
import '../services/service_locator.dart';
import '../config/theme.dart';
import '../utils/app_utils.dart';
import 'settings_screen.dart';
import 'favorites_screen.dart';
import 'help_screen.dart';
import 'history_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final userData = serviceLocator.storageService.getUserData() ?? {};
    _nameController = TextEditingController(text: userData['name'] ?? '');
    _emailController = TextEditingController(text: userData['email'] ?? '');
    _phoneController = TextEditingController(text: userData['phone'] ?? '');
  }

  Future<void> _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      try {
        serviceLocator.showLoading();
        
        final userData = {
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
        };

        await serviceLocator.storageService.setUserData(userData);
        
        serviceLocator.hideLoading();
        if (mounted) {
          setState(() => _isEditing = false);
          serviceLocator.showSnackBar('تم حفظ البيانات بنجاح');
        }
      } catch (e) {
        serviceLocator.hideLoading();
        if (mounted) {
          serviceLocator.showError('حدث خطأ أثناء حفظ البيانات');
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveUserData,
            )
          else
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            const Divider(),
            _buildProfileForm(),
            const Divider(),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, size: 50),
              ),
              if (_isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _nameController.text.isEmpty ? 'زائر' : _nameController.text,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (_emailController.text.isNotEmpty)
            Text(
              _emailController.text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
        ],
      ),
    );
  }

  Widget _buildProfileForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'المعلومات الشخصية',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              enabled: _isEditing,
              decoration: const InputDecoration(
                labelText: 'الاسم',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال الاسم';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              enabled: _isEditing,
              decoration: const InputDecoration(
                labelText: 'البريد الإلكتروني',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال البريد الإلكتروني';
                }
                if (!value.isValidEmail) {
                  return 'الرجاء إدخال بريد إلكتروني صحيح';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              enabled: _isEditing,
              decoration: const InputDecoration(
                labelText: 'رقم الهاتف',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال رقم الهاتف';
                }
                if (!value.isValidPhone) {
                  return 'الرجاء إدخال رقم هاتف صحيح';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.favorite_border),
          title: const Text('المفضلة'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesScreen()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('السجل'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: const Text('الإعدادات'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('المساعدة'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HelpScreen()),
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text(
            'تسجيل الخروج',
            style: TextStyle(color: Colors.red),
          ),
          onTap: _showLogoutConfirmation,
        ),
      ],
    );
  }

  Future<void> _showLogoutConfirmation() async {
    final confirmed = await serviceLocator.showConfirmation(
      'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
    );

    if (confirmed && mounted) {
      // Clear user data
      await serviceLocator.storageService.remove('user_data');
      // Navigate to login screen or home screen
      Navigator.of(context).pop();
    }
  }
}
