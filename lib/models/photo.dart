class Photo {
  final String id;
  final String description;
  final String url;

  Photo({required this.id, required this.description, required this.url});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      description: json['description'] ?? '',
      url: json['urls']['regular'],
    );
  }
}
