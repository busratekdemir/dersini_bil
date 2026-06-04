import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/progress_entry.dart';
import '../utils/app_colors.dart';

class ProgressChart extends StatelessWidget {
  const ProgressChart({super.key, required this.entries});

  final List<ProgressEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Center(child: Text('Grafik için henüz veri girilmedi.'));
    }

    return LineChart(
      LineChartData(
        minY: 0,
        gridData: const FlGridData(show: true),
        titlesData: const FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < entries.length; i++)
                FlSpot(i.toDouble(), entries[i].netScore),
            ],
            isCurved: true,
            color: AppColors.primary,
            barWidth: 3,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}
