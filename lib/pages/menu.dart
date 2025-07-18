import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/menu_card.dart';
import '../models/model_burger.dart';
import '../models/model_extra.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final burgers = Burger.predefined;
    final extras = Extra.predefined;

    return Scaffold(
      appBar: AppHeader(
        title: 'Menu',
        onBack: () => Navigator.pushNamed(context, '/'),
        trailingIcon: Icons.shopping_cart,
        onTrailingTap: () => Navigator.pushNamedAndRemoveUntil(context, '/cart', (route) => false),
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // Texto Boas vindas
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 8),
            child: const Text(
              'Welcome to our menu! Here you can explore our ingredients and prices.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14, 
                fontWeight: FontWeight.bold,
                ),
            ),
          ),
          // Burgers
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 8),
            child: const Text(
              'Burgers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...burgers.map((burger) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: MenuCard(
                  image: burger.image,
                  name: burger.name,
                  description: burger.description,
                  price: burger.price,
                ),
              )),
          const SizedBox(height: 24),

          // Extras
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 8),
            child: const Text(
              'Extras',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...extras.map((extra) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: MenuCard(
                  image: extra.image,
                  name: extra.name,
                  description: extra.description,
                  price: extra.price,
                ),
              )),
        ],
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
}
