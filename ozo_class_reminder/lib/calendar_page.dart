import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'main.dart';
import 'add_class_page.dart';
import 'course_info_page.dart';

class CalendarPage extends StatefulWidget {
  @override
  ViewCalendarPage createState() => ViewCalendarPage();
}

class ViewCalendarPage extends State<CalendarPage> {
  final User? user = FirebaseAuth.instance.currentUser;List<String> classList = <String>[];
  List<String> zoomID = <String>[];
  List<String> location = <String>[];
  List<String> startTime = <String>[];
  List<String> endTime = <String>[];
  List<String> startDate = <String>[];
  List<String> endDate = <String>[];
  List<String> daysList = <String>[];

  ViewCalendarPage() {
    var u = user?.uid;
    FirebaseFirestore.instance.collection("User/$u/Classes").get()
        .then((querySnapshot) {
      print("Successfully load all the students");
      querySnapshot.docs.forEach((element) {
        classList.add(element.data()['Class']);
        zoomID.add(element.data()['Zoom ID']);
        location.add(element.data()['Location']);
        startTime.add(element.data()['Start Time']);
        endTime.add(element.data()['End Time']);
        startDate.add(element.data()['Start Date']);
        endDate.add(element.data()['End Date']);
        daysList.add(element.data()['Days']);
      });
      setState(() {

      });
    }).catchError((onError) {
      print("Failed to load the data!");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: new AppDrawer(),
      appBar: AppBar(
        title: const Text('Calendar'),
        automaticallyImplyLeading: false,
      ),
      body: SfCalendar(
        view: CalendarView.week,
        dataSource: _getCalendarDataSource(),
      ),
    );
  }

  _AppointmentDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];
    for(int i = 0; i < classList.length; i++){
      if(!classList.isEmpty){
        appointments.add(Appointment(
            // startTime: DateTime.now().add(Duration(minutes: 28)),
            startTime: DateTime.parse(startDate[i] + " " + startTime[i]),
            // endTime: DateTime.now().add(Duration(hours: 1, minutes: 43)),
            endTime: DateTime.parse(startDate[i] + " " + endTime[i]),
            subject: classList[i],
            color: Colors.blue,
            recurrenceRule:
            'FREQ=WEEKLY;INTERVAL=1;BYDAY=${daysList[i]};UNTIL=${endDate[i]}'));
      }
    }
    return _AppointmentDataSource(appointments);
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
