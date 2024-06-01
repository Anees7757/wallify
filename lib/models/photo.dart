class Photo {
  final String id;
  final String description;
  final Url url;
  final int height;
  final int width;
  final String color;

  Photo(
      {required this.id,
      required this.description,
      required this.url,
      required this.height,
      required this.width,
      required this.color});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
        id: json['id'],
        description: json['description'] ?? '',
        url: Url.fromJson(json['urls']),
        height: json['height'],
        width: json['width'],
        color: json['color']);
  }
}

class Url {
  final String thumb;
  final String regular;
  final String full;
  final String raw;

  Url(
      {required this.thumb,
      required this.regular,
      required this.full,
      required this.raw});

  factory Url.fromJson(Map<String, dynamic> json) {
    return Url(
        thumb: json['thumb'],
        regular: json['regular'],
        full: json['full'],
        raw: json['raw']);
  }
}
