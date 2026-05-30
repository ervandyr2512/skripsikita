// MODEL: Milestone
// Mewakili satu milestone (target/tugas kecil) dari perjalanan skripsi.

import 'package:flutter/material.dart';

enum MilestoneStatus { todo, inProgress, done, overdue }

class Milestone {
  final String id;
  String title;
  String chapter; // BAB 1, BAB 2, ...
  String description;
  DateTime dueDate;
  MilestoneStatus status;
  int priority; // 1=high, 2=mid, 3=low

  Milestone({
    required this.id,
    required this.title,
    required this.chapter,
    required this.description,
    required this.dueDate,
    this.status = MilestoneStatus.todo,
    this.priority = 2,
  });

  Color get statusColor {
    switch (status) {
      case MilestoneStatus.done:
        return const Color(0xFF10B981);
      case MilestoneStatus.inProgress:
        return const Color(0xFF3B5BFE);
      case MilestoneStatus.overdue:
        return const Color(0xFFEF4444);
      case MilestoneStatus.todo:
        return const Color(0xFF6B7280);
    }
  }

  String get statusLabel {
    switch (status) {
      case MilestoneStatus.done:
        return 'Selesai';
      case MilestoneStatus.inProgress:
        return 'Berjalan';
      case MilestoneStatus.overdue:
        return 'Lewat tenggat';
      case MilestoneStatus.todo:
        return 'Belum mulai';
    }
  }
}
