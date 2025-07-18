import '../models/model_order.dart';

class CartCalculator {
  static double calculateSubtotal(List<OrderItem> cartItems) {
    return cartItems.fold(
      0.0,
      (sum, item) =>
          sum + item.price + item.extras.fold(0.0, (a, e) => a + e.price),
    );
  }

  static double calculateDiscount(List<OrderItem> cartItems) {
    final subtotal = calculateSubtotal(cartItems);
    final hasFries = cartItems.any(
      (item) => item.extras.any((e) => e.name.toLowerCase() == 'fries'),
    );
    final hasDrink = cartItems.any(
      (item) => item.extras.any((e) => e.name.toLowerCase() == 'soft drink'),
    );

    if (hasFries && hasDrink) return subtotal * 0.2;
    if (hasFries) return subtotal * 0.15;
    if (hasDrink) return subtotal * 0.1;
    return 0.0;
  }
}
