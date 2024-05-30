import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/photo.dart';
import '../constants/contants.dart';

class UnsplashService {
  static const String _baseUrl = 'https://api.unsplash.com';

  Future<List<Photo>> fetchPhotos(int total) async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/photos/?client_id=$access_key&order_by=ORDER&per_page=$total'),
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((photo) => Photo.fromJson(photo)).toList();
    } else {
      throw Exception('Failed to load photos');
    }
  }

  Future<List<Photo>> fetchCategoryPhotos(String category, int total) async {
    List<Photo> photos = [];

    final response = await http.get(
      Uri.parse(
          '$_baseUrl/search/photos?query=$category&client_id=$access_key&per_page=$total'),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        if (total == 1) {
          photos.add(Photo.fromJson(data['results'][0]));
        } else {
          for (var item in data['results']) {
            photos.add(Photo.fromJson(item));
          }
        }
      }
    } else {
      throw Exception('Failed to load category photos');
    }

    return photos;
  }

  Future<Photo> fetchPhotoById(String id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/photos/$id?client_id=$access_key'),
    );

    if (response.statusCode == 200) {
      return Photo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch photo by ID');
    }
  }
}
