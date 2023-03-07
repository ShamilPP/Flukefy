class Cart {
  String? docId;
  final String userId;
  final String productId;
  final DateTime time;

  Cart({
    this.docId,
    required this.userId,
    required this.productId,
    required this.time,
  });
}
