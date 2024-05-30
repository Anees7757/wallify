import 'package:wallify/models/photo.dart';

List<Photo> category_photos = [];
List<Photo> recommended_photos = [];

final List<String> categories = [
  'Abstract',
  'Animals',
  'Foods',
  'Nature',
  'Cars',
  'Sunset',
  'Fashion',
  'Sports',
  'Technology',
  'Travel',
  'People',
  'Architecture',
  'Space',
  'Music',
  'Art',
  'Flowers',
  'Mountains',
];

enum WallpaperLocation {
  /// Wallpaper for the home screen.
  homeScreen,

  /// Wallpaper for the lock screen.
  lockScreen,

  /// Wallpaper for both the home and lock screens.
  bothScreens,
}
