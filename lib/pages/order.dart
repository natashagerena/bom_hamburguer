import 'package:flutter/material.dart';
import '../components/header.dart';
import '../models/model_burger.dart';
import '../components/burger_card.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final burgers = Burger.predefined;

    return Scaffold(
      appBar: AppHeader(
        title: 'Order',
        onBack: () => Navigator.pushNamed(context, '/'),
        trailingIcon: Icons.shopping_cart,
        onTrailingTap: () => Navigator.pushNamedAndRemoveUntil(context, '/cart', (route) => false),
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: burgers.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            return BurgerCard(burger: burgers[index]);
          },
        ),
      ),
    );
  }
}