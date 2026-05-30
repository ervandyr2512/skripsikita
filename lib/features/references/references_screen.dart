import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../models/models.dart';
import '../../shared/widgets/gradient_card.dart';
import '../../viewmodels/reference_viewmodel.dart';

class ReferencesScreen extends StatefulWidget {
  const ReferencesScreen({super.key});

  @override
  State<ReferencesScreen> createState() => _ReferencesScreenState();
}

class _ReferencesScreenState extends State<ReferencesScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String _filterTag = 'Semua';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReferenceViewModel>();
    // Sync state lokal ke ViewModel agar logic filter terpusat di VM.
    if (_query != vm.query) {
      WidgetsBinding.instance.addPostFrameCallback((_) => vm.setQuery(_query));
    }
    if (_filterTag != vm.filterTag) {
      WidgetsBinding.instance.addPostFrameCallback((_) => vm.setFilterTag(_filterTag));
    }
    final tags = vm.availableTags;
    final filtered = vm.filteredReferences;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reference Vault'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file_rounded),
            onPressed: () => context.push('/add-reference'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Cari judul, penulis...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
            ),
          ),
          SizedBox(
            height: 36,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: tags.length,
              itemBuilder: (context, i) {
                final t = tags[i];
                final active = t == _filterTag;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(t),
                    selected: active,
                    onSelected: (_) => setState(() => _filterTag = t),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: active ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filtered.isEmpty
                ? EmptyState(
                    icon: Icons.menu_book_rounded,
                    title: _query.isEmpty ? 'Belum ada referensi' : 'Tidak ditemukan',
                    subtitle: _query.isEmpty
                        ? 'Unggah jurnal PDF pertamamu untuk memulai pustaka pribadi.'
                        : 'Coba kata kunci lain atau ubah filter.',
                    actionLabel: _query.isEmpty ? 'Unggah Referensi' : null,
                    onAction: _query.isEmpty ? () => context.push('/add-reference') : null,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) => _ReferenceCard(reference: filtered[i]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-reference'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.upload_file_rounded, color: Colors.white),
        label: const Text('Unggah', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _ReferenceCard extends StatelessWidget {
  final ReferenceItem reference;
  const _ReferenceCard({required this.reference});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => _showDetail(context),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 64,
                decoration: BoxDecoration(
                  gradient: AppColors.warningGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 24),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            reference.tag,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${reference.year}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textHint,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      reference.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reference.authors,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  reference.starred ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: reference.starred ? AppColors.warning : AppColors.textHint,
                ),
                onPressed: () =>
                    context.read<ReferenceViewModel>().toggleStar(reference.id),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (ctx, scroll) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: ListView(
              controller: scroll,
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        reference.tag,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${reference.year}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(reference.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, height: 1.3)),
                const SizedBox(height: 6),
                Text(
                  reference.authors,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                _section('Ringkasan', reference.summary),
                const SizedBox(height: 16),
                _section('Sitasi APA', reference.apaCitation, copyable: true, context: context),
                const SizedBox(height: 16),
                _section('File', reference.fileName),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.read<ReferenceViewModel>().deleteReference(reference.id);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Referensi dihapus')),
                          );
                        },
                        icon: const Icon(Icons.delete_outline_rounded, size: 18),
                        label: const Text('Hapus'),
                        style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Membuka PDF... (demo)')),
                          );
                        },
                        icon: const Icon(Icons.open_in_new_rounded, size: 18, color: Colors.white),
                        label: const Text('Buka PDF'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _section(String title, String content, {bool copyable = false, BuildContext? context}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  )),
              const Spacer(),
              if (copyable && context != null)
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: content));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sitasi disalin ke clipboard 📋'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(content, style: const TextStyle(fontSize: 13, height: 1.5)),
        ],
      ),
    );
  }
}
