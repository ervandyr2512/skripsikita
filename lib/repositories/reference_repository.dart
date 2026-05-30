// REPOSITORY: ReferenceRepository
// Operasi CRUD untuk referensi jurnal/buku akademik.

import '../data/mock_data.dart';
import '../models/reference_item.dart';

class ReferenceRepository {
  late final List<ReferenceItem> _items;

  ReferenceRepository() {
    _items = MockData.references();
  }

  // READ - All
  List<ReferenceItem> getAll() => List.unmodifiable(_items);

  // READ - Search & filter
  List<ReferenceItem> search({String? query, String? tag}) {
    return _items.where((r) {
      final matchQuery = query == null ||
          query.isEmpty ||
          r.title.toLowerCase().contains(query.toLowerCase()) ||
          r.authors.toLowerCase().contains(query.toLowerCase());
      final matchTag = tag == null || tag == 'Semua' || r.tag == tag;
      return matchQuery && matchTag;
    }).toList();
  }

  List<String> getAllTags() => ['Semua', ...{..._items.map((r) => r.tag)}];

  // CREATE
  void add(ReferenceItem reference) {
    _items.insert(0, reference);
  }

  // UPDATE
  void toggleStar(String id) {
    final idx = _items.indexWhere((r) => r.id == id);
    if (idx == -1) return;
    _items[idx].starred = !_items[idx].starred;
  }

  void update(ReferenceItem reference) {
    final idx = _items.indexWhere((r) => r.id == reference.id);
    if (idx == -1) return;
    _items[idx] = reference;
  }

  // DELETE
  void delete(String id) {
    _items.removeWhere((r) => r.id == id);
  }
}
