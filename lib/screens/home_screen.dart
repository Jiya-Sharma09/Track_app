import 'package:flutter/material.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import 'package:provider/provider.dart';
import 'package:track_app/providers/todo_provider.dart';
// import 'package:track_app/screens/login_screen.dart';
import 'package:track_app/view/weekly_stats_view_model.dart';
import 'package:track_app/view/daily_stats_view_model.dart';
import 'package:track_app/ui_feature/pie_chart.dart';

class _AddTaskDialog extends StatefulWidget {
  const _AddTaskDialog();

  @override
  State<_AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<_AddTaskDialog> {
  // Controller lives here → disposed in dispose() → called AFTER pop animation
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose(); // ✅ Safe: widget is fully gone from the tree
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<TodoProvider>().addTodo(text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Task'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Task title'),
        // Let the user submit by pressing Enter on a keyboard
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _StateHomeScreen();
}

class _StateHomeScreen extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => context.read<TodoProvider>().getToDo(DateTime.now()),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => const _AddTaskDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();
    final scheme = Theme.of(context).colorScheme;

    final dailyVm = DailyStatsViewModel(todos: provider.todos);
    final weeklyVm = WeeklyStatsViewModel(weekCache: provider.weekCache);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("To-DOist")),
        backgroundColor: scheme.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddDialog(context),
          ),
        ],
      ),
      backgroundColor: scheme.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Calendar ─────────────────────────────────────────────
            Padding(
              padding: EdgeInsetsGeometry.all(4),
              child: Container(
                decoration: BoxDecoration(
                  color: scheme.primaryFixedDim,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: EdgeInsetsGeometry.all(10),
                  child: HorizontalWeekCalendar(
                    initialDate: DateTime.now(),
                    minDate: DateTime(DateTime.now().year - 1),
                    maxDate: DateTime(DateTime.now().year + 1),
                    activeBackgroundColor: scheme.primary,
                    inactiveBackgroundColor: scheme.primaryFixed,
                    borderRadius: BorderRadius.circular(14),
                    onDateChange: (value) {
                      context.read<TodoProvider>().changeSelectedDate(value);
                      context.read<TodoProvider>().getToDo(value);
                    },
                  ),
                ),
              ),
            ),

            // ── Stat cards ───────────────────────────────────────────
            // ── Stat cards ───────────────────────────────────────────
Row(
  children: [
    Padding(
      padding: EdgeInsetsGeometry.all(10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.25 * 0.85,
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              scheme.onPrimaryFixedVariant,        // ← changed
              scheme.primary,
              scheme.primaryFixedDim,  // ← changed
              scheme.primaryContainer, 
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
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
    Padding(
      padding: EdgeInsetsGeometry.all(10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.25 * 0.85,
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              // scheme.onTertiaryFixedVariant,        // ← changed
              scheme.tertiary,
              scheme.tertiaryFixedDim,  // ← changed
              scheme.tertiaryContainer,      // ← changed
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
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
  ],
),
            // ── To-Do's heading ──────────────────────────────────────
            Padding(
              padding: EdgeInsetsGeometry.all(0),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    // color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  // padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text(
                    "To-Do's",
                    style: TextStyle(color: scheme.onPrimaryContainer, fontSize: 27,fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),

            // ── Todo list ────────────────────────────────────────────
            provider.isLoading
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      decoration: BoxDecoration(
                        color: scheme.secondaryFixed
                        , 
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: ListView.builder(
                        // must disable ListView's own scrolling since it lives
                        // inside a SingleChildScrollView
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: provider.todos.length,
                        itemBuilder: (context, index) {
                          final todo = provider.todos[index];
                          return ListTile(
                            title: Text(
                              todo.title,
                              style: TextStyle(
                                color: scheme.onSurface,
                                decoration: todo.isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            leading: Checkbox(
                              value: todo.isDone,
                              onChanged: (_) =>
                                  context.read<TodoProvider>().toggleTodo(todo),
                              activeColor: scheme.primary,
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: scheme.error,
                              ),
                              onPressed: () =>
                                  context.read<TodoProvider>().deleteTodo(todo),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
