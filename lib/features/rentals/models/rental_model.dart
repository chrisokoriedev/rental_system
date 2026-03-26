class RentalModel {
  const RentalModel({
    required this.id,
    required this.title,
    required this.location,
    required this.pricePerNight,
    required this.rating,
    required this.imageUrl,
    required this.description,
    required this.amenities,
  });

  final String id;
  final String title;
  final String location;
  final double pricePerNight;
  final double rating;
  final String imageUrl;
  final String description;
  final List<String> amenities;
}
