import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:one_iota_mobile_app/screens/rounds_feature/add_round_page.dart';
import 'api/auth.dart';
import './screens/sign_in.dart';
import 'utils/navigation_page.dart';
import 'screens/habit_feature/add_habit.dart';
import 'screens/home_page.dart';
import 'screens/rounds_feature/round_complete.dart';
import 'screens/rounds_feature/rounds_main.dart';
import 'screens/rounds_feature/summary_page.dart';

Future<void> main() async {
  // When firebase is created uncomment these lines
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // SystemChrome.setSystemUIOverlayStyle(
  //     const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MaterialColor primaryColor = const MaterialColor(
      0xFFFFFFFF,
      <int, Color>{
        50: Colors.white,
        100: Colors.white,
        200: Colors.white,
        300: Colors.white,
        400: Colors.white,
        500: Colors.white,
        600: Colors.white,
        700: Colors.white,
        800: Colors.white,
        900: Colors.white,
      },
    );
    return MaterialApp(
      title: 'Iota Performance App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: primaryColor,
        fontFamily: 'Inter',
      ),
      // home: const SignIn(),

      /// Uncomment this line and replace the home when firebase is intialized
      home: StreamBuilder<User?>(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return NavigationPage();
          } else {
            return const SignIn();
          }
        },
      ),

      routes: {
        '/screens': (context) => NavigationPage(),
        '/rounds_main': (context) => const RoundsMain(),
        '/add_round': (context) => const AddRound(),
        '/home': (context) => const HomePage(),
        '/add_habit': (context) => const AddHabit(),
        '/round_complete': (context) => const RoundComplete(),
        '/summary_page': (context) => const SummaryPage(isBasicRound: true),
      },
    );
  }
}
