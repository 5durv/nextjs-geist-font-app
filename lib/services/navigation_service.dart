import 'package:flutter/material.dart';
import '../models/city.dart';
import '../screens/city_details_screen.dart';
import '../screens/home_screen.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  
  factory NavigationService() => _instance;
  
  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateToPage(Widget page) {
    return navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Future<dynamic> navigateToReplacementPage(Widget page) {
    return navigatorKey.currentState!.pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Future<dynamic> navigateToNamedPage(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  void goBack() {
    return navigatorKey.currentState!.pop();
  }

  Future<dynamic> navigateToHome() {
    return navigateToReplacementPage(const HomeScreen());
  }

  Future<dynamic> navigateToCityDetails(City city) {
    return navigateToPage(CityDetailsScreen(city: city));
  }

  // Show a modal bottom sheet
  Future<T?> showAppModalBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: backgroundColor ?? Theme.of(context).cardColor,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: child,
      ),
    );
  }

  // Show a dialog
  Future<T?> showAppDialog<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: child,
      ),
    );
  }

  // Show a snackbar
  void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(8),
      ),
    );
  }

  // Show loading dialog
  Future<void> showLoadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  // Hide loading dialog
  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
