class Pets {
  final int id;
  late final String? nama;
  late final String jenis;
  late final String keterangan;
  final String foto;
  final int? is_adopt;
  final String? adopter;
  final String owner;
  final int? likes;
  final List? user_tertarik;

  Pets({required this.id, this.nama, required this.jenis, required this.keterangan, required this.foto, required this.is_adopt, this.adopter, required this.owner, required this.likes, this.user_tertarik});
  
  factory Pets.fromJson(Map<String, dynamic> json){
    return Pets(
        id: json['id'] as int,
        jenis: json['jenis'] as String,
        nama: json['nama'] as String?,
        keterangan: json['keterangan'] as String,
        foto: json['foto'] as String,
        adopter: json['adopter'] as String?,
        is_adopt: json['is_adopt'] as int?,
        owner: json['owner'] as String,
      likes: json['likes'] as int?,
      user_tertarik: json['user_tertarik']
    );
  }
}