import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_app/providers/todo_provider.dart';
import 'package:track_app/view/daily_stats_view_model.dart';
import 'package:track_app/view/weekly_stats_view_model.dart';
import 'package:track_app/ui_feature/pie_chart.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();
    final scheme = Theme.of(context).colorScheme;

    final dailyVm = DailyStatsViewModel(todos: provider.todos);
    final weeklyVm = WeeklyStatsViewModel(weekCache: provider.weekCache);

    Widget statCard({
      required String title,
      required Widget child,
      Color? color,
    }) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color ?? scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      );
    }

    Widget metricTile(String label, String value, Color valueColor) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(label,
              style:
                  TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
        ],
      );
    }

    Widget divider() => Container(
          width: 1,
          height: 40,
          color: scheme.outlineVariant,
        );

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Stats'),
        backgroundColor: scheme.surface,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // ── Today's numbers ───────────────────────────────────────
            statCard(
              title: 'TODAY',
              color: scheme.primaryContainer,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  metricTile('Completed', '${dailyVm.done}', scheme.primary),
                  divider(),
                  metricTile('Remaining', '${dailyVm.pending}', scheme.error),
                  divider(),
                  metricTile('Total',
                      '${dailyVm.done + dailyVm.pending}', scheme.onSurface),
                ],
              ),
            ),

            // ── Today pie ─────────────────────────────────────────────
            statCard(
              title: "TODAY'S COMPLETION",
              child: SizedBox(
                // height: 160,
                child: StatsPieChart(
                  title: 'Today',
                  done: dailyVm.done,
                  pending: dailyVm.pending,
                  completionPercent: dailyVm.completionPercent,
                  centerLabel: dailyVm.centerLabel,
                  summaryLabel: dailyVm.summaryLabel,
                  hasData: dailyVm.hasData,
                ),
              ),
            ),

            // ── Weekly pie ────────────────────────────────────────────
            statCard(
              title: 'LAST 7 DAYS',
              color: scheme.tertiaryContainer,
              child: SizedBox(
                // height: 160,
                child: StatsPieChart(
                  title: 'Last 7 Days',
                  done: weeklyVm.done,
                  pending: weeklyVm.pending,
                  completionPercent: weeklyVm.completionPercent,
                  centerLabel: weeklyVm.centerLabel,
                  summaryLabel: weeklyVm.summaryLabel,
                  hasData: weeklyVm.hasData,
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}