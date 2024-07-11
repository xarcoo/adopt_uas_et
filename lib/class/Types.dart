class Types {
  final int id;
  late final String name;

  Types({required this.id, required this.name});

  factory Types.fromJson(Map<String, dynamic> json) {
    return Types(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
