import 'model_extra.dart';

class OrderItem {
  final String id;
  final String name;
  final String image;
  final String description;
  final double price;
  final List<Extra> extras;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.extras,
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      description: map['description'],
      price: (map['price'] as num).toDouble(),
      extras: (map['extras'] as List<dynamic>)
          .map((e) => Extra.fromMap(e))
          .toList(),
      dateTime: DateTime.parse(map['dateTime']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'price': price,
      'extras': extras.map((e) => e.toMap()).toList(),
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
