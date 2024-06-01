// ignore_for_file: non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:wallify/global/global.dart';
import 'package:wallify/screens/favorites_screen.dart';
import 'package:wallify/utils/hex_color.dart';
import '../services/unsplash_service.dart';
import '../models/photo.dart';
import 'photo_detail_screen.dart';
import 'categories_screen.dart';
import '../widgets/custom_nav_bar.dart';
import '../widgets/custom_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final int _currentNavBarIndex = 1;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPhotos();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  Future<void> _fetchPhotos() async {
    try {
      _isLoading = true;
      final photos = await Provider.of<UnsplashService>(context, listen: false)
          .fetchPhotos(5);
      setState(() {
        recommended_photos = photos;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onNavBarTap(int index) {
    // _currentNavBarIndex = index;
    if (index == 1) {
      _fetchPhotos();
    } else if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategoriesScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FavoriteScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     statusBarIconBrightness: Brightness.dark,
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wallify',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CupertinoActivityIndicator(
              animating: true,
              radius: 20,
            ))
          : Column(
              children: [
                CarouselSlider.builder(
                  itemCount: recommended_photos.length,
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.7,
                    viewportFraction: 0.8,
                    enlargeCenterPage: true,
                    onPageChanged: (index, _) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    final photo = recommended_photos[index];
                    Color color = HexColor.fromHex(photo.color);
                    return Hero(
                      tag: 'photo_${photo.id}',
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PhotoDetailScreen(photo: photo),
                                ),
                              );
                            },
                            child: CachedNetworkImage(
                              imageUrl: photo.url.regular,
                              fit: BoxFit.cover,
                              // placeholder: (context, url) => Image.network(
                              //   photo.url.raw,
                              //   fit: BoxFit.cover,
                              // ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                CustomPageIndicator(
                  itemCount: recommended_photos.length,
                  currentIndex: _currentIndex,
                ),
                const SizedBox(height: 30),
              ],
            ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomNavBar(
            currentIndex: _currentNavBarIndex,
            onTap: _onNavBarTap,
          ),
        ],
      ),
    );
  }
}
