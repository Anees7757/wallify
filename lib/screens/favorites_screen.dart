import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallify/utils/hex_color.dart';
import '../models/photo.dart';
import '../services/unsplash_service.dart';
import 'photo_detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Photo> _favoritePhotos = [];
  bool _isLoading = true;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _fetchFavoritePhotos();
  }

  Future<void> _fetchFavoritePhotos() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final favoritePhotoIds = _prefs.getStringList('favoritePhotos') ?? [];
      // Fetch photos by their IDs
      final List<Photo> favoritePhotos = [];
      for (String id in favoritePhotoIds) {
        final photo = await Provider.of<UnsplashService>(context, listen: false)
            .fetchPhotoById(id);
        favoritePhotos.add(photo);
      }
      setState(() {
        _favoritePhotos = favoritePhotos;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
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
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Favorites',
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
          : _favoritePhotos.isEmpty
              ? const Center(
                  child: Text('No favorite yet'),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: _favoritePhotos.length,
                    itemBuilder: (BuildContext context, int index) {
                      final photo = _favoritePhotos[index];
                      Color color = HexColor.fromHex(photo.color);

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PhotoDetailScreen(photo: photo),
                            ),
                          ).then((value) {
                            if (value == true) {
                              _fetchFavoritePhotos();
                            } else {
                              _fetchFavoritePhotos();
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: CachedNetworkImage(
                              imageUrl: photo.url.thumb,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
