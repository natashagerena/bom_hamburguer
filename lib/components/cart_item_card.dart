import 'package:flutter/material.dart';
import '../models/model_order.dart';

class CartItemCard extends StatelessWidget {
  final OrderItem item;
  final void Function(OrderItem) onEdit;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final totalExtras = item.extras.fold(0.0, (sum, e) => sum + e.price);
    final total = item.price + totalExtras;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  if (item.extras.isNotEmpty) ...[
                    const Text(
                      'Extras:',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: item.extras
                          .map((e) => Text('• ${e.name}'))
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    'Total: \$ ${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => onEdit(item),
              icon: const Icon(Icons.edit, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
