import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ozo_class_reminder/widgets.dart';
import 'color_funct.dart';
import 'course_info_page.dart';
import 'add_class_page.dart';
import 'main.dart';

class CourseListPage extends StatefulWidget {

  @override
  ListViewPageState createState() => ListViewPageState();
}

class ListViewPageState extends State<CourseListPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  List<String> classList = <String>[];
  List<String> zoomID = <String>[];
  List<String> location = <String>[];
  List<String> startTime = <String>[];
  List<String> endTime = <String>[];
  List<String> startDate = <String>[];
  List<String> endDate = <String>[];
  List<String> daysList = <String>[];
  List<String> daysListToFullName = <String>[];
  String daysListString = "";

  ListViewPageState() {
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
            daysFromWeek();
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
          title: const Text("List of Classes"),
          automaticallyImplyLeading: false,
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
            children: [
              Expanded(
                child: ListView.builder(

                  padding: const EdgeInsets.all(8),
                  itemCount: classList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              CourseInfoPage(classList[index], zoomID[index],
                                  location[index], startTime[index],
                                  endTime[index], startDate[index],
                                  endDate[index], daysList[index]
                              ),
                        ));
                      },
                      title: Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.amber[500],
                          border: Border.all(color: Colors.black)
                        ),
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(classList[index]),
                        ),
                      ),
                      subtitle: Container(
                        alignment: Alignment.topLeft,
                        height: 25,
                        decoration: BoxDecoration(
                            color: Colors.amber[500],
                            border: Border.all(color: Colors.black54)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(daysListToFullName[index], textAlign: TextAlign.left,),
                              Text(startTime[index].substring(0,
                                    startTime[index].length-3) + " - " +
                                  endTime[index].substring(0,
                                    endTime[index].length-3),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ),
              )
            ],
          ),
        )
    );
  }

  void daysFromWeek() {
    String temp = "";
    for(int i = 0; i < daysList.length; i++) {
      for(int j = 0; j < daysList[i].length; j += 3) {
        temp = daysList[i].substring(j, j+2);
        if(temp == "SU") {
          daysListString += "S";
        } else if(temp == "MO") {
          daysListString += "M";
        } else if(temp == "TU") {
          daysListString += "T";
        } else if(temp == "WE") {
          daysListString += "W";
        } else if(temp == "TH") {
          daysListString += "Th";
        } else if(temp == "FR") {
          daysListString += "F";
        } else if(temp == "SA") {
          daysListString += "Sa";
        }
        if(j+2 != daysList[i].length) {
          daysListString += ", ";
        }
      }
      daysListToFullName.add(daysListString);
      daysListString = "";
    }
  }

}
