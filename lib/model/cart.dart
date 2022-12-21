class Cart {
  final String userId;
  final String productId;
  final int qty;
  final DateTime time;

  Cart({
    required this.userId,
    required this.productId,
    required this.qty,
    required this.time,
  });
}
