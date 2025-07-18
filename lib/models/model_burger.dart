class Burger {
  final String image;
  final String name;
  final String description;
  final double price;

  Burger({
    required this.image,
    required this.name,
    required this.description,
    required this.price,
  });

  factory Burger.fromMap(Map<String, dynamic> map) {
    return Burger(
      image: map['image'],
      name: map['name'],
      description: map['description'],
      price: _parsePrice(map['price']),
    );
  }

  static double _parsePrice(dynamic value) {
    if (value is String) {
      return double.parse(value.replaceAll(RegExp(r'[^\d.]'), ''));
    }
    return value.toDouble();
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'name': name,
      'description': description,
      'price': price,
    };
  }

  static List<Burger> get predefined => [
        Burger(
          image: 'assets/images/x-burger.jpg',
          name: 'X Burger',
          description: 'Bread, burger, cheese, lettuce, and tomato.',
          price: 5.00,
        ),
        Burger(
          image: 'assets/images/x-egg.jpg',
          name: 'X Egg',
          description: 'Bread, burger, cheese, and egg.',
          price: 4.50,
        ),
        Burger(
          image: 'assets/images/x-bacon.jpg',
          name: 'X Bacon',
          description: 'Bread, burger, cheese, and crispy bacon.',
          price: 7.00,
        ),
      ];
}
