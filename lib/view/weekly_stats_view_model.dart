// lib/viewmodels/weekly_stats_viewmodel.dart

import 'package:track_app/model/todo_model.dart';

class WeeklyStatsViewModel {
  final Map<String, List<Todo>> weekCache;

  const WeeklyStatsViewModel({required this.weekCache});

  // ── Flatten the whole week into one list ──────────────────────────
  List<Todo> get _allTodos =>
      weekCache.values.expand((list) => list).toList();

  // ── Counts ────────────────────────────────────────────────────────
  int get total   => _allTodos.length;
  int get done    => _allTodos.where((t) => t.isDone).length;
  int get pending => total - done;

  // ── Guard ─────────────────────────────────────────────────────────
  bool get hasData => total > 0;

  // ── Derived display values ────────────────────────────────────────
  double get completionPercent =>
      hasData ? (done / total) * 100 : 0;

  String get centerLabel =>
      '${completionPercent.toStringAsFixed(0)}%';

  String get summaryLabel => hasData
      ? '$done of $total tasks this week'
      : 'No data for this week';

  /// How many days out of 7 had at least one completed task.
  /// Useful if you ever want a streak counter below the chart.
  int get activeDays => weekCache.values
      .where((list) => list.any((t) => t.isDone))
      .length;
}