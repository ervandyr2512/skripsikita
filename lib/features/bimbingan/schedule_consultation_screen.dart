import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../models/models.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/consultation_viewmodel.dart';

class ScheduleConsultationScreen extends StatefulWidget {
  const ScheduleConsultationScreen({super.key});

  @override
  State<ScheduleConsultationScreen> createState() => _ScheduleConsultationScreenState();
}

class _ScheduleConsultationScreenState extends State<ScheduleConsultationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _agendaController = TextEditingController(
    text: '1. \n2. \n3. ',
  );
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  int _duration = 30;

  final List<int> _durationOptions = [15, 30, 45, 60];

  final List<TimeOfDay> _availableSlots = const [
    TimeOfDay(hour: 9, minute: 0),
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 11, minute: 0),
    TimeOfDay(hour: 13, minute: 0),
    TimeOfDay(hour: 14, minute: 0),
    TimeOfDay(hour: 15, minute: 0),
    TimeOfDay(hour: 16, minute: 0),
  ];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final dt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    final c = Consultation(
      id: const Uuid().v4(),
      scheduledAt: dt,
      durationMinutes: _duration,
      agenda: _agendaController.text.trim(),
      supervisorName: context.read<AuthViewModel>().user!.supervisor,
    );
    context.read<ConsultationViewModel>().scheduleConsultation(c);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bimbingan terjadwal! Dosen akan menerima notifikasi 📅'),
        backgroundColor: AppColors.success,
      ),
    );
    context.pop();
  }

  @override
  void dispose() {
    _agendaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwalkan Bimbingan'),
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
              const _Label('Pilih Tanggal'),
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
                          DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(_selectedDate),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const _Label('Slot Tersedia Dosen'),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.divider),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableSlots.map((t) {
                    final active = t.hour == _selectedTime.hour && t.minute == _selectedTime.minute;
                    return InkWell(
                      onTap: () => setState(() => _selectedTime = t),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: active ? AppColors.primary : Colors.white,
                          border: Border.all(
                            color: active ? AppColors.primary : AppColors.divider,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          t.format(context),
                          style: TextStyle(
                            color: active ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              const _Label('Durasi'),
              Row(
                children: _durationOptions
                    .map((d) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: d == _durationOptions.last ? 0 : 8),
                            child: InkWell(
                              onTap: () => setState(() => _duration = d),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _duration == d ? AppColors.primary : Colors.white,
                                  border: Border.all(
                                    color: _duration == d ? AppColors.primary : AppColors.divider,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    '$d min',
                                    style: TextStyle(
                                      color: _duration == d ? Colors.white : AppColors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              const _Label('Agenda Bimbingan'),
              TextFormField(
                controller: _agendaController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: '1. Topik pertama\n2. Pertanyaan tentang...\n3. Review BAB...',
                  alignLabelWithHint: true,
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Agenda wajib diisi';
                  if (v.length < 10) return 'Agenda terlalu singkat';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: AppColors.info, size: 18),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Agenda yang jelas membantu dosen mempersiapkan diri dan membuat sesi lebih efektif.',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.event_available_rounded, color: Colors.white),
                label: const Text('Konfirmasi Jadwal'),
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
