import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/header.dart';
import '../models/model_order.dart';
import '../services/cart_service.dart'; // Se preferir, crie OrderService separado

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List<OrderItem> history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final items = await CartService.getOrderHistory(); // ou OrderService.getHistory()
    setState(() {
      history = items.reversed.toList(); // mais recentes primeiro
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Order History',
        onBack: () => Navigator.pop(context),
      ),
      backgroundColor: Colors.grey[100],
      body: history.isEmpty
          ? const Center(child: Text('No orders found.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (_, index) {
                final item = history[index];
                return _buildHistoryCard(item);
              },
            ),

            // Botão Fazer meu pedido
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[800],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/order');
                  },
                  child: const Text(
                    'Order Now',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildHistoryCard(OrderItem item) {
    final extras = item.extras.map((e) => e.name).join(', ');
    final total = item.price + item.extras.fold(0.0, (sum, e) => sum + e.price);
    final formattedDate =
        DateFormat('MM/dd/yyyy HH:mm').format(item.dateTime);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        'Order: ${item.id.substring(1, 5)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          extras.isEmpty ? 'No extras' : extras,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Text(
                        '\$ ${total.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
