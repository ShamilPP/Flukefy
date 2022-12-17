class Product {
  final String? docId;
  final List<String> images;
  final String name;
  final String description;
  final String brand;
  final double rating;
  final int price;
  final int discount;

  Product({
    required this.docId,
    required this.images,
    required this.name,
    required this.description,
    required this.brand,
    required this.rating,
    required this.price,
    required this.discount,
  });
}
