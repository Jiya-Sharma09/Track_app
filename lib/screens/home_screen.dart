import 'package:flutter/material.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import 'package:track_app/screens/login_screen.dart';
import 'package:track_app/ui_feature/colors.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _StateHomeScreen();
}

class _StateHomeScreen extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("To-DOist")),
        backgroundColor: AppTheme.primary,
      ),
      backgroundColor: AppTheme.white,
      body: SingleChildScrollView(
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
    );
  }
}
