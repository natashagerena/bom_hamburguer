import 'package:flutter/material.dart';
import '../components/header.dart';
import '../models/model_extra.dart';
import '../models/model_order.dart';
import '../services/cart_service.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  String name = '';
  String image = '';
  String description = '';
  double basePrice = 0.0;
  String? editId;

  final extras = Extra.predefined;
  final Map<String, bool> _selectedExtras = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    name = args['name'];
    image = args['image'];
    description = args['description'] ?? '';
    basePrice = double.tryParse(
          args['price'].toString().replaceAll(RegExp(r'[^\d.]'), ''),
        ) ??
        0.0;
    editId = args['editId'];

    // Inicializa o mapa com todos extras como false
    for (final extra in extras) {
      _selectedExtras[extra.name] = false;
    }

    final selected = args['selectedExtras'] as List<dynamic>?;
    if (selected != null) {
      for (final key in selected) {
        _selectedExtras[key] = true;
      }
    }
  }

  List<Extra> get selectedExtras =>
      extras.where((e) => _selectedExtras[e.name] == true).toList();

  double get totalPrice =>
      basePrice + selectedExtras.fold(0.0, (sum, e) => sum + e.price);

  Future<void> _addToCart() async {
    final order = OrderItem(
      id: editId ?? UniqueKey().toString(),
      name: name,
      image: image,
      description: description,
      price: basePrice,
      extras: selectedExtras, 
      dateTime: DateTime.now(),
    );

    if (editId != null) {
      await CartService.updateItem(order);
    } else {
      await CartService.addToCart(order);
    }

    Navigator.pushNamedAndRemoveUntil(context, '/cart', (route) => false);
  }

  Widget _buildExtraCard(Extra extra) {
    final isSelected = _selectedExtras[extra.name] ?? false;

    return GestureDetector(
      onTap: () => setState(() => _selectedExtras[extra.name] = !isSelected),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  extra.image,
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
                    Text(
                      extra.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$ ${extra.price.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: isSelected,
                onChanged: (value) =>
                    setState(() => _selectedExtras[extra.name] = value!),
                activeColor: Colors.red[800],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppHeader(
        title: 'Order Details',
        onBack: () => Navigator.pushNamed(context, '/order'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    image,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '\$ ${basePrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Extras',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...extras.map(_buildExtraCard),
                const SizedBox(height: 80),
              ],
            ),
          ),
          SafeArea(
            minimum: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[800],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Go to Cart',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
