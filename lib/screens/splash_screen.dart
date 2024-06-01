import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import 'package:wallify/global/global.dart';
import 'package:wallify/screens/home_screen.dart';
import 'package:wallify/screens/route_screen.dart';
import 'package:wallify/services/unsplash_service.dart';
import 'package:flutter/services.dart';
import 'dart:isolate';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await _fetchData();
    // await Future.delayed(const Duration(seconds: 4), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  Future<void> _fetchData() async {
    await _fetchRecommendedPhotos();
    await _fetchCategoryPhotos();
  }

  Future<void> _fetchCategoryPhotos() async {
    try {
      for (String category in categories) {
        final photos =
            await Provider.of<UnsplashService>(context, listen: false)
                .fetchCategoryPhotos(category, 1);
        category_photos.add(photos[0]);
      }
      print(category_photos);
    } catch (error) {
      print(error);
    }
  }

  Future<void> _fetchRecommendedPhotos() async {
    try {
      final photos = await Provider.of<UnsplashService>(context, listen: false)
          .fetchPhotos(5);

      recommended_photos = photos;
      print(recommended_photos);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              'Wallify',
              textStyle: const TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
              colors: [
                Colors.purple,
                Colors.blue,
                Colors.yellow,
                Colors.red,
              ],
            ),
          ],
          isRepeatingAnimation: true,
          totalRepeatCount: 30,
        ),
      ),
    );
  }
}
