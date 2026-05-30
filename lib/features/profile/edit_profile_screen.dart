// Layar ini sengaja diakses dengan Navigator.push + MaterialPageRoute
// (bukan GoRouter) untuk mendemonstrasikan dua jenis navigasi.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../viewmodels/auth_viewmodel.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _supervisorController;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthViewModel>().user!;
    _nameController = TextEditingController(text: user.name);
    _supervisorController = TextEditingController(text: user.supervisor);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _supervisorController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthViewModel>().updateProfile(
          name: _nameController.text.trim(),
          supervisor: _supervisorController.text.trim(),
        );
    Navigator.of(context).pop(true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil berhasil diperbarui ✨'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        // Tombol kembali otomatis muncul karena halaman ini di-push
        // oleh Navigator.push(MaterialPageRoute(...))
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
                  color: AppColors.info.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: AppColors.info, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Halaman ini di-push dengan Navigator.push + MaterialPageRoute.',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('Nama Lengkap',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline, size: 20),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              const Text('Dosen Pembimbing',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _supervisorController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.school_outlined, size: 20),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Pembimbing wajib diisi' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_rounded, color: Colors.white),
                label: const Text('Simpan Perubahan'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Batal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
