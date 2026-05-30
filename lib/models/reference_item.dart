// MODEL: ReferenceItem
// Mewakili satu referensi jurnal/buku di Reference Vault.

class ReferenceItem {
  final String id;
  String title;
  String authors;
  int year;
  String tag; // BAB 1, Teori X, Metode Y
  String fileName;
  String summary;
  bool starred;

  ReferenceItem({
    required this.id,
    required this.title,
    required this.authors,
    required this.year,
    required this.tag,
    required this.fileName,
    required this.summary,
    this.starred = false,
  });

  String get apaCitation =>
      '$authors ($year). $title. Jurnal Akademik Indonesia.';
}
