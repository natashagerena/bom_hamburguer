import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/cart_item_card.dart';
import '../components/cart_summary_card.dart';
import '../models/model_order.dart';
import '../services/cart_service.dart';
import '../services/cart_calculator.dart';
import '../services/cart_actions.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<OrderItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final items = await CartService.getCart();
    setState(() {
      cartItems = items;
    });
  }

  void _editItem(OrderItem item) {
    Navigator.pushReplacementNamed(
      context,
      '/details',
      arguments: {
        'editId': item.id,
        'name': item.name,
        'image': item.image,
        'description': item.description,
        'price': item.price.toStringAsFixed(2),
        'selectedExtras': item.extras.map((e) => e.name).toList(),
      },
    );
  }

  void _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Heads up'),
        content: const Text('Are you sure you want to delete the items?'),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.grey[700],
            ),
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red[800],
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await CartService.clearCart();
      setState(() => cartItems = []);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart cleared successfully!')),
      );
    }
  }

  void _abrirResumoPagamento() {
    final subtotal = CartCalculator.calculateSubtotal(cartItems);
    final desconto = CartCalculator.calculateDiscount(cartItems);
    final total = subtotal - desconto;

    final TextEditingController nomeController = TextEditingController();
    final FocusNode nomeFocusNode = FocusNode();

    // Função para finalizar o pedido (extrai a lógica do botão e do enter)
    Future<void> finalizarPedido() async {
      final nome = nomeController.text.trim();
      if (nome.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your name to continue.')),
        );
        return;
      }

      Navigator.pop(context);

      await CartActions.finalizeOrder(cartItems);
      setState(() => cartItems = []);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          Future.delayed(const Duration(seconds: 4), () {
            Navigator.of(context).pop();
            Navigator.pushReplacementNamed(context, '/');
          });

          return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: const Icon(Icons.close, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),
                Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Thanks for your order!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          Future.delayed(Duration.zero, () {
            nomeFocusNode.requestFocus();
          });

          return AlertDialog(
            title: const Text('Summary of Charges'), // Resumo dos valores
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _linhaResumo('Subtotal', subtotal),
                  const SizedBox(height: 8),
                  _linhaResumo('Discount', desconto),
                  const Divider(height: 24),
                  _linhaResumo('Total', total),
                  const SizedBox(height: 24),
                  TextField(
                    controller: nomeController,
                    focusNode: nomeFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Your name',
                      labelStyle: const TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onSubmitted: (_) {
                      finalizarPedido();
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.grey[700],
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Back'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red[800],
                ),
                onPressed: finalizarPedido,
                child: const Text('Finish Payment'),
              ),
            ],
          );
        },
      ),
    );
  }


  Widget _linhaResumo(String label, double valor) {
    final cor = label == 'Total' ? Colors.red[800] : Colors.black;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: cor)),
        Text('\$ ${valor.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cor)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Cart',
        onBack: () => Navigator.pushReplacementNamed(context, '/'),
      ),
      backgroundColor: Colors.grey[100],
      body: cartItems.isEmpty
          ? Column(
              children: [
                const Spacer(),
                const Center(
                  child: Text(
                    'There is no order',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const Spacer(),
              ],
            )
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Your choice:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: cartItems.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index == cartItems.length) {
                        return CartSummaryCard(
                          subtotal: CartCalculator.calculateSubtotal(cartItems),
                          discount: CartCalculator.calculateDiscount(cartItems),
                        );
                      }
                      return CartItemCard(
                        item: cartItems[index],
                        onEdit: _editItem,
                      );
                    },
                  ),
                ),
                SafeArea(
                  minimum: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[800],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _abrirResumoPagamento,
                        child: const Text('Payment',
                            style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        label: const Text('Remove Items',
                            style: TextStyle(fontSize: 16, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[700],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _confirmDelete,
                      ),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: cartItems.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[800],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/order'),
                child: const Text(
                  'Order Now',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            )
          : null,
    );
  }
}