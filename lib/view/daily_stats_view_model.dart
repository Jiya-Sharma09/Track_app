// lib/viewmodels/daily_stats_viewmodel.dart

import 'package:track_app/model/todo_model.dart';

class DailyStatsViewModel {
  final List<Todo> todos;

  const DailyStatsViewModel({required this.todos});

  // ── Counts ────────────────────────────────────────────────────────
  int get total   => todos.length;
  int get done    => todos.where((t) => t.isDone).length;
  int get pending => total - done;

  // ── Guard ─────────────────────────────────────────────────────────
  bool get hasData => total > 0;

  // ── Derived display values ────────────────────────────────────────
  double get completionPercent =>
      hasData ? (done / total) * 100 : 0;

  /// Human-readable label for the center of the pie.
  /// Returns "All done!" instead of "100%" as a small UX touch.
  String get centerLabel =>
      done == total && hasData ? 'All done!' : '${completionPercent.toStringAsFixed(0)}%';

  /// Subtitle shown below the chart card.
  String get summaryLabel => hasData
      ? '$done of $total tasks completed'
      : 'No tasks for today';
}