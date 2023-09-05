import 'dart:convert';
import 'dart:io';
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
  List productos = [];
  late TextEditingController controller;
  TextEditingController palabraClaveController = TextEditingController();

  void showAlert(QuickAlertType quickAlertType) {
    QuickAlert.show(context: context, type: quickAlertType, width: 100);
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30.0),
        child: AppBar(
            title: Text(
          'Configuracion  -  Coffeina',
          style: TextStyle(color: Colors.black, fontSize: 10),
        )),
      ),
      body: Padding(
          padding: EdgeInsets.all(15),
          child: Column(children: [
            TextField(
              controller: palabraClaveController,
              obscureText: true,
              decoration: InputDecoration(
                  isDense: true, // Added this,
                  contentPadding: EdgeInsets.all(8),
                  hintText: 'Inserte Palabra Clave2.0',
                  hintStyle: TextStyle(fontSize: 10),
                  enabled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
            SizedBox(height: 10),
            ElevatedButton(
                /*  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(120, 37),
                    primary: Colors.redAccent, //background color of button
                    side: BorderSide(
                        width: 1, color: Colors.brown), //border width and color
                    elevation: 1, //elevation of button
                    shape: RoundedRectangleBorder(
                        //to set border radius to button
                        borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.all(20) //content padding inside button
                    ),*/
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
                child: Text(
                  'Confirmar',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                )),
            SizedBox(height: 10),
            ElevatedButton(
                /*  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(120, 37),
                    primary: Colors.redAccent, //background color of button
                    side: BorderSide(
                        width: 1, color: Colors.brown), //border width and color
                    elevation: 1, //elevation of button
                    shape: RoundedRectangleBorder(
                        //to set border radius to button
                        borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.all(20) //content padding inside button
                    ),*/
                onPressed: () {
                  globals.password = '';

                  showAlert(QuickAlertType.success);
                },
                child: Text(
                  'Restringir Acceso',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                )),
            SizedBox(height: 10),
            ElevatedButton(
                /*  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(120, 37),
                    primary: Colors.redAccent, //background color of button
                    side: BorderSide(
                        width: 1, color: Colors.brown), //border width and color
                    elevation: 1, //elevation of button
                    shape: RoundedRectangleBorder(
                        //to set border radius to button
                        borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.all(20) //content padding inside button
                    ),*/
                onPressed: () async {
                  if (palabraClaveController.text == 'patitoalejito') {
                    final String response = await rootBundle
                        .loadString('/coffeina-inventario.json');
                    final data = await json.decode(response);
                    setState(() {
                      productos = data;
                      int i = 1;
                      productos.forEach((element) {
                        addProductos(element['item'], element['cantidad'],
                            element['agencia'], element['precio'], i);
                        i++;
                        print(element['item']);
                      });
                    });
                  }
                },
                child: Text('cargar productos')),
          ])),
    );
  }
}
