
import 'package:face_net_authentication/common_interface/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common_interface/signup.dart';


import 'login.dart';

class home extends StatefulWidget {
  const home({Key key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 90,),
          SizedBox(height: 20,),
          Center(
         child: Container(
            child: Text(
              "SAMS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 50,
                color: Colors.blueGrey,
              ),
            ),
          )),
          SizedBox(height: 70,),
          Container(
            height: 250,
            width: 300,
            //margin: const EdgeInsets.only(right: 60,bottom:45,top:250,left: 60),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image:AssetImage(
                  "assets/logo.jpg",
                ),
              ),
            ),
          ),
          SizedBox(height: 70,),
          Container(
              width: size.width*0.8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 40),
                  color: Colors.indigo,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>LoginScreen()));
                    },
                    child:Text(
                      "SIGN IN",
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                    )
                ),
              ),
          ),
          SizedBox(height: 30,),
          Container(
            width: size.width*0.8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(29),
              child: FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 40),
                  color: Colors.grey[200],
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>RegistrationScreen()));
                  },
                  child:Text(
                    "SIGN UP",
                    style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold),
                  )
              ),
            ),
          ),


        ],
      ),
    );
  }
}
