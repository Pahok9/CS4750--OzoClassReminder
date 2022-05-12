import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'color_funct.dart';
import 'edit_page.dart';
import 'home_page.dart';
import 'main.dart';
import 'add_class_page.dart';
import 'course_info_page.dart';
import 'menu.dart';

class CourseInfoPage extends StatefulWidget {
  String courseName = "";
  String zoomID = "";
  String buildingAndRoom = "";
  String startTime = "";
  String endTime = "";
  String startDate = "";
  String endDate = "";
  String dayList = "";
  String classDay = "";

  CourseInfoPage(this.courseName, this.zoomID, this.buildingAndRoom,
      this.startTime, this.endTime, this.startDate, this.endDate,
      this.dayList);

  @override
  ViewCourseInfoPage createState() => ViewCourseInfoPage();
}

class MenuItems {
  static const List<MenuItem> itemsFirst = [
    edit,
    delete,
  ];

  static const edit = MenuItem(
    text: 'Edit',
    icon: Icons.edit,
  );

  static const delete = MenuItem(
    text: 'Delete',
    icon: Icons.delete,
  );
}

class ViewCourseInfoPage extends State<CourseInfoPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    daysFromWeek();
    print(widget.startTime + " " + widget.endTime + " " + widget.startDate + " " + widget.endDate);
    super.initState();
  }

  PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem(
    value: item,
    child: Row(
      children: [
        Icon(item.icon, color: Colors.black, size: 20),
        const SizedBox(width: 12),
        Text(item.text),
      ],
    )
  );

  void onSelected(BuildContext context, MenuItem item) {
    var u = user?.uid;
    switch(item) {
      case MenuItems.edit:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => EditPage(widget.courseName,
            widget.zoomID, widget.buildingAndRoom, widget.startDate, widget.endDate,
            widget.startTime, widget.endTime,  widget.dayList)),
        );
        break;
      case MenuItems.delete:
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return alert dialog object
            return AlertDialog(
              title: const Text("Deleting the reminder!"),
              actions: <Widget>[
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text("Delete"),
                  style: TextButton.styleFrom(
                      primary: Colors.red
                  ),
                  onPressed: () {
                    FirebaseFirestore.instance.collection("User/$u/Classes").doc(widget.courseName).delete().then(
                          (doc) => print("Document deleted"),
                      onError: (e) => print("Error updating document $e"),
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MainPage(title: '', index: 1)),
                    );
                  },
                ),
              ],
            );
          },
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Info'),
        actions: [
          PopupMenuButton<MenuItem>(
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              MenuItems.itemsFirst.map(buildItem).toList().first,
              MenuItems.itemsFirst.map(buildItem).toList().last,
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("74C69D"),
              hexStringToColor("52B788")
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter
          )
        ),
        child: Column(
          children: <Widget>[
            classInfo("Class", widget.courseName),
            classInfo("Zoom ID", widget.zoomID),
            classInfo("Location", widget.buildingAndRoom),
            classInfo("Time", widget.startTime.substring(0, 5) + " - " +
                widget.endTime.substring(0, 5)),
            classInfo("Date", correctedDateFormat()),
            classInfo("Day", widget.classDay),
          ],
        ),
      ),
    );
  }

  Padding classInfo(String str, String data) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 25, 15, 5),
      child: Container(
        child: Align(
          alignment: Alignment.topLeft,
          child:
          Padding(
            padding: EdgeInsets.all(15.0),
            child:
            Text(
              str + ": " + data,
              style: const TextStyle(color: Colors.black, fontSize: 18
              ),
            ),
          ),
        ), decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(
              width: 1.0,
              color: Colors.black54)),
      ),
    );
  }

  String correctedDateFormat() {
    String startYear = "-" +widget.startDate.substring(0, 4);
    String endYear = "-" + widget.endDate.substring(0, 4);
    String date = widget.startDate.substring(5, ) + startYear
        + " - " + widget.endDate.substring(5, ) + endYear;

    return date;
  }

  void daysFromWeek() {
    String temp = "";
    for(int j = 0; j < widget.dayList.length; j += 3) {
      temp = widget.dayList.substring(j, j+2);
      if(temp == "SU") {
        widget.classDay += "Sunday";
      } else if(temp == "MO") {
        widget.classDay += "Monday";
      } else if(temp == "TU") {
        widget.classDay += "Tuesday";
      } else if(temp == "WE") {
        widget.classDay += "Wednesday";
      } else if(temp == "TH") {
        widget.classDay += "Thursday";
      } else if(temp == "FR") {
        widget.classDay += "Friday";
      } else if(temp == "SA") {
        widget.classDay += "Saturday";
      }
      if(j+2 != widget.dayList.length) {
        widget.classDay += ", ";
      }
    }
  }

}

class Database {
  static deleteItem() {}
}
