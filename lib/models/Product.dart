// ignore_for_file: non_constant_identifier_names, file_names

class Product {
  final String id;
  final String name;
  final String name_ar;
  final double price;
  final double old_price;
  final double pv;

  Product(
      {required this.id,
      required this.name,
      required this.name_ar,
      required this.price,
      required this.old_price,
      required this.pv});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      name_ar: json['name_ar'],
      price: json['price'],
      old_price: json['old_price'],
      pv: json['pv'],
    );
  }
}
