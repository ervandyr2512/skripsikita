// ============================================================================
// UNIT TEST: Milestone Model
// ============================================================================
//
// Menguji business logic murni dari kelas Milestone:
//  - Computed property: statusColor (mapping status → warna)
//  - Computed property: statusLabel (mapping status → label Bahasa Indonesia)
//  - Konstruktor & default values
//
// Pola: Arrange-Act-Assert (AAA)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skripsikita/models/milestone.dart';

void main() {
  group('Milestone — Constructor & Defaults', () {
    test('membuat milestone dengan semua field wajib', () {
      // ARRANGE
      final dueDate = DateTime(2026, 6, 30);

      // ACT
      final milestone = Milestone(
        id: 'm-1',
        title: 'Revisi BAB 1',
        chapter: 'BAB 1',
        description: 'Revisi feedback dosen',
        dueDate: dueDate,
      );

      // ASSERT
      expect(milestone.id, equals('m-1'));
      expect(milestone.title, equals('Revisi BAB 1'));
      expect(milestone.chapter, equals('BAB 1'));
      expect(milestone.description, equals('Revisi feedback dosen'));
      expect(milestone.dueDate, equals(dueDate));
    });

    test('status default-nya MilestoneStatus.todo', () {
      // ARRANGE & ACT
      final milestone = Milestone(
        id: 'm-1',
        title: 'Test',
        chapter: 'BAB 1',
        description: 'desc',
        dueDate: DateTime.now(),
      );

      // ASSERT
      expect(milestone.status, equals(MilestoneStatus.todo));
    });

    test('priority default-nya 2 (sedang)', () {
      // ARRANGE & ACT
      final milestone = Milestone(
        id: 'm-1',
        title: 'Test',
        chapter: 'BAB 1',
        description: 'desc',
        dueDate: DateTime.now(),
      );

      // ASSERT
      expect(milestone.priority, equals(2));
    });
  });

  group('Milestone — statusColor mapping', () {
    test('status done memberi warna hijau (#10B981)', () {
      // ARRANGE
      final milestone = _buildMilestone(status: MilestoneStatus.done);

      // ACT
      final color = milestone.statusColor;

      // ASSERT
      expect(color, equals(const Color(0xFF10B981)));
    });

    test('status inProgress memberi warna biru (#3B5BFE)', () {
      // ARRANGE
      final milestone = _buildMilestone(status: MilestoneStatus.inProgress);

      // ACT
      final color = milestone.statusColor;

      // ASSERT
      expect(color, equals(const Color(0xFF3B5BFE)));
    });

    test('status overdue memberi warna merah (#EF4444)', () {
      // ARRANGE
      final milestone = _buildMilestone(status: MilestoneStatus.overdue);

      // ACT
      final color = milestone.statusColor;

      // ASSERT
      expect(color, equals(const Color(0xFFEF4444)));
    });

    test('status todo memberi warna abu-abu (#6B7280)', () {
      // ARRANGE
      final milestone = _buildMilestone(status: MilestoneStatus.todo);

      // ACT
      final color = milestone.statusColor;

      // ASSERT
      expect(color, equals(const Color(0xFF6B7280)));
    });
  });

  group('Milestone — statusLabel mapping', () {
    test('status done → label "Selesai"', () {
      // ARRANGE
      final milestone = _buildMilestone(status: MilestoneStatus.done);

      // ACT
      final label = milestone.statusLabel;

      // ASSERT
      expect(label, equals('Selesai'));
    });

    test('status inProgress → label "Berjalan"', () {
      // ARRANGE
      final milestone = _buildMilestone(status: MilestoneStatus.inProgress);

      // ACT
      final label = milestone.statusLabel;

      // ASSERT
      expect(label, equals('Berjalan'));
    });

    test('status overdue → label "Lewat tenggat"', () {
      // ARRANGE
      final milestone = _buildMilestone(status: MilestoneStatus.overdue);

      // ACT
      final label = milestone.statusLabel;

      // ASSERT
      expect(label, equals('Lewat tenggat'));
    });

    test('status todo → label "Belum mulai"', () {
      // ARRANGE
      final milestone = _buildMilestone(status: MilestoneStatus.todo);

      // ACT
      final label = milestone.statusLabel;

      // ASSERT
      expect(label, equals('Belum mulai'));
    });
  });

  group('Milestone — Mutability', () {
    test('field title bisa diubah setelah konstruksi', () {
      // ARRANGE
      final milestone = _buildMilestone();

      // ACT
      milestone.title = 'Judul Baru';

      // ASSERT
      expect(milestone.title, equals('Judul Baru'));
    });

    test('field status bisa diubah setelah konstruksi', () {
      // ARRANGE
      final milestone = _buildMilestone(status: MilestoneStatus.todo);

      // ACT
      milestone.status = MilestoneStatus.done;

      // ASSERT
      expect(milestone.status, equals(MilestoneStatus.done));
      expect(milestone.statusLabel, equals('Selesai'));
    });
  });
}

// Helper: build milestone dummy untuk test.
Milestone _buildMilestone({MilestoneStatus status = MilestoneStatus.todo}) {
  return Milestone(
    id: 'test-id',
    title: 'Test Milestone',
    chapter: 'BAB 1',
    description: 'Description',
    dueDate: DateTime(2026, 12, 31),
    status: status,
  );
}
