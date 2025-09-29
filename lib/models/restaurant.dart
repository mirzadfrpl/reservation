class RestaurantListItem {
  final String id;
  final String name;
  final String pictureId;
  final String city;
  final double rating;
  final String description;

  RestaurantListItem({
    required this.id,
    required this.name,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.description,
  });

  factory RestaurantListItem.fromJson(Map<String, dynamic> json) {
    return RestaurantListItem(
      id: json['id'],
      name: json['name'],
      pictureId: json['pictureId'],
      city: json['city'],
      rating: json['rating'].toDouble(),
      description: json['description'],
    );
  }
}
