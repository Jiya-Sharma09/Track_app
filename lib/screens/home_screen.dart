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

  @override
  void initState() {
    super.initState();
    DateTime today = DateTime.now();
    // api call for today !
    getToDo(today);
  }

  void getToDo(DateTime dateHome) async {
    try {
      final _ToDoListTemp = await service.fetchTodoList(dateHome);
      final _tasklistTemp = await service.fetchTodo(_ToDoListTemp.id);
      setState(() {
        finalToDoList = _ToDoListTemp;
        selectedDateTodo = _tasklistTemp;
      });
    } catch (e) {
      setState(() {
        finalToDoList = null;
        selectedDateTodo = [];
      });
      throw ScaffoldMessenger(child: SnackBar(content: Text("Error : $e")));
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
        ],
      ),
    );
  }
}
