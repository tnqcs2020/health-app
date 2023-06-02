import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:stronglier/common/global_variables.dart';
import 'package:stronglier/providers/form_provider.dart';
import 'package:stronglier/router.dart';
import 'package:stronglier/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(
        //   create: (context) => UserProvider(),
        // ),
        ChangeNotifierProvider(
          create: (context) => FormProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Stronglier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: GV.backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: GV.secondaryColor,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 5.0,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
      // onGenerateRoute: RouteGenerator.generateRoute,
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
