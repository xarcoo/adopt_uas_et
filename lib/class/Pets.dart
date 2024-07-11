class Pets {
  final int id;
  String nama;
  int type_id;
  String jenis;
  String keterangan;
  int? is_adopt;
  String? adopter;
  final String owner;
  int? likes;
  final List? user_tertarik;

  Pets(
      {required this.id,
      required this.nama,
      required this.type_id,
      required this.jenis,
      required this.keterangan,
      required this.is_adopt,
      this.adopter,
      required this.owner,
      required this.likes,
      this.user_tertarik});

  factory Pets.fromJson(Map<String, dynamic> json) {
    return Pets(
        id: json['id'] as int,
        type_id: json['type_id'] as int,
        jenis: json['jenis'] as String,
        nama: json['nama'] as String,
        keterangan: json['keterangan'] as String,
        adopter: json['adopter'] as String?,
        is_adopt: json['is_adopt'] as int?,
        owner: json['owner'] as String,
        likes: json['likes'] as int?,
        user_tertarik: json['user_tertarik']);
  }
}
