import 'package:flutter/material.dart';
import 'api_service.dart';
import 'navigation_service.dart';
import 'storage_service.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Services
  late final ApiService apiService;
  late final NavigationService navigationService;
  late final StorageService storageService;

  // Global key for navigator
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Initialize all services
  Future<void> init() async {
    // Initialize services
    apiService = ApiService();
    navigationService = NavigationService();
    storageService = StorageService();

    // Initialize storage service
    await storageService.init();
  }

  // Get BuildContext from navigator key
  BuildContext? get currentContext => navigatorKey.currentContext;

  // Show loading dialog
  void showLoading() {
    if (currentContext != null) {
      showDialog(
        context: currentContext!,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  // Hide loading dialog
  void hideLoading() {
    if (currentContext != null && Navigator.canPop(currentContext!)) {
      Navigator.pop(currentContext!);
    }
  }

  // Show error dialog
  Future<void> showError(String message) async {
    if (currentContext != null) {
      return showDialog(
        context: currentContext!,
        builder: (context) => AlertDialog(
          title: const Text('خطأ'),
          content: Text(message),
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

  // Show success dialog
  Future<void> showSuccess(String message) async {
    if (currentContext != null) {
      return showDialog(
        context: currentContext!,
        builder: (context) => AlertDialog(
          title: const Text('نجاح'),
          content: Text(message),
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

  // Show confirmation dialog
  Future<bool> showConfirmation(String message) async {
    if (currentContext != null) {
      final result = await showDialog<bool>(
        context: currentContext!,
        builder: (context) => AlertDialog(
          title: const Text('تأكيد'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('تأكيد'),
            ),
          ],
        ),
      );
      return result ?? false;
    }
    return false;
  }

  // Show snackbar
  void showSnackBar(String message, {bool isError = false}) {
    if (currentContext != null) {
      ScaffoldMessenger.of(currentContext!).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(8),
        ),
      );
    }
  }
}

// Global instance for easy access
final serviceLocator = ServiceLocator();
