import 'package:flutter/material.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import 'package:provider/provider.dart';
import 'package:track_app/providers/todo_provider.dart';
import 'package:track_app/screens/login_screen.dart';
import 'package:track_app/view/weekly_stats_view_model.dart';
import 'package:track_app/view/daily_stats_view_model.dart';
import 'package:track_app/ui_feature/pie_chart.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _StateHomeScreen();
}

/*
 objective now : 
 shift all the business logic to provider
*/

class _StateHomeScreen extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => context.read<TodoProvider>().getToDo(DateTime.now()),
    );
  }

  void _showAddDialog(BuildContext context) async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("New Task"),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: "Task title"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<TodoProvider>().addTodo(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();
    final scheme = Theme.of(context).colorScheme; // store once, use everywhere
    // Inside build(), after: final provider = context.watch<TodoProvider>();

    final dailyVm = DailyStatsViewModel(todos: provider.todos);
    final weeklyVm = WeeklyStatsViewModel(weekCache: provider.weekCache);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("To-DOist")),
        backgroundColor: scheme.surface,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddDialog(context),
          ),
        ],
      ),
      backgroundColor: scheme.surface,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // calendar
                Padding(
                  padding: EdgeInsetsGeometry.all(4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(7),
                      child: HorizontalWeekCalendar(
                        initialDate: DateTime.now(),
                        minDate: DateTime(DateTime.now().year - 1),
                        maxDate: DateTime(DateTime.now().year + 1),
                        activeBackgroundColor: scheme.primary,
                        inactiveBackgroundColor: scheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(14),
                        onDateChange: (value) {
                          context.read<TodoProvider>().changeSelectedDate(
                            value,
                          );
                          context.read<TodoProvider>().getToDo(value);
                        },
                      ),
                    ),
                  ),
                ),

                // placeholder stat cards
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.all(10),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.25 * 0.5,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                          color: scheme.secondaryContainer,
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
                        height: MediaQuery.of(context).size.height * 0.25 * 0.5,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                          color: scheme.tertiaryContainer,
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

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
                  },
                  child: Text("go back to login screen"),
                ),
              ],
            ),
          ),

          // draggable todo sheet
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.17,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLow,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    // drag handle
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        height: 5,
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          color: scheme.onSurfaceVariant.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    // heading
                    Padding(
                      padding: EdgeInsetsGeometry.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: scheme.primaryContainer,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Text(
                          "To-Do's",
                          style: TextStyle(color: scheme.onPrimaryContainer),
                        ),
                      ),
                    ),

                    // todo list — isLoading check is HERE, not inside itemBuilder
                    Expanded(
                      child: provider.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              controller: scrollController,
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
                                    onChanged: (_) => context
                                        .read<TodoProvider>()
                                        .toggleTodo(todo),
                                    activeColor: scheme.primary,
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: scheme.error,
                                    ),
                                    onPressed: () => context
                                        .read<TodoProvider>()
                                        .deleteTodo(todo),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
