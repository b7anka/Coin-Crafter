import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'LocalizationsManager.dart';

class AlertManager
{

  BuildContext context;
  LocalizationsManager l;

  AlertManager(this.context)
  {
    l = LocalizationsManager(context);
  }

  void showAlertInfoWithYesNoAction(String device, String title, String message)
  {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context){
            if( device == "android")
            {
              return AlertDialog(
                title: Wrap(
                  children: <Widget>[
                    Icon(Icons.warning, size: 35.0, color: Colors.yellow,),
                    Padding(padding: EdgeInsets.only(left: 10.0),),
                    Text(title)
                  ],
                ),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(l.translate("no_btn")),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text(l.translate("yes_btn")),
                    onPressed: (){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            }else {
              return CupertinoAlertDialog(
                title: Wrap(
                  children: <Widget>[
                    Icon(Icons.warning, size: 25.0, color: Colors.yellow,),
                    Padding(padding: EdgeInsets.only(left: 10.0),),
                    Text(title)
                  ],
                ),
                content: Text(message),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(l.translate("no_btn")),
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text(l.translate("yes_btn")),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            }
          }
        );
    }

  void showAlertInfoToAskWhereToChoosePictureWithCustomFunctions(String device, String title, String message, Function a, Function b)
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          if( device == "android")
          {
            return AlertDialog(
              title: Wrap(
                children: <Widget>[
                  Icon(Icons.info, size: 35.0, color: Colors.blue,),
                  Padding(padding: EdgeInsets.only(left: 10.0),),
                  Text(title)
                ],
              ),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: Text(l.translate("camera_btn")),
                  onPressed: () {
                    a();
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text(l.translate("gallery_btn")),
                  onPressed: (){
                    b();
                    Navigator.pop(context);
                  },
                )
              ],
            );
          }else {
            return CupertinoAlertDialog(
              title: Wrap(
                children: <Widget>[
                  Icon(Icons.info, size: 25.0, color: Colors.blue,),
                  Padding(padding: EdgeInsets.only(left: 10.0),),
                  Text(title)
                ],
              ),
              content: Text(message),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(l.translate("camera_btn")),
                  isDefaultAction: true,
                  onPressed: () {
                    a();
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: Text(l.translate("library_btn")),
                  onPressed: () {
                    b();
                    Navigator.pop(context);
                  },
                )
              ],
            );
          }
        }
    );
  }

  void showAlertWithCustomTitleContentIconAndOkAction(TargetPlatform source, String title, String content, IconData icon, Color iconColor, {String contentIOS})
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          if(source == TargetPlatform.iOS)
          {
            return CupertinoAlertDialog(
              title: Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  Icon(icon, size: 25.0, color: iconColor,),
                  Padding(padding: EdgeInsets.only(left: 10.0),),
                  Text(title)
                ],
              ),
              content: Text(contentIOS != null ? contentIOS : content),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(l.translate("ok_btn")),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                )
              ],
            );
          }
          else{
            return AlertDialog(
              title: Wrap(
                children: <Widget>[
                  Icon(icon, size: 35.0, color: iconColor,),
                  Padding(padding: EdgeInsets.only(left: 10.0),),
                  Text(title)
                ],
              ),
              content: Text(content),
              actions: <Widget>[
                FlatButton(
                  child: Text(l.translate("ok_btn")),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                )
              ],
            );
          }
        }
    );
  }

  void showErrorAlertWithCustomContentAndOkAction(TargetPlatform source, String content)
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          if(source == TargetPlatform.iOS)
          {
            return CupertinoAlertDialog(
              title: Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  Icon(Icons.error, size: 25.0, color: Colors.red,),
                  Padding(padding: EdgeInsets.only(left: 10.0),),
                  Text(l.translate("error_title"))
                ],
              ),
              content: Text(content),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(l.translate("ok_btn")),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                )
              ],
            );
          }
          else{
            return AlertDialog(
              title: Wrap(
                children: <Widget>[
                  Icon(Icons.error, size: 35.0, color: Colors.red,),
                  Padding(padding: EdgeInsets.only(left: 10.0),),
                  Text(l.translate("error_title"))
                ],
              ),
              content: Text(content),
              actions: <Widget>[
                FlatButton(
                  child: Text(l.translate("ok_btn")),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                )
              ],
            );
          }
        }
    );
  }

  void showNoInternetConnectionAvailable(TargetPlatform source)
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          if(source == TargetPlatform.iOS)
          {
            return CupertinoAlertDialog(
              title: Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  Icon(Icons.error, size: 25.0, color: Colors.red,),
                  Padding(padding: EdgeInsets.only(left: 10.0),),
                  Text(l.translate("error_title"))
                ],
              ),
              content: Text(l.translate("no_internet_connection_available")),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(l.translate("ok_btn")),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                )
              ],
            );
          }
          else{
            return AlertDialog(
              title: Wrap(
                children: <Widget>[
                  Icon(Icons.error, size: 35.0, color: Colors.red,),
                  Padding(padding: EdgeInsets.only(left: 10.0),),
                  Text(l.translate("error_title"))
                ],
              ),
              content: Text(l.translate("no_internet_connection_available")),
              actions: <Widget>[
                FlatButton(
                  child: Text(l.translate("ok_btn")),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                )
              ],
            );
          }
        }
    );
  }

  void showErrorAlertWithCustomContentAndActions(TargetPlatform source, String content, List<Widget> actions)
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          if(source == TargetPlatform.iOS)
          {
            return CupertinoAlertDialog(
              title: Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  Icon(Icons.error, size: 25.0, color: Colors.red,),
                  Padding(padding: EdgeInsets.only(left: 10.0),),
                  Text(l.translate("error_title"))
                ],
              ),
              content: Text(content),
              actions: actions,
            );
          }
          else{
            return AlertDialog(
              title: Wrap(
                children: <Widget>[
                  Icon(Icons.error, size: 35.0, color: Colors.red,),
                  Padding(padding: EdgeInsets.only(left: 10.0),),
                  Text(l.translate("error_title"))
                ],
              ),
              content: Text(content),
              actions: actions,
            );
          }
        }
    );
  }


  void showAlertWithCustomTitleContentIconAndActions(TargetPlatform source, String title, String content, IconData icon, Color iconColor, List<Widget> actions, List<Widget> iosActions, {String contentIOS})
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          if(source == TargetPlatform.iOS)
          {
            return CupertinoAlertDialog(
              title: Wrap(
                children: <Widget>[
                  Icon(icon, size: 25.0, color: iconColor,),
                  Padding(padding: EdgeInsets.only(left: 10.0),),
                  Text(title)
                ],
              ),
              content: Text(contentIOS != null ? contentIOS : content),
              actions: iosActions,
            );
          }
          else{
            return AlertDialog(
              title: Wrap(
                children: <Widget>[
                  Icon(icon, size: 35.0, color: iconColor,),
                  Padding(padding: EdgeInsets.only(left: 10.0),),
                  Text(title)
                ],
              ),
              content: Text(content),
              actions: actions,
            );
          }
        }
    );
  }

  void displaySnackBarWithCustomTitleMessageAndActions(String message, GlobalKey<ScaffoldState> key, {SnackBarAction action}){
    final snackBar = SnackBar(
        backgroundColor: Colors.red,
        action: action != null ? action : null,
        duration: Duration(seconds: 2),
        content: Container(
          height: 50.0,
          child: Center(
            child: Text(message, style: TextStyle(color: Colors.white, fontSize: 16.0),),
          )
        )
    );

    key.currentState.showSnackBar(snackBar);
  }
}