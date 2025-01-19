import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:piwot2/pages/categories/RiceDisease.dart';
import 'package:piwot2/pages/home/home.dart';
import 'package:piwot2/pages/home/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'pages/categories/fertlizerPredictor.dart';
import 'pages/categories/menu.dart';
import 'pages/home/chatbot.dart';
import 'pages/home/marketplace.dart';
import 'pages/startup/login.dart';
import 'pages/startup/register.dart';
import 'pages/startup/registerDetails.dart';
import 'services/dataSyncService.dart';
import 'theme/dark.dart';
import 'theme/light.dart';
import 'theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDark = prefs.getBool('isDark') ?? false;
  await Hive.initFlutter();
  await Hive.openBox('appBox');
  var box = Hive.box('appBox');
  bool isNew = box.get('UserData') == null;
  DataSyncService dataSyncService = DataSyncService();
  await dataSyncService.syncData();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ThemeProvider(isDark ? darkmode : lightmode)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('appBox');
    bool isNew = box.get('userData') == null;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      initialRoute: isNew ? '/login' : '/',
      routes: {
        '/login': (context) => const Login(),
        '/register': (context) => const Register(),
        '/registerDetails': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return Registerdetails(
            email: args['email']!,
            password: args['password']!,
            phone: args['phone']!,
            name: args['name']!,
          );
        },
        '/marketplace': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return Marketplace(name: args['name']!);
        },
        '/': (context) => const Home(),
        '/profile': (context) => const Profile(),
        '/fertilizer': (context) => Fertilizer(),
        '/chatbot': (context) => Chatbot(),
        '/menu': (context) => Menu(),
        '/Disease': (context) => Disease(),
      },
    );
  }
}
