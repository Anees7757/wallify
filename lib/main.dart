import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/unsplash_service.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<UnsplashService>(create: (_) => UnsplashService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Wallify',
        theme: ThemeData(
          useMaterial3: false,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
