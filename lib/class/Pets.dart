class Pets {
  final int id;
  late final String? nama;
  String jenis;
  String keterangan;
  String foto;
  int is_adopt;
  final String? adopter;
  final String owner;
  final int likes;

  Pets({required this.id, this.nama, required this.jenis, required this.keterangan, required this.foto, required this.is_adopt, this.adopter, required this.owner, required this.likes});
  
  factory Pets.fromJson(Map<String, dynamic> json){
    return Pets(
        id: json['id'] as int,
        jenis: json['jenis'] as String,
        keterangan: json['keterangan'] as String,
        foto: json['foto'] as String,
        adopter: json['adopter'] as String?,
        is_adopt: json['is_adopt'] as int,
        owner: json['owner'] as String,
      likes: json['likes'] as int
    );
  }
}