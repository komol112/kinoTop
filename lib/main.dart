import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kino_top/firebase_options.dart';
import 'package:kino_top/screens/initial_screen.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(600, 958),
      splitScreenMode: true,
      minTextAdapt: true,
      builder:
          (context, child) => MaterialApp(
            theme: ThemeData(fontFamily: "Roboto"),
            debugShowCheckedModeBanner: false,
            home: InitialScreen(),
          ),
    );
  }
}
