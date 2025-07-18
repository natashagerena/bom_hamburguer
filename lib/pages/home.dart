import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 180,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.1,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _Card(
                    context,
                    icon: Icons.menu_book,
                    label: 'Menu',
                    onTap: () => Navigator.pushNamed(context, '/menu'),
                  ),
                  _Card(
                    context,
                    icon: Icons.fastfood,
                    label: 'Create Order',
                    onTap: () => Navigator.pushNamed(context, '/order'),
                  ),
                  _Card(
                    context,
                    icon: Icons.local_grocery_store,
                    label: 'My Cart',
                    onTap: () => Navigator.pushNamed(context, '/cart'),
                  ),
                  _Card(
                    context,
                    icon: Icons.receipt_long,
                    label: 'Order History',
                    onTap: () => Navigator.pushNamed(context, '/history'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _Card(BuildContext context,
    {required IconData icon,
    required String label,
    required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.red[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white), 
              SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
  );
  }

}
