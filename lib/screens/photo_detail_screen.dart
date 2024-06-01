import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:light_toast/light_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/photo.dart';
import 'package:wallpaper_handler/wallpaper_handler.dart';

class PhotoDetailScreen extends StatefulWidget {
  final Photo photo;

  const PhotoDetailScreen({Key? key, required this.photo}) : super(key: key);

  @override
  State<PhotoDetailScreen> createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends State<PhotoDetailScreen> {
  late SharedPreferences _prefs;
  Set<String> favoritePhotos = {};
  bool _isUiVisible = true;
  bool _isSettingWallpaper = false;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    _systemNavBarChange();
    _updateSystemUi();
  }

  _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    // setState(() {
    favoritePhotos = (_prefs.getStringList('favoritePhotos') ?? []).toSet();
    // });
  }

  _saveFavoritePhotos() {
    _prefs.setStringList('favoritePhotos', favoritePhotos.toList());
  }

  setWallpaper(int id) async {
    setState(() {
      _isSettingWallpaper = true;
    });

    final Size screenSize = MediaQuery.of(context).size;

    var file =
        await DefaultCacheManager().getSingleFile(widget.photo.url.regular);
    final double centerX = widget.photo.width / 2;
    final double centerY = widget.photo.height / 2;
    bool result = await WallpaperHandler.instance.setWallpaperFromFile(
      file.path,
      _getWallpaperLocation(id),
      cropBounds: Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: screenSize.width,
        height: screenSize.height,
      ),
    );

    setState(() {
      _isSettingWallpaper = false;
    });

    print(result);
    if (!mounted) return;
    Toast.show(context: context, 'Wallpaper Changed');
  }

  _getWallpaperLocation(int id) {
    switch (id) {
      case 0:
        return WallpaperLocation.homeScreen;
      case 1:
        return WallpaperLocation.lockScreen;
      case 2:
        return WallpaperLocation.bothScreens;
      default:
        throw ArgumentError('Invalid Wallpaper Location ID');
    }
  }

  toggleFavorite() {
    setState(() {
      if (favoritePhotos.contains(widget.photo.id)) {
        favoritePhotos.remove(widget.photo.id);
      } else {
        favoritePhotos.add(widget.photo.id);
      }
    });
    _saveFavoritePhotos();
    if (favoritePhotos.contains(widget.photo.id)) {
      Toast.show(context: context, 'Added to favorites');
    } else {
      Toast.show(context: context, 'Removed from favorites');
    }
  }

  _toggleUiVisibility() {
    setState(() {
      _isUiVisible = !_isUiVisible;
    });
    _updateSystemUi();
  }

  _updateSystemUi() {
    // if (_isUiVisible) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: SystemUiOverlay.values);
    // } else {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    // }
    // setState(() {});
  }

  _systemNavBarChange() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black.withOpacity(0.002),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _systemNavBarChange();
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
        return true;
      },
      child: GestureDetector(
        onTap: _toggleUiVisibility,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: _isUiVisible
              ? AppBar(
                  toolbarHeight: 80,
                  automaticallyImplyLeading: false,
                  leadingWidth: 0,
                  title: Container(
                    height: 35,
                    width: 35,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: IconButton(
                        splashRadius: 20,
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        icon: const Icon(Icons.close),
                        color: Colors.black,
                        iconSize: 20.0,
                      ),
                    ),
                  ),
                  actions: [
                    Container(
                      height: 35,
                      width: 35,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: IconButton(
                        tooltip: 'Favorite',
                        splashRadius: 20,
                        onPressed: toggleFavorite,
                        icon: Icon(
                          favoritePhotos.contains(widget.photo.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: favoritePhotos.contains(widget.photo.id)
                              ? Colors.red.shade600
                              : Colors.black,
                          size: 20.0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                )
              : null,
          body: Stack(
            children: [
              Hero(
                tag: 'photo_${widget.photo.id}',
                child: CachedNetworkImage(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  imageUrl: widget.photo.url.regular,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Image.network(
                    widget.photo.url.thumb,
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              if (_isSettingWallpaper)
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: (_isUiVisible)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: IconButton(
                        tooltip: 'Lock Screen',
                        onPressed: () => setWallpaper(0),
                        icon: const Icon(Icons.lock),
                        color: Colors.black,
                        iconSize: 24.0,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: IconButton(
                        tooltip: 'Both Screens',
                        onPressed: () => setWallpaper(1),
                        icon: const Icon(Icons.sync_alt),
                        color: Colors.black,
                        iconSize: 24.0,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: IconButton(
                        tooltip: 'Home Screen',
                        onPressed: () => setWallpaper(2),
                        icon: const Icon(Icons.home_filled),
                        color: Colors.black,
                        iconSize: 24.0,
                      ),
                    ),
                  ],
                )
              : SizedBox(),
        ),
      ),
    );
  }
}
