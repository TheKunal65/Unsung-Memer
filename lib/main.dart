import 'package:flutter/material.dart';
import 'package:unsung_memer/view/mainScreen.dart';
import 'package:unsung_memer/view/splash_screen.dart';
import 'package:flutter/services.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool showSplash = true;
  showSplashScree() {
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        showSplash = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    showSplashScree();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Unsung Memer',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: showSplash ? splashScreen() : MainScreen());
  }
}
