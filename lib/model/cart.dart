class Cart {
  final String? cartId;
  final String userId;
  final String productId;
  final DateTime time;

  Cart({
    this.cartId,
    required this.userId,
    required this.productId,
    required this.time,
  });
}
