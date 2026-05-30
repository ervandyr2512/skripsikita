import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../viewmodels/wellness_viewmodel.dart';

class MoodHistoryScreen extends StatelessWidget {
  const MoodHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = context.watch<WellnessViewModel>().moodHistory;
    final sortedLogs = [...logs]..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
    final last14 = sortedLogs.length > 14 ? sortedLogs.sublist(sortedLogs.length - 14) : sortedLogs;

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Mood')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tren Mood',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        minY: 0,
                        maxY: 5,
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 1,
                          getDrawingHorizontalLine: (_) => FlLine(
                            color: AppColors.divider,
                            strokeWidth: 1,
                            dashArray: const [4, 4],
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              interval: 1,
                              getTitlesWidget: (val, meta) {
                                if (val == 0 || val == 5) return const SizedBox.shrink();
                                return Text(
                                  val.toInt().toString(),
                                  style: const TextStyle(fontSize: 10, color: AppColors.textHint),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              interval: 2,
                              getTitlesWidget: (val, meta) {
                                final idx = val.toInt();
                                if (idx < 0 || idx >= last14.length) return const SizedBox.shrink();
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    DateFormat('d/M').format(last14[idx].loggedAt),
                                    style: const TextStyle(fontSize: 10, color: AppColors.textHint),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(
                              last14.length,
                              (i) => FlSpot(i.toDouble(), last14[i].score.toDouble()),
                            ),
                            isCurved: true,
                            color: AppColors.primary,
                            barWidth: 3,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, idx) {
                                return FlDotCirclePainter(
                                  radius: 4,
                                  color: AppColors.primary,
                                  strokeWidth: 2,
                                  strokeColor: Colors.white,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.primary.withValues(alpha: 0.2),
                                  AppColors.primary.withValues(alpha: 0.02),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Catatan Mood',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          ...sortedLogs.reversed.map((log) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(log.emoji, style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                  title: Text(
                    log.label,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  subtitle: Text(
                    DateFormat('EEEE, d MMM • HH:mm', 'id_ID').format(log.loggedAt),
                    style: const TextStyle(fontSize: 11),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${log.score}/5',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
