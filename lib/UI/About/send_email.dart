import 'dart:io';
import 'package:currency_convertor/UI/Helpers/AlertManager.dart';
import 'package:currency_convertor/UI/Helpers/Constants.dart';
import 'package:currency_convertor/UI/Helpers/LocalizationsManager.dart';
import 'package:currency_convertor/UI/Helpers/UserInputValidationManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class SendEmail extends StatefulWidget {
  BuildContext context;

  SendEmail(this.context);

  @override
  _SendEmailState createState() => _SendEmailState(context);
}

class _SendEmailState extends State<SendEmail> {
  BuildContext context;
  LocalizationsManager l;

  final _nameController = TextEditingController();
  final _messageController = TextEditingController();
  AlertManager alertManager;
  UserInputValidationManager validator = UserInputValidationManager();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _SendEmailState(this.context) {
    l = LocalizationsManager(context);
    alertManager = AlertManager(context);
  }

  void _resetFields() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _nameController.clear());
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _messageController.clear());
    setState(() {
      _formKey = GlobalKey<FormState>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: Platform.isAndroid
              ? BackButton(
            color: Colors.white,
          )
              : GestureDetector(
            child: Row(
              children: <Widget>[
                Icon(CupertinoIcons.back, color: Colors.white),
                Text(
                  l.translate("back_title"),
                  style: TextStyle(color: Colors.white, fontSize: 11.0),
                )
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          brightness: Brightness.dark,
          title: Text(l.translate("send_mail_title"),
              style: TextStyle(color: Colors.white, fontSize: 25.0)),
          centerTitle: true,
          backgroundColor: Colors.amber,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _getTextFields(),
                          ),
                        )
                      )
                )
        )
    );
  }

  List<Widget> _getTextFields() {

    Widget _iosClearButton = Platform.isIOS ? Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 5.0, bottom: 15.0),
            child: CupertinoButton(
              color: Colors.amber,
              child: Text(
                l.translate("clear_btn"),
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () {
                _resetFields();
              },
            ),
          ),
        )
      ],
    ) : Container();

    return [
      ListTile(
        leading: Icon(Icons.person, color: Colors.white,),
        title: TextFormField(
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
              labelText: l.translate("name_title"),
              labelStyle: TextStyle(color: Colors.amber),
              border: OutlineInputBorder()),
          controller: _nameController,
          validator: (text) {
            if (text.trim().isEmpty) {
              return l.translate("fill_this_field");
            } else if (!validator.isNameValid(text)) {
              return l.translate("name_not_valid");
            } else {
              return null;
            }
          },
        ),
        trailing: Icon(
          Icons.fiber_manual_record,
          color: Colors.red,
        ),
      ),
      ListTile(
        leading: Icon(Icons.message, color: Colors.white,),
        title: TextFormField(
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          maxLines: 10,
          minLines: 10,
          decoration: InputDecoration(
              labelText: l.translate("message_title"),
              labelStyle: TextStyle(color: Colors.amber),
              border: OutlineInputBorder()),
          controller: _messageController,
          validator: (text) {
            if (text.trim().isEmpty) {
              return l.translate("fill_this_field");
            } else {
              return null;
            }
          },
        ),
        trailing: Icon(
          Icons.fiber_manual_record,
          color: Colors.red,
        ),
      ),
      Platform.isAndroid ?
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(30.0, 15.0, 5.0, 15.0),
              child:  RaisedButton(
                color: Colors.amber,
                child: Text(
                  l.translate("send_btn").toUpperCase(),
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                onPressed: () {
                  _validateFields();
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0, right: 30.0),
              child: RaisedButton(
                color: Colors.amber,
                child: Text(
                  l.translate("clear_btn").toUpperCase(),
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                onPressed: () {
                  _resetFields();
                },
              ),
            ),
          )
        ],
      ) :
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0, bottom: 0.0),
              child: CupertinoButton(
                color: Colors.amber,
                child: Text(
                  l.translate("send_btn"),
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: () {
                  _validateFields();
                },
              ),
            ),
          ),
        ],
      ),
      _iosClearButton,
      Padding(padding: EdgeInsets.only(top: 60.0),)
    ];
  }

  void _validateFields() {
    if (_formKey.currentState.validate()) {
      Navigator.pop(context);
      launch(
          "mailto:${Constants.DEVELOPER_EMAIL}?subject=New%20messsage%20from%20${_nameController.text}%20-%20app%20CoinCrafter&body=${_messageController.text}");
    }
  }
}
