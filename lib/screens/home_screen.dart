import 'package:flutter/material.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import 'package:track_app/model/todo_list_model.dart';
import 'package:track_app/screens/login_screen.dart';
import 'package:track_app/ui_feature/colors.dart';
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

  // dummy data :
  static const bool useDummyData =
      true; // toggle for switching between dummy and real api calls
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
    DateTime today = DateTime.now();
    // api call for today !
    getToDo(today);
  }

  void getToDo(DateTime dateHome) async {
    if (useDummyData) {
      setState(() {
        selectedDateTodo = dummyTodos;
      });
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // functions for optimistic UI :
  void deleteToDo(Todo task) async {
    List<Todo> temp = List.from(selectedDateTodo);
    setState(() {
      selectedDateTodo.remove(task);
    });
    // api call
    bool ans = await service.deleteToDoService(task);
    if (ans) {
      // do nothing
    } else {
      setState(() {
        selectedDateTodo = temp;
      });
      // show error :
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sorry, task could not be deleted. Try again.")),
      );
    }
  }

  void addToDo(Todo task) {}

  void toggleStatus(Todo task) async {
    setState(() {
      task.isDone = !task.isDone;
    });
    // task.isDone = !task.isDone;
    bool ans = await service.toggleStatusService(task);
    if (ans) {
    } else {
      setState(() {
        task.isDone = !task.isDone;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sorry, task could not change the status of the task. Try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("To-DOist")),
        backgroundColor: AppTheme.primary,
      ),
      backgroundColor: AppTheme.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              // calender :
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.all(4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight3,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(7),
                      child: HorizontalWeekCalendar(
                        initialDate: DateTime.now(),
                        minDate: DateTime(DateTime.now().year - 1),
                        maxDate: DateTime(DateTime.now().year + 1),
                        activeBackgroundColor: AppTheme.primaryDark1,
                        inactiveBackgroundColor: AppTheme.primaryLight1,
                        borderRadius: BorderRadius.circular(14),
                        onDateChange: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ),

                Row(
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.all(10),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.25 * 0.5,
                        width: MediaQuery.of(context).size.width * 0.45,
                        color: Color.fromARGB(255, 255, 182, 211),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          // border: BorderRadius.circular(8),
                          color: Color.fromARGB(255, 194, 223, 243),
                        ),
                        height: MediaQuery.of(context).size.height * 0.25 * 0.5,
                        width: MediaQuery.of(context).size.width * 0.45,
                      ),
                    ),
                  ],
                ),

                // drawer screen !
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

          // add draggable screen here :
          DraggableScrollableSheet(
            builder: (context, ScrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Column(
                  children: [
                    // handle:
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.grey800,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        height: 5,
                        width: MediaQuery.of(context).size.width * 0.5,
                      ),
                    ),

                    // heading :
                    Padding(
                      padding: EdgeInsetsGeometry.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        color: AppTheme.primary,
                        child: Text(
                          "To-Do's",
                          style: TextStyle(color: AppTheme.heading),
                        ),
                      ),
                    ),

                    // actual list using list view builder:
                    ListView.builder(
                      controller: ScrollController,

                      itemCount: selectedDateTodo.length,
                      itemBuilder: (context, index) {
                        return isLoading
                            ? CircularProgressIndicator()
                            : ListTile();
                      },
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
