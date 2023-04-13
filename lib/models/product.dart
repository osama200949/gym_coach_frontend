class Product {
  int id;
  String name;
  String description;
  double price;

  Product(
      {required this.id,
      required this.name,
      required this.description,
      required this.price});

  Product.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            name: json['name'],
            description: json['description'],
            price: json['price'].toDouble());

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'description': description, 'price': price};
}
