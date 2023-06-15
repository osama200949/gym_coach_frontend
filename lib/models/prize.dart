class Prize {
  int id;
  String title;
  String description;
  String? image;
  String? barcode;
  int points;

  Prize({
    this.id = 0,
    this.points = 0,
    required this.image,
    required this.barcode,
    required this.title,
    required this.description,
  });

  Prize.fromJson(Map<dynamic, dynamic> json)
      : this(
          id: json['id'],
          points: json['points'],
          image: json['image'],
          barcode: json['barcode'],
          title: json['title'],
          description: json['description'],
        );
}
