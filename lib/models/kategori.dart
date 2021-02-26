class Kategori
{
  int kategoriID;
  String kategoriBaslik;

  Kategori(this.kategoriBaslik); // kategori eklerken kullan. Çünkü ID otomatik olarak oluşuyor.

  Kategori.withID(this.kategoriID, this.kategoriBaslik); // kategorileri veritabanından okurken kullanılır.

  Map<String,dynamic> toMap()
  {
    var map = Map<String,dynamic>();
    map['kategoriID'] = kategoriID;
    map['kategoriBaslik'] = kategoriBaslik;

    return map;
  }

  Kategori.fromMap(Map<String, dynamic> map)
  {
    this.kategoriID = map['kategoriID'];
    this.kategoriBaslik = map['kategoriBaslik'];
  }

  @override
  String toString() {
    return 'Kategori{kategoriID: $kategoriID, kategoriBaslik: $kategoriBaslik}';
  }
}