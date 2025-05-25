import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'config/theme.dart';
import 'providers/app_state.dart';
import 'services/service_locator.dart';
import 'widgets/bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await serviceLocator.init();
  
  // Force portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Kurdistan Tourism',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        navigatorKey: serviceLocator.navigatorKey,
        home: const SplashScreen(),
        onGenerateRoute: (settings) {
          if (settings.name == '/main') {
            return MaterialPageRoute(builder: (_) => const MainScreen());
          }
          return null;
        },
        builder: (context, child) {
          // Apply RTL directionality to the entire app
          return Directionality(
            textDirection: TextDirection.rtl,
            child: MediaQuery(
              // Set text scaling factor to 1.0 to prevent text scaling
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!,
            ),
          );
        },
        // Error handling for the entire app
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(
                child: Text(
                  'الصفحة غير موجودة',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
