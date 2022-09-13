import 'package:commons/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:commons/commons.dart';




class ShowToast extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Show Toast on Flutter"),
          backgroundColor: Colors.redAccent,
        ),
        body: Container(
          height: 150,
          alignment: Alignment.center, //align content to center
          padding: EdgeInsets.all(20),
          child:RaisedButton(
            onPressed: (){
              showMessage(context);
            },
            colorBrightness: Brightness.dark, //background color is dark
            color: Colors.redAccent, //set background color is redAccent
            child: Text("Show Toast Message"),
          ),
        )
    );
  }

  //create this function, so that, you needn't to configure toast every time
  void showToastMessage(BuildContext context){
    Fluttertoast.showToast(
      msg: "User with this email doesn't exist.", //message to show toast
      toastLength: Toast.LENGTH_LONG, //duration for message to show
      //backgroundColor: Colors.red, //background Color for message
    );

  }
  void showMessage(BuildContext context){
    confirmationDialog(
        context,
        "Are you sure to delete this section ?",
        positiveText: "Delete",
        positiveAction: () { }
    );
  }

}