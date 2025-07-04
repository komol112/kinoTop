import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kino_top/core/app/style/app_theme.dart';
import 'package:kino_top/repasitories/services/firebase_options.dart';
import 'package:kino_top/view/screens/initial_screen.dart';
import 'package:kino_top/view_model/movie_provider.dart';
import 'package:provider/provider.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MovieProvider(),
      child: ScreenUtilInit(
        designSize: Size(600, 958),
        splitScreenMode: true,
        minTextAdapt: true,
        builder:
            (context, child) => MaterialApp(
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.system,
              debugShowCheckedModeBanner: false,
              home: InitialScreen(),
            ),
      ),
    );
  }
}
