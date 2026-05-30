import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../models/models.dart';
import '../../viewmodels/timeline_viewmodel.dart';

class AddMilestoneScreen extends StatefulWidget {
  const AddMilestoneScreen({super.key});

  @override
  State<AddMilestoneScreen> createState() => _AddMilestoneScreenState();
}

class _AddMilestoneScreenState extends State<AddMilestoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedChapter = 'BAB 1';
  int _priority = 2;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));

  final List<String> _chapters = ['BAB 1', 'BAB 2', 'BAB 3', 'BAB 4', 'BAB 5'];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Pilih tenggat',
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final m = Milestone(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      chapter: _selectedChapter,
      description: _descController.text.trim(),
      dueDate: _dueDate,
      priority: _priority,
    );
    context.read<TimelineViewModel>().addMilestone(m);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Milestone berhasil ditambahkan ✨'),
        backgroundColor: AppColors.success,
      ),
    );
    context.pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Milestone'),
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lightbulb_outline_rounded, color: AppColors.primary, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tip: pecah pekerjaan besar menjadi milestone yang bisa selesai dalam 1-7 hari.',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const _Label('Judul Milestone'),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'mis. Selesaikan revisi BAB 1',
                  prefixIcon: Icon(Icons.title_rounded, size: 20),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Judul wajib diisi';
                  if (v.length < 5) return 'Judul terlalu pendek (min. 5 karakter)';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const _Label('BAB'),
              Wrap(
                spacing: 8,
                children: _chapters.map((c) {
                  final active = c == _selectedChapter;
                  return ChoiceChip(
                    label: Text(c),
                    selected: active,
                    onSelected: (_) => setState(() => _selectedChapter = c),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: active ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const _Label('Deskripsi'),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Jelaskan lebih detail tugas ini...',
                  alignLabelWithHint: true,
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Deskripsi wajib diisi';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const _Label('Tenggat'),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.divider),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(_dueDate),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const _Label('Prioritas'),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 1, label: Text('Tinggi'), icon: Icon(Icons.flag, size: 16)),
                  ButtonSegment(value: 2, label: Text('Sedang')),
                  ButtonSegment(value: 3, label: Text('Rendah')),
                ],
                selected: {_priority},
                onSelectionChanged: (set) => setState(() => _priority = set.first),
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: AppColors.primary,
                  selectedForegroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check_rounded, color: Colors.white),
                label: const Text('Simpan Milestone'),
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
