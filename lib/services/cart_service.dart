import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/model_order.dart';

class CartService {
  static const _cartKey = 'cart_items';

  // Adiciona um item ao carrinho
  static Future<void> addToCart(OrderItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getCart();
    items.add(item);

    final cartJson = jsonEncode(items.map((e) => e.toMap()).toList());
    await prefs.setString(_cartKey, cartJson);
  }

  // Atualiza um item existente no carrinho com base no ID
  static Future<void> updateItem(OrderItem updatedItem) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getCart();
    final index = items.indexWhere((item) => item.id == updatedItem.id);

    if (index != -1) {
      items[index] = updatedItem;
      final cartJson = jsonEncode(items.map((e) => e.toMap()).toList());
      await prefs.setString(_cartKey, cartJson);
    }
  }

  // Recupera a lista de itens do carrinho
  static Future<List<OrderItem>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString(_cartKey);

    if (cartJson == null) return [];

    final List<dynamic> decoded = jsonDecode(cartJson);
    return decoded.map((e) => OrderItem.fromMap(e)).toList();
  }

  // Limpa todos os itens do carrinho
  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }

  // Criando Historico de pedidos
  static const _historyKey = 'order_history';

  // Adiciono o pedido no historico
  static Future<void> saveOrderToHistory(OrderItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final historyData = prefs.getStringList(_historyKey) ?? [];
    historyData.add(jsonEncode(item.toMap()));
    await prefs.setStringList(_historyKey, historyData);
  }

  // recupero o historico
  static Future<List<OrderItem>> getOrderHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyData = prefs.getStringList(_historyKey) ?? [];
    return historyData.map((e) => OrderItem.fromMap(jsonDecode(e))).toList();
  }

}
