import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../models/models.dart';
import '../../viewmodels/reference_viewmodel.dart';

class AddReferenceScreen extends StatefulWidget {
  const AddReferenceScreen({super.key});

  @override
  State<AddReferenceScreen> createState() => _AddReferenceScreenState();
}

class _AddReferenceScreenState extends State<AddReferenceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorsController = TextEditingController();
  final _yearController = TextEditingController(text: DateTime.now().year.toString());
  final _summaryController = TextEditingController();
  String _selectedTag = 'BAB 2';
  bool _hasFile = false;
  String _fileName = '';

  final List<String> _tagOptions = ['BAB 1', 'BAB 2', 'BAB 3', 'BAB 4', 'BAB 5', 'Metodologi', 'Lainnya'];

  void _simulateUpload() {
    setState(() {
      _hasFile = true;
      _fileName = 'jurnal_${DateTime.now().millisecondsSinceEpoch}.pdf';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File berhasil diunggah ✅'),
        backgroundColor: AppColors.success,
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (!_hasFile) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan unggah file PDF terlebih dahulu'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }
    final ref = ReferenceItem(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      authors: _authorsController.text.trim(),
      year: int.tryParse(_yearController.text) ?? DateTime.now().year,
      tag: _selectedTag,
      fileName: _fileName,
      summary: _summaryController.text.trim(),
    );
    context.read<ReferenceViewModel>().addReference(ref);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Referensi tersimpan! 📚'),
        backgroundColor: AppColors.success,
      ),
    );
    context.pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorsController.dispose();
    _yearController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unggah Referensi'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              GestureDetector(
                onTap: _simulateUpload,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _hasFile
                        ? AppColors.success.withValues(alpha: 0.06)
                        : AppColors.primary.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _hasFile
                          ? AppColors.success.withValues(alpha: 0.4)
                          : AppColors.primary.withValues(alpha: 0.3),
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: _hasFile
                              ? AppColors.successGradient
                              : AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          _hasFile ? Icons.check_rounded : Icons.cloud_upload_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _hasFile ? 'File terunggah' : 'Tap untuk unggah PDF',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _hasFile
                            ? _fileName
                            : 'Maks. 25 MB. Format: PDF',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const _Label('Judul Lengkap'),
              TextFormField(
                controller: _titleController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Judul jurnal/buku/artikel',
                  prefixIcon: Icon(Icons.title_rounded, size: 20),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Judul wajib diisi';
                  if (v.length < 10) return 'Judul terlalu pendek';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const _Label('Penulis'),
              TextFormField(
                controller: _authorsController,
                decoration: const InputDecoration(
                  hintText: 'mis. Smith, J., & Doe, M.',
                  prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Penulis wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Label('Tahun'),
                        TextFormField(
                          controller: _yearController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: '2024'),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Wajib';
                            final n = int.tryParse(v);
                            if (n == null) return 'Angka';
                            if (n < 1900 || n > DateTime.now().year + 1) return 'Tidak valid';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Label('Kategori'),
                        DropdownButtonFormField<String>(
                          value: _selectedTag,
                          items: _tagOptions
                              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                              .toList(),
                          onChanged: (v) => setState(() => _selectedTag = v ?? _selectedTag),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const _Label('Ringkasan / Anotasi'),
              TextFormField(
                controller: _summaryController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Tulis poin-poin penting yang ingin kamu ingat...',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Ringkasan wajib diisi';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_rounded, color: Colors.white),
                label: const Text('Simpan Referensi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
    );
  }
}
