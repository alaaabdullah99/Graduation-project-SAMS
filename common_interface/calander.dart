import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../instructor_interface/instructor_menu.dart';
import '../models/instructor_model.dart';
import '../models/student_model.dart';
import '../models/user_model.dart';
import 'event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
class calander extends StatefulWidget {

  final String userId;
  const calander({Key key, this.userId}) : super(key: key);

  @override
  _calanderState createState() => _calanderState();
}

class _calanderState extends State<calander> {

  User user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();


  var dataFromFirebase;

  List todos = List.empty();
  String title = "";
  String description = "";
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    selectedEvent = {};
    _events = {};
    todos = ["Hello", "Hey There"];
  }

  createToDo() {
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection("Events").doc(title);

    Map<String, dynamic> todoList = {
      "Title": title,
      "Desc": description,
      "dateTime":Timestamp.fromDate(selectDay),
      "id":loggedInUser.uid,

    };

    documentReference
        .set(todoList)
        .whenComplete(() => print("Data stored successfully"));
  }

  deleteTodo(item) {

    DocumentReference documentReference =
    FirebaseFirestore.instance.collection("Events").doc(item);

    documentReference.delete().whenComplete(() => print("deleted successfully"));
  }

   Map<DateTime, List<Event>> selectedEvent;
   Map<DateTime, List<dynamic>> _events;
  CalendarFormat formart = CalendarFormat.twoWeeks;
  DateTime selectDay = DateTime.now();
  DateTime foucsedDay = DateTime.now();
  TextEditingController _eventController = TextEditingController();

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }
  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvent[date] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.3,
        actions: [
        ],
      ),
      drawer: menu_ins(),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: selectDay,
            firstDay: DateTime(2022),
            lastDay: DateTime(2050),
            calendarFormat: formart,
            onFormatChanged: (CalendarFormat _format) {
              setState(() {
                formart = _format;
              });
            },

            startingDayOfWeek: StartingDayOfWeek.sunday,
            daysOfWeekVisible: true,
            // day change
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                selectDay = selectedDay;
                foucsedDay = focusedDay;
              });

              print(foucsedDay);
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectDay, date);
            },
            eventLoader: _getEventsfromDay,

            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: Colors.indigo,
                shape: BoxShape.circle,
              ),
            ),

            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(5.0),
              ),
              formatButtonTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ..._getEventsfromDay(selectDay).map((Event event) => ListTile(
                title: Text(event.title),
              )),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("Events").where('id', isEqualTo: loggedInUser.uid).where('dateTime', isEqualTo: Timestamp.fromDate(selectDay)).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              } else if (snapshot.hasData || snapshot.data != null) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      QueryDocumentSnapshot<Object> documentSnapshot =
                      snapshot.data?.docs[index];
                      return Dismissible(
                          key: Key(index.toString()),
                          child: Card(
                            elevation: 4,
                            child: ListTile(
                              title: Text((documentSnapshot != null) ? (documentSnapshot["Title"]) : ""),
                              subtitle: Text((documentSnapshot != null)
                                  ? ((documentSnapshot["Desc"] != null)
                                  ? documentSnapshot["Desc"]
                                  : "")
                                  : ""),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  setState(() {
                                    //todos.removeAt(index);
                                    deleteTodo((documentSnapshot != null) ? (documentSnapshot["Title"]) : "");
                                  });
                                },
                              ),
                            ),
                          ));
                    });
              }
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.red,
                  ),
                ),
              );
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: const Text("Add Event"),
                  content: Container(
                    width: 400,
                    height: 140,
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter a title',
                          ),

                          onChanged: (String value) {
                            title = value;
                          },
                        ),
                        SizedBox(height: 10,),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter a description',
                          ),
                          onChanged: (String value) {
                            description = value;
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          setState(() {
                            //todos.add(title);
                            createToDo();
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text("Add"))
                  ],
                );
              });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );

  }
}
