import 'package:flutter/material.dart';

class CartSummaryCard extends StatelessWidget {
  final double subtotal;
  final double discount;

  const CartSummaryCard({
    super.key,
    required this.subtotal,
    required this.discount,
  });

  double get total => subtotal - discount;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Summary order',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _linhaResumo('Subtotal', subtotal),
            _linhaResumo('Discount', discount),
            const Divider(height: 28),
            _linhaResumo('Total', total, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _linhaResumo(String label, double valor, {bool isTotal = false}) {
    final color = isTotal ? Colors.red[800] : Colors.black;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: color)),
        Text(
          '\$ ${valor.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
