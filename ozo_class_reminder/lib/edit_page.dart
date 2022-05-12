import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'color_funct.dart';
import 'home_page.dart';


class EditPage extends StatefulWidget {
  String courseName = "";
  String zoomID = "";
  String buildingAndRoom = "";
  String startTime = "";
  String endTime = "";
  String startDate = "";
  String endDate = "";
  String dayList = "";

  EditPage(this.courseName, this.zoomID, this.buildingAndRoom,
      this.startDate, this.endDate, this.startTime, this.endTime,
      this.dayList);

  @override
  EditPageState createState() => EditPageState();
}

class EditPageState extends State<EditPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  TextEditingController startDateInput = TextEditingController();
  TextEditingController endDateInput = TextEditingController();
  TextEditingController startTimeInput = TextEditingController();
  TextEditingController endTimeInput = TextEditingController();

  TextEditingController courseNameController = TextEditingController();
  TextEditingController zoomIDController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  List<bool?> values = <bool?>[false, false, false, false, false, false, false];
  List<String> weekList = ["SU", "MO", "TU", "WE", "TH", "FR", "SA"];

  @override
  void initState(){
    courseNameController.text = widget.courseName;
    zoomIDController.text = widget.zoomID;
    locationController.text = widget.buildingAndRoom;
    startTimeInput.text = widget.startTime;
    endTimeInput.text = widget.endTime;
    startDateInput.text = widget.startDate;
    endDateInput.text = widget.endDate;
    dayToValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Updating class info"),
      ),
      body: Container(
        // decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //         colors: [
        //           hexStringToColor("74C69D"),
        //           hexStringToColor("52B788")
        //         ], begin: Alignment.topCenter, end: Alignment.bottomCenter
        //     )
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: courseNameController,
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Course Name',
                labelText: 'Course',
              ),
            ),
            TextField(
              controller: zoomIDController,
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Zoom ID',
              ),
            ),
            TextField(
              controller: locationController,
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Building and Room',
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: startDateInput, //editing controller of this TextField
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today), //icon of text field
                        labelText: "Start Date" //label text of field
                    ),
                    readOnly: true,  //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context, initialDate: DateTime.now(),
                          firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101)
                      );

                      if(pickedDate != null ){
                        print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          startDateInput.text = formattedDate; //set output date to TextField value.
                        });
                      }else{
                        print("Date is not selected");
                      }
                    },
                  ),
                ),
                Flexible(
                  child: TextField(
                    controller: endDateInput, //editing controller of this TextField
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today), //icon of text field
                        labelText: "End Date" //label text of field
                    ),
                    readOnly: true,  //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context, initialDate: DateTime.now(),
                          firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101)
                      );

                      if(pickedDate != null ){
                        print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          endDateInput.text = formattedDate; //set output date to TextField value.
                        });
                      }else{
                        print("Date is not selected");
                      }
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: startTimeInput, //editing controller of this TextField
                    decoration: const InputDecoration(
                        icon: Icon(Icons.timer), //icon of text field
                        labelText: "Start Time" //label text of field
                    ),
                    readOnly: true,  //set it true, so that user will not able to edit text
                    onTap: () async {
                      TimeOfDay? pickedTime =  await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );

                      if(pickedTime != null ){
                        print(pickedTime.format(context));   //output 10:51 PM
                        DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                        //converting to DateTime so that we can further format on different pattern.
                        print(parsedTime); //output 1970-01-01 22:53:00.000
                        String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
                        print(formattedTime); //output 14:59:00
                        //DateFormat() is from intl package, you can format the time on any pattern you need.

                        setState(() {
                          startTimeInput.text = formattedTime; //set the value of text field.
                        });
                      }else{
                        print("Time is not selected");
                      }
                    },
                  ),
                ),
                Flexible(
                  child: TextField(
                    controller: endTimeInput, //editing controller of this TextField
                    decoration: const InputDecoration(
                        icon: Icon(Icons.timer), //icon of text field
                        labelText: "End Time" //label text of field
                    ),
                    readOnly: true,  //set it true, so that user will not able to edit text
                    onTap: () async {
                      TimeOfDay? pickedTime =  await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );

                      if(pickedTime != null ){
                        print(pickedTime.format(context));   //output 10:51 PM
                        DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                        //converting to DateTime so that we can further format on different pattern.
                        print(parsedTime); //output 1970-01-01 22:53:00.000
                        String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
                        print(formattedTime); //output 14:59:00
                        //DateFormat() is from intl package, you can format the time on any pattern you need.

                        setState(() {
                          endTimeInput.text = formattedTime; //set the value of text field.
                        });
                      }else{
                        print("Time is not selected");
                      }
                    },
                  ),
                )
              ],
            ),
            WeekdaySelector(
              onChanged: (v) {
                setState(() {
                  values[v % 7] = !values[v % 7]!;
                });
              },
              values: values,
            ),
            ElevatedButton(
                onPressed: () {
                  var u = user?.uid;
                  FirebaseFirestore.instance.collection("User/$u/Classes").doc(
                      widget.courseName).delete().then((doc) =>
                      print("Document deleted"),
                    onError: (e) => print("Error updating document $e"),
                  );
                  updateData(courseNameController.text, zoomIDController.text,
                      locationController.text, startDateInput.text,
                      endDateInput.text, startTimeInput.text, endTimeInput.text,
                      valueToDay(values, weekList));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage(title: '', index: 1)),
                  );
                },
                child: const Text("Update")
            ),
          ],
        ),
      ),
    );
  }

  void dayToValue() {
    String temp = "";
    for(int i = 0; i < widget.dayList.length; i += 3) {
      temp = widget.dayList.substring(i, i+2);
      if(temp == "SU") {
        values[0] = true;
      } else if(temp == "MO") {
        values[1] = true;
      } else if(temp == "TU") {
        values[2] = true;
      } else if(temp == "WE") {
        values[3] = true;
      } else if(temp == "TH") {
        values[4] = true;
      } else if(temp == "FR") {
        values[5] = true;
      } else if(temp == "SA") {
        values[6] = true;
      }
    }
  }

  String valueToDay(List<bool?> v, List<String> weekList) {
    String temp = "";
    for(int i = 0; i < v.length; i++) {
      if(v[i] == true){
        temp += weekList[i] + ",";
      }
    }
    temp = temp.substring(0, temp.length-1);
    return temp;
  }

  void updateData(String className, String zoomID, String location,
      String startDate, String endDate, String startTime, String endTime,
      String weekList){
    var u = user?.uid;
    FirebaseFirestore.instance.collection("User/$u/Classes").doc(courseNameController.text).set(
        {
          "Class": className,
          "Zoom ID": zoomID,
          "Location": location,
          "Start Date": startDate,
          "End Date": endDate,
          "Start Time": startTime,
          "End Time": endTime,
          "Days": weekList,
        }
    ).then((value) {
      print("Successfully added the class");
    }).catchError((onError) {
      print("Failed to add. " + onError.toString());
    });
  }
}
