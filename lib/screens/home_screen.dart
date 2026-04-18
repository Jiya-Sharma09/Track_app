import 'package:flutter/material.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import 'package:track_app/model/todo_list_model.dart';
import 'package:track_app/screens/login_screen.dart';
import 'package:track_app/service/api_service.dart';
import 'package:track_app/model/todo_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _StateHomeScreen();
}

class _StateHomeScreen extends State<HomeScreen> {
  ApiService service = ApiService();
  DateTime selectedDate = DateTime.now();
  ToDoList? finalToDoList;
  List<Todo> selectedDateTodo = [];
  bool isLoading = false;

  static const bool useDummyData = true;
  final List<Todo> dummyTodos = [
    Todo(id: '1', title: 'Buy groceries', isDone: false),
    Todo(id: '2', title: 'Morning workout', isDone: true),
    Todo(id: '3', title: 'Read 30 pages', isDone: false),
    Todo(id: '4', title: 'Team standup call', isDone: true),
    Todo(id: '5', title: 'Fix login screen bug', isDone: false),
  ];

  @override
  void initState() {
    super.initState();
    getToDo(DateTime.now());
  }

  void getToDo(DateTime dateHome) async {
    if (useDummyData) {
      setState(() {
        selectedDateTodo = dummyTodos;
      });
      return;
    }

    try {
      setState(() => isLoading = true);
      final toDoListTemp = await service.fetchTodoList(dateHome);
      final tasklistTemp = await service.fetchTodo(toDoListTemp.id);
      setState(() {
        finalToDoList = toDoListTemp;
        selectedDateTodo = tasklistTemp;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        finalToDoList = null;
        selectedDateTodo = [];
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void deleteToDo(Todo task) async {
    List<Todo> temp = List.from(selectedDateTodo);
    setState(() => selectedDateTodo.remove(task));

    bool ans = await service.deleteToDoService(task);
    if (!ans) {
      setState(() => selectedDateTodo = temp);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sorry, task could not be deleted. Try again.")),
      );
    }
  }

  Future<void> addToDo(String? task) async {
    Todo newTask = Todo(id: "temp", title: task ?? "", isDone: false);
    setState(() => selectedDateTodo.add(newTask));

    Todo? realTask = await service.addToDoService(newTask);
    if (realTask == null) {
      // api failed — roll back
      setState(() => selectedDateTodo.remove(newTask));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sorry! Could not add task. Try again.")),
      );
    } else {
      // api succeeded — replace temp task with real one
      setState(() {
        final index = selectedDateTodo.indexOf(newTask);
        selectedDateTodo[index] = realTask;
      });
    }
  }

  void toggleStatus(Todo task) async {
    setState(() => task.isDone = !task.isDone);

    bool ans = await service.toggleStatusService(task);
    if (!ans) {
      setState(() => task.isDone = !task.isDone);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sorry, could not update task status. Try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme; // store once, use everywhere

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("To-DOist")),
        backgroundColor: scheme.surface,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => addToDo("New Task"),
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
                          setState(() => selectedDate = value);
                          getToDo(value);
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
            minChildSize: 0.2,
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
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Text(
                          "To-Do's",
                          style: TextStyle(color: scheme.onPrimaryContainer),
                        ),
                      ),
                    ),

                    // todo list — isLoading check is HERE, not inside itemBuilder
                    isLoading
                        ? CircularProgressIndicator()
                        : Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: selectedDateTodo.length,
                              itemBuilder: (context, index) {
                                final todo = selectedDateTodo[index];
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
                                    onChanged: (_) => toggleStatus(todo),
                                    activeColor: scheme.primary,
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete_outline,
                                        color: scheme.error),
                                    onPressed: () => deleteToDo(todo),
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