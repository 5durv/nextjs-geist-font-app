import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../services/service_locator.dart';

class ErrorScreen extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final bool showHomeButton;

  const ErrorScreen({
    super.key,
    this.title = 'حدث خطأ',
    required this.message,
    this.buttonText,
    this.onButtonPressed,
    this.showHomeButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (onButtonPressed != null) ...[
                ElevatedButton(
                  onPressed: onButtonPressed,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: Text(buttonText ?? 'إعادة المحاولة'),
                ),
                const SizedBox(height: 16),
              ],
              if (showHomeButton)
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('العودة إلى الرئيسية'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class NetworkErrorScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const NetworkErrorScreen({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorScreen(
      title: 'خطأ في الاتصال',
      message: 'يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى',
      buttonText: 'إعادة المحاولة',
      onButtonPressed: onRetry,
    );
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ErrorScreen(
      title: 'الصفحة غير موجودة',
      message: 'عذراً، الصفحة التي تبحث عنها غير موجودة',
      showHomeButton: true,
    );
  }
}

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ErrorScreen(
      title: 'الصيانة',
      message: 'التطبيق قيد الصيانة حالياً. يرجى المحاولة لاحقاً',
      buttonText: 'تحديث',
      onButtonPressed: () {
        // Implement check if maintenance is over
        serviceLocator.showSnackBar('جاري التحقق من حالة الصيانة...');
      },
    );
  }
}

class NoDataScreen extends StatelessWidget {
  final String message;
  final VoidCallback? onRefresh;

  const NoDataScreen({
    super.key,
    required this.message,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorScreen(
      title: 'لا توجد بيانات',
      message: message,
      buttonText: onRefresh != null ? 'تحديث' : null,
      onButtonPressed: onRefresh,
      showHomeButton: false,
    );
  }
}

class UnauthorizedScreen extends StatelessWidget {
  final VoidCallback onLogin;

  const UnauthorizedScreen({
    super.key,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorScreen(
      title: 'غير مصرح',
      message: 'يرجى تسجيل الدخول للوصول إلى هذه الصفحة',
      buttonText: 'تسجيل الدخول',
      onButtonPressed: onLogin,
      showHomeButton: true,
    );
  }
}

class ServerErrorScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const ServerErrorScreen({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorScreen(
      title: 'خطأ في الخادم',
      message: 'حدث خطأ في الخادم. يرجى المحاولة مرة أخرى لاحقاً',
      buttonText: 'إعادة المحاولة',
      onButtonPressed: onRetry,
    );
  }
}
