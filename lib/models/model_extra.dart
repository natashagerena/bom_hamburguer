class Extra {
  final String image;
  final String name;
  final String description;
  final double price;

  Extra({
    required this.image,
    required this.name,
    required this.description,
    required this.price,
  });

  factory Extra.fromMap(Map<String, dynamic> map) {
    return Extra(
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

  static List<Extra> get predefined => [
    Extra(
      image: 'assets/images/fries.jpg',
      name: 'Fries',
      description: 'Crispy French fries.',
      price: 5.00,
    ),
    Extra(
      image: 'assets/images/soft_drink.jpg',
      name: 'Soft Drink',
      description: 'Soda with ice.',
      price: 4.50,
    ),
  ];
}
