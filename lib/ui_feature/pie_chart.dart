// lib/widgets/stats_pie_chart.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatsPieChart extends StatelessWidget {
  final String title;
  final int done;
  final int pending;
  final double completionPercent;
  final String centerLabel;   // ← new
  final String summaryLabel;  // ← new
  final bool hasData;

  const StatsPieChart({
    super.key,
    required this.title,
    required this.done,
    required this.pending,
    required this.completionPercent,
    required this.centerLabel,
    required this.summaryLabel,
    required this.hasData,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Card title (e.g. "Today" / "Last 7 Days") ──────────────
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w800,
                  fontSize: 16
                ),
          ),
          const SizedBox(height: 8),

          // ── Pie chart or empty state ────────────────────────────────
          SizedBox(
            height: 90,
            child: hasData
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 28,
                          sections: [
                            PieChartSectionData(
                              value: done.toDouble(),
                              color: Color.fromARGB(255, 2, 81, 43),
                              radius: 18,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              value: pending.toDouble(),
                              color: scheme.outlineVariant,
                              radius: 14,
                              showTitle: false,
                            ),
                          ],
                        ),
                      ),
                      // ── Center label (% or "All done!") ────────────
                      Text(
                        centerLabel,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(
                              color: scheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      'No data',
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                  ),
          ),
          const SizedBox(height: 8),

          // ── Legend ─────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot(color: Color.fromARGB(255, 2, 81, 43),        label: '$done done'),
              const SizedBox(width: 10),
              _LegendDot(color: scheme.outlineVariant, label: '$pending left'),
            ],
          ),
          const SizedBox(height: 6),

          // ── Summary line (e.g. "3 of 5 tasks completed") ───────────
          Text(
            summaryLabel,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.onSurface.withOpacity(0.85),
                ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85),
              ),
        ),
      ],
    );
  }
}