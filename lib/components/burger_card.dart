import 'package:flutter/material.dart';
import '../models/model_burger.dart';
import '../services/cart_service.dart';

class BurgerCard extends StatelessWidget {
  final Burger burger;

  const BurgerCard({super.key, required this.burger});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                burger.image,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      burger.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      burger.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$ ${burger.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 5,
            bottom: 5,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.red[800],
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () async {
                final cart = await CartService.getCart();

                if (cart.isNotEmpty) {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Heads up'),
                      content: const Text(
                        // Somente um burger
                        'Only one burger can be selected per order. Would you like to replace the current one?',
                      ),
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
                          child: const Text('Replace'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await CartService.clearCart();
                    Navigator.pushNamed(
                      context,
                      '/details',
                      arguments: {
                        'name': burger.name,
                        'image': burger.image,
                        'description': burger.description,
                        'price': burger.price,
                      },
                    );
                  }
                } else {
                  Navigator.pushNamed(
                    context,
                    '/details',
                    arguments: {
                      'name': burger.name,
                      'image': burger.image,
                      'description': burger.description,
                      'price': burger.price,
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
