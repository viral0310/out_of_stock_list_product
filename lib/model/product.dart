import 'dart:typed_data';

class Product {
  int? id;
  final String name;
  final int price;
  int quantity;
  Uint8List? image;
  bool? isTrue;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.image,
    this.isTrue,
  });

  factory Product.fromMap(Map<String, dynamic> data) {
    return Product(
      id: data['id'],
      name: data['name'],
      price: data['price'],
      quantity: data['quantity'],
      image: data['image'],
      isTrue: (data['isTrue'] == false) ? false : true,
    );
  }
}
