import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/page/printDoc.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'globals.dart' as globals;
import 'package:flutter/services.dart';
import 'package:flutter_application_1/page/firesbase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Config extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ConfigState();
  }
}

List<String> options = ['Todo', 'central', 'sucursal 1'];

class _ConfigState extends State<Config> {
  late TextEditingController controller;
  TextEditingController palabraClaveController = TextEditingController();

  void showAlert(QuickAlertType quickAlertType) {
    QuickAlert.show(context: context, type: quickAlertType);
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Configuracion  -  Coffeina')),
        body: Padding(
            padding: EdgeInsets.all(15),
            child: Column(children: [
              TextField(
                controller: palabraClaveController,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Inserte Palabra Clave',
                    enabled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    if (palabraClaveController.text.isNotEmpty) {
                      if (palabraClaveController.text == 'patitoalejo') {
                        globals.password = 'patitoalejo';
                        showAlert(QuickAlertType.success);
                        //       Navigator.pop(context);
                      } else {
                        showAlert(QuickAlertType.error);
                        globals.password = '';
                      }
                      palabraClaveController.text = '';
                    } else {
                      showAlert(QuickAlertType.error);
                    }
                  },
                  child: Text('Confirmar')),
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    globals.password = '';

                    showAlert(QuickAlertType.success);
                  },
                  child: Text('Restringir Acceso')),
            ])));
  }
}
