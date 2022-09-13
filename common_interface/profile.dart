import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/student_model.dart';
import '../models/user_model.dart';
import '../studeents_interface/HomeStudent.dart';
import '../studeents_interface/student_setting.dart';

class profile extends StatefulWidget {
  final String userId;
  const profile({Key key, this.userId}) : super(key: key);

  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {
  User user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  final firstNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>Home_page_student()));

          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => student_setting()));
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 700,
                      height: 150,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 10),
                            )
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/PF.jpg",
                            ),
                            fit: BoxFit.cover,
                          )),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Colors.grey[300],
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.indigo,
                          ),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 55,
              ),
              TextFormField(
                  autofocus: false,
                  controller: firstNameEditingController,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    RegExp regex = new RegExp(r'^.{3,}$');
                    if (value.isEmpty) {
                      return ("First Name cannot be Empty");
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Enter Valid name(Min. 3 Character)");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    firstNameEditingController.text = value;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle),
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "${loggedInUser.firstName}",
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )),
              SizedBox(
                height: 35,
              ),
              TextFormField(
                  autofocus: false,
                  controller: emailEditingController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty) {
                      return ("Please Enter Your Email");
                    }
                    // reg expression for email validation
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value)) {
                      return ("Please Enter a valid email");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    firstNameEditingController.text = value;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail),
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "${loggedInUser.email}",
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )),

              //buildTextField("ID","${loggedInUser.uid}"),
              // buildTextField("Name","${loggedInUser.firstName}"),
              // buildTextField("E-mail","${loggedInUser.email}"),
              SizedBox(
                height: 35,
              ),

              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(30),
                color: Colors.indigo,
                child: MaterialButton(
                    padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
                    minWidth: MediaQuery.of(context).size.width,
                    onPressed: () {
                      final docUser = FirebaseFirestore.instance
                          .collection('Students')
                          .doc(loggedInUser.uid);

                      docUser.update({
                        'firstName': firstNameEditingController.text,
                        'email': emailEditingController.text,
                      });

                      Fluttertoast.showToast(
                          msg: "Account Updated successfully :) ");
                    },
                    child: Text(
                      "Update",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
