import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../viewmodels/auth_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nimController = TextEditingController();

  String _selectedProdi = 'S1 Manajemen';
  int _semester = 7;
  DateTime _targetDefenseDate = DateTime.now().add(const Duration(days: 180));
  bool _agreedToTerms = false;
  bool _isLoading = false;
  int _currentStep = 0;

  final List<String> _prodiOptions = [
    'S1 Manajemen',
    'S1 Akuntansi',
    'S1 Informatika',
    'S1 Sistem Informasi',
    'S1 Bisnis',
    'S1 Desain Komunikasi Visual',
    'S1 International Business Management',
    'S1 Hospitality Business',
  ];

  Future<void> _pickTargetDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDefenseDate,
      firstDate: DateTime.now().add(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      helpText: 'Pilih target tanggal sidang',
    );
    if (picked != null) setState(() => _targetDefenseDate = picked);
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kamu harus menyetujui Syarat & Ketentuan')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final ok = await context.read<AuthViewModel>().register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          nim: _nimController.text.trim(),
          prodi: _selectedProdi,
          semester: _semester,
          targetDefenseDate: _targetDefenseDate,
        );

    if (!mounted) return;
    setState(() => _isLoading = false);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selamat datang di SkripsiKita! 🎉'),
          backgroundColor: AppColors.success,
        ),
      );
      context.go('/home');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nimController.dispose();
    super.dispose();
  }

  Widget _buildStepIndicator() {
    return Row(
      children: List.generate(2, (i) {
        final active = i <= _currentStep;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i == 0 ? 6 : 0),
            height: 6,
            decoration: BoxDecoration(
              color: active ? AppColors.primary : AppColors.divider,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }

  bool _validateStep0() {
    return _nameController.text.trim().isNotEmpty &&
        _emailController.text.contains('@') &&
        _passwordController.text.length >= 6 &&
        _passwordController.text == _confirmPasswordController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Akun'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Langkah ${_currentStep + 1} dari 2',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _currentStep == 0 ? 'Informasi akun' : 'Detail akademik',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: _currentStep == 0 ? _buildStep0() : _buildStep1(),
                  ),
                ),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_currentStep == 0) {
                            if (_formKey.currentState!.validate() && _validateStep0()) {
                              setState(() => _currentStep = 1);
                            }
                          } else {
                            _register();
                          }
                        },
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                        )
                      : Text(_currentStep == 0 ? 'Lanjut' : 'Buat Akun'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep0() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Nama Lengkap'),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: 'Nama lengkap kamu',
            prefixIcon: Icon(Icons.person_outline, size: 20),
          ),
          validator: (v) => (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
        ),
        const SizedBox(height: 16),
        const _FieldLabel('Email Kampus'),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'nama@student.kampus.ac.id',
            prefixIcon: Icon(Icons.email_outlined, size: 20),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Email wajib diisi';
            if (!v.contains('@')) return 'Format email tidak valid';
            return null;
          },
        ),
        const SizedBox(height: 16),
        const _FieldLabel('Password'),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'Minimal 6 karakter',
            prefixIcon: Icon(Icons.lock_outline_rounded, size: 20),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Password wajib diisi';
            if (v.length < 6) return 'Password minimal 6 karakter';
            return null;
          },
        ),
        const SizedBox(height: 16),
        const _FieldLabel('Konfirmasi Password'),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'Ulangi password',
            prefixIcon: Icon(Icons.lock_outline_rounded, size: 20),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Konfirmasi password wajib diisi';
            if (v != _passwordController.text) return 'Password tidak sama';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('NIM'),
        TextFormField(
          controller: _nimController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Nomor induk mahasiswa',
            prefixIcon: Icon(Icons.badge_outlined, size: 20),
          ),
          validator: (v) => (v == null || v.isEmpty) ? 'NIM wajib diisi' : null,
        ),
        const SizedBox(height: 16),
        const _FieldLabel('Program Studi'),
        DropdownButtonFormField<String>(
          value: _selectedProdi,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.school_outlined, size: 20),
          ),
          items: _prodiOptions
              .map((p) => DropdownMenuItem(value: p, child: Text(p)))
              .toList(),
          onChanged: (v) => setState(() => _selectedProdi = v ?? _selectedProdi),
        ),
        const SizedBox(height: 16),
        const _FieldLabel('Semester saat ini'),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.divider),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(Icons.timeline_outlined, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 12),
              Expanded(
                child: Slider(
                  value: _semester.toDouble(),
                  min: 7,
                  max: 14,
                  divisions: 7,
                  label: 'Semester $_semester',
                  onChanged: (v) => setState(() => _semester = v.round()),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$_semester',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const _FieldLabel('Target Tanggal Sidang'),
        InkWell(
          onTap: _pickTargetDate,
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
                const Icon(Icons.calendar_today_outlined, size: 20, color: AppColors.textSecondary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(_targetDefenseDate),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        CheckboxListTile(
          value: _agreedToTerms,
          onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Saya menyetujui Syarat & Ketentuan dan Kebijakan Privasi SkripsiKita.',
            style: TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
    );
  }
}
