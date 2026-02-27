import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/maintenance/presentation/pages/maintenance_page.dart';
import 'shared/widgets/typing_loader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const PortfolioApp(),
    ),
  );
}

class PortfolioApp extends ConsumerWidget {
  const PortfolioApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkInfo = ref.watch(themeProvider);

    return AnimatedTheme(
      data: isDarkInfo ? AppTheme.darkTheme : AppTheme.lightTheme,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: MaterialApp(
        title: 'Jay Portfolio',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: isDarkInfo ? ThemeMode.dark : ThemeMode.light,
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Start minimum built-in delay for the typing effect so it isn't abruptly cut off visually
    final delayFuture = Future.delayed(const Duration(milliseconds: 3000));
    bool isMaintenance = false;

    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      // Setup aggressive fetch limits for immediate response
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(minutes: 0),
      ));
      
      // Default to false before fetching
      await remoteConfig.setDefaults(const {"is_maintenance_mode": false});

      await remoteConfig.fetchAndActivate();
      isMaintenance = remoteConfig.getBool('is_maintenance_mode');
    } catch (e) {
      debugPrint("Remote config fetch failed: $e");
    }

    // Wait for the visual typing animation to wrap up
    await delayFuture;

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => 
              isMaintenance ? const MaintenancePage() : const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TypingLoader(fontSize: 32),
            const SizedBox(height: 20),
            Text(
              "System Initializing...",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                letterSpacing: 3,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
