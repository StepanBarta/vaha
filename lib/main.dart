/*
hodiny:
uvod, priprava - 6h
nacitani seznamu polozek - 24.4. - 19:30 - 23:20
ovladani detailu objednavky - 30.4 - 20:15 - 23:00
ovladani detailu objednavky - 1.5 - 19:00 - 23:00
propisovani vahy do objednavky 2.5 - 21:15 - 23:59



 */

import 'package:flutter/material.dart';
import 'package:gaubeVaha/build/verify.build.dart';
import 'package:gaubeVaha/store/global_keys.dart';
import 'package:gaubeVaha/store/store_global.dart';
import 'package:gaubeVaha/views/home_page.dart';
import 'package:gaubeVaha/views/login_page.dart';
import 'package:flutter/services.dart';


void main() {
  // disable device lanscape mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Global.appName,
      scaffoldMessengerKey: snackbarKey,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Screen(),
    );
  }
}

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  @override
  void initState() {
    super.initState();
  }

  Widget _loadingScreen() => Center(
        child: Container(
          width: 100,
          height: 100,
          padding: const EdgeInsets.all(2.0),
          child: const CircularProgressIndicator(
            color: Colors.blue,
            strokeWidth: 3,
          ),
        ),
      );

  Widget _buildScreen() => FutureBuilder(
        future: VerifyUserBuild().verifyUser(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            print("jojo");
            return _loadingScreen();
          } else if (snapshot.data == true) {
            print("dede");
            return const HomePage();
          } else {
            print("lala");
//            return const LoginPage();
            return const HomePage();
          }
        },
      );

  @override
  Widget build(BuildContext context) => Scaffold(body: _buildScreen());
}
