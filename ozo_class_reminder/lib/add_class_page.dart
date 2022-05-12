import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'color_funct.dart';
import 'home_page.dart';


class AddClassPage extends StatefulWidget {
  @override
  AddClassPageState createState() => AddClassPageState();
}

class AddClassPageState extends State<AddClassPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  TextEditingController startDateInput = TextEditingController();
  TextEditingController endDateInput = TextEditingController();
  TextEditingController startTimeInput = TextEditingController();
  TextEditingController endTimeInput = TextEditingController();

  TextEditingController courseNameController = TextEditingController();
  TextEditingController zoomIDController = TextEditingController();
  TextEditingController buildingAndTimeController = TextEditingController();

  TextEditingController daysSelectedController = TextEditingController();

  final values = <bool?>[false, false, false, false, false, false, false];
  List<String> weekList = ["SU", "MO", "TU", "WE", "TH", "FR", "SA"];

  @override
  void initState(){
    startDateInput.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adding a Class"),
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
              controller: buildingAndTimeController,
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
                  insertData(courseNameController.text, zoomIDController.text,
                      buildingAndTimeController.text, startDateInput.text,
                      endDateInput.text, startTimeInput.text, endTimeInput.text,
                      valueToDay(values, weekList));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage(title: '', index: 1)),
                  );
                },
                child: const Text("Submit")
            ),
          ],
        ),
      ),
    );
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

  void insertData(String className, String zoomID, String location,
      String startDate, String endDate, String startTime, String endTime,
      String weekList){
    var u = user?.uid;
    final CollectionReference postsRef = FirebaseFirestore.instance.collection("Classes");
    FirebaseFirestore.instance.collection("User/$u/Classes").doc(courseNameController.text).set(
      {
        "Class": courseNameController.text,
        "Zoom ID": zoomIDController.text,
        "Location": buildingAndTimeController.text,
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
