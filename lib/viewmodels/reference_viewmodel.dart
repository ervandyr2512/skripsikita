// VIEWMODEL: ReferenceViewModel
// Mengelola state & logic terkait Reference Vault (manajemen referensi).

import 'package:flutter/foundation.dart';

import '../models/reference_item.dart';
import '../repositories/reference_repository.dart';

class ReferenceViewModel extends ChangeNotifier {
  final ReferenceRepository _repository;

  ReferenceViewModel(this._repository);

  // ====== STATE ======
  String _query = '';
  String _filterTag = 'Semua';

  String get query => _query;
  String get filterTag => _filterTag;

  // ====== READS ======
  List<ReferenceItem> get allReferences => _repository.getAll();
  List<String> get availableTags => _repository.getAllTags();

  List<ReferenceItem> get filteredReferences =>
      _repository.search(query: _query, tag: _filterTag);

  int get totalCount => allReferences.length;

  // ====== FILTER / SEARCH ======
  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setFilterTag(String tag) {
    _filterTag = tag;
    notifyListeners();
  }

  // ====== CRUD ======
  void addReference(ReferenceItem reference) {
    _repository.add(reference);
    notifyListeners();
  }

  void toggleStar(String id) {
    _repository.toggleStar(id);
    notifyListeners();
  }

  void deleteReference(String id) {
    _repository.delete(id);
    notifyListeners();
  }
}
