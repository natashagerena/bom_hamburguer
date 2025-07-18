import '../models/model_order.dart';
import 'cart_service.dart';

class CartActions {
  static Future<void> finalizeOrder(List<OrderItem> cartItems) async {
    for (final item in cartItems) {
      final historico = OrderItem(
        id: item.id,
        name: item.name,
        image: item.image,
        description: item.description,
        price: item.price,
        extras: item.extras,
        dateTime: DateTime.now(),
      );
      await CartService.saveOrderToHistory(historico);
    }
    await CartService.clearCart();
  }
}
