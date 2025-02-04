import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ticketless_parking_display/configs/app_theme.dart';
import 'package:ticketless_parking_display/data/local.dart';
import 'package:ticketless_parking_display/providers/screen_provider.dart';
import 'package:ticketless_parking_display/screens/home_screen.dart';
import 'package:ticketless_parking_display/providers/config_provider.dart';
import 'package:ticketless_parking_display/screens/config_screen.dart';
import 'package:ticketless_parking_display/screens/login_screen.dart';
import 'package:ticketless_parking_display/data/api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.initialize();
  await APIServices.initialize();
  await dotenv.load();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScreenProvider()),
        ChangeNotifierProvider(
          create: (_) => ConfigProvider(),
          lazy: false,
        ),
      ],
      child: Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<ConfigProvider>(context, listen: false)
                .initializeAuth();
          });

          return MaterialApp(
            theme: AppTheme.getLightTheme(context),
            darkTheme: AppTheme.getDarkTheme(context),
            themeMode: AppTheme.themeMode,
            debugShowCheckedModeBanner: false,
            initialRoute: "/home",
            routes: {
              "/home": (context) => HomeScreen(),
              "/config": (context) => ConfigScreen(),
              "/login": (context) => LoginScreen(),
            },
          );
        },
      ),
    );
  }
}
