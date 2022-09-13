import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



import 'home.dart';
import 'login.dart';

class VerifyEmailPage extends StatefulWidget {
  final String userId;
  const VerifyEmailPage({Key key, this.userId}) : super(key: key);

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified=false;
  Timer timer;
  bool canResendEmail = false;
  final user = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance;




  @override
  void initState(){
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser.emailVerified;
    if(!isEmailVerified){

      sendVerficationEmail();
      timer=Timer.periodic(
        Duration(seconds: 3),
          (_)=>checkEmailVerified(),
      );
    }
  }
  @override
  void dispose()
  {
    timer?.cancel();
    super.dispose();
  }

  Future sendVerficationEmail() async{
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail=true);
    } catch (e)
    {
      showSnackBar(e.toString(),
          Duration(milliseconds: 400));
    }
  }
  Future checkEmailVerified() async{

    await FirebaseAuth.instance.currentUser.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser.emailVerified;
    });

    if(isEmailVerified) timer?.cancel();
  }
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  @override
  Widget build(BuildContext context) => isEmailVerified
      ?LoginScreen(userId:user.uid)
      :Scaffold(
        appBar:AppBar(
      iconTheme: IconThemeData(color: Colors.transparent),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0.3,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.indigo),
        onPressed: () {
          // passing this to our root
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>LoginScreen()));
        },
      ),
    ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'A verification email has been sent to your email.',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24,),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
                  onPressed: canResendEmail ? sendVerficationEmail :null,
                  icon: Icon(Icons.email,size: 32,),
                  label: Text(
                    'Resent Email',
                    style: TextStyle(fontSize: 24),
                  )
              ),
              SizedBox(height: 8,),
              TextButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  onPressed:() => home(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 24),
                  )
              ),
            ],
          ),
        ),



       );




  }

