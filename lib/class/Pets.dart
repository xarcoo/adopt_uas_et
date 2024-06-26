class Pets {
  final int id;
  late final String? nama;
  String jenis;
  String keterangan;
  String foto;
  int? is_adopt;
  final String? adopter;
  final String owner;

  Pets({required this.id, this.nama, required this.jenis, required this.keterangan, required this.foto, this.is_adopt, this.adopter, required this.owner});
  
  factory Pets.fromJson(Map<String, dynamic> json){
    return Pets(
        id: json['id'] as int,
        jenis: json['jenis'] as String,
        keterangan: json['keterangan'] as String,
        foto: json['foto'] as String,
        owner: json['owner'] as String
    );
  }
}