class Map_app {
  final int id;
  final double latitude;
  final double longitude;
  final double rank;
  final String created_at;


  Map_app({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.rank,
    required this.created_at
  });

    factory Map_app.fromJson(Map<String, dynamic> json) {
      return Map_app(
        id: json['id'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        rank: json['rank'],
        created_at: json['created_at'],
      );
    }
}