import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'globals.dart' as globals;
import 'package:flutter/services.dart';
import 'package:flutter_application_1/page/firesbase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Agencia {
  String agencia;
  Agencia({required this.agencia});
  Map<String, dynamic> toJson() => {"agencia": agencia};
}

class ItemGastos {
  String item;
  String gasto;
  ItemGastos({required this.item, required this.gasto});
  Map<String, dynamic> toJson() => {"item": item, "gasto": gasto};
}

class Gastos extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GastosState();
  }
}

List<String> options = ['Todo', 'central', 'sucursal 1'];

class _GastosState extends State<Gastos> {
  bool editarItem = false;
  late TextEditingController controller;
  TextEditingController conceptoGastpField = TextEditingController();
  TextEditingController montodelGastoField = TextEditingController();
  double totalConsumo = 0;
  double descuento = 0;
  double _totalConsumo = 0;
  String currentOption = options[0];
  TextEditingController dateInput = TextEditingController();
  bool? check3 = false;
  int seleccionarOpcion = 1;
  List<ItemGastos> itemgastos = List.empty(growable: true);
  int selecetdIndex = -1;

  void showAlert(QuickAlertType quickAlertType) {
    QuickAlert.show(context: context, type: quickAlertType, width: 100);
  }

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
    controller = TextEditingController();
    conceptoGastpField.text = '';
    montodelGastoField.text = '';
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
            'Ingresar Gastos  -  Coffeina',
            style: TextStyle(color: Colors.black, fontSize: 20),
          )),
        ),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              TextField(
                controller: dateInput,
                //editing controller of this TextField
                decoration: InputDecoration(
                  isDense: true, // Added this
                  contentPadding: EdgeInsets.all(8),
                  icon: Icon(Icons.calendar_today), //icon of text field
                  labelText: "Ingrese Fecha",
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontSize: 15), //label text of field
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2100));

                  if (pickedDate != null) {
                    globals.formattedDateGlobalGasto = pickedDate;
                    print(
                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    globals.formattedDateGlobal = formattedDate;
                    print(
                        formattedDate); //formatted date output using intl package =>  2021-03-16

                    setState(() {
                      dateInput.text =
                          formattedDate; //set output date to TextField value.
                    });
                  } else {}
                },
              ),
              TextField(
                style: TextStyle(color: Colors.black, fontSize: 10),
                decoration: InputDecoration(
                    isDense: true, // Added this
                    contentPadding: EdgeInsets.all(8),
                    hintText: 'Fecha: ' + globals.formattedDateGlobal,
                    hintStyle: TextStyle(fontSize: 15),
                    enabled: false,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
              SizedBox(height: 10),
              TextField(
                style: TextStyle(fontSize: 15.0, height: 2.5),
                controller: conceptoGastpField,
                decoration: InputDecoration(
                    isDense: true, // Added this
                    contentPadding: EdgeInsets.all(8),
                    hintText: "Concepto del Gasto",
                    hintStyle: TextStyle(fontSize: 15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
              ),
              SizedBox(height: 10),
              TextField(
                style: TextStyle(fontSize: 15.0, height: 2.5),
                controller: montodelGastoField,
                decoration: InputDecoration(
                    isDense: true, // Added this
                    contentPadding: EdgeInsets.all(8),
                    hintText: "Monto del Gasto",
                    hintStyle: TextStyle(fontSize: 15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: ElevatedButton(
                        /*   style: ElevatedButton.styleFrom(
                            fixedSize: const Size(150, 35),
                            primary:
                                Colors.redAccent, //background color of button
                            side: BorderSide(
                                width: 1,
                                color: Colors.brown), //border width and color
                            elevation: 1, //elevation of button
                            shape: RoundedRectangleBorder(
                                //to set border radius to button
                                borderRadius: BorderRadius.circular(30)),
                            padding: EdgeInsets.all(
                                20) //content padding inside button
                            ),*/
                        onPressed: () {
                          print(conceptoGastpField.text);
                          print(montodelGastoField.text);
                          if (conceptoGastpField.text.isNotEmpty &&
                              montodelGastoField.text.isNotEmpty) {
                            setState(() {
                              if (editarItem == false) {
                                globals.gastoLista = [];
                                itemgastos.add(ItemGastos(
                                    item: conceptoGastpField.text,
                                    gasto: montodelGastoField.text));
                                globals.gastoLista = itemgastos;
                                print('itemgastos');
                                print(itemgastos.length);

                                String cantidad = montodelGastoField.text;

                                _totalConsumo =
                                    _totalConsumo + double.parse(cantidad);
                                conceptoGastpField.text = '';
                                montodelGastoField.text = '';
                              } else {
                                double costoOld = double.parse(
                                    itemgastos[selecetdIndex].gasto);
                                String itemName = conceptoGastpField.text;
                                String costoItem = montodelGastoField.text;
                                itemgastos[selecetdIndex].item = itemName;
                                itemgastos[selecetdIndex].gasto = costoItem;
                                selecetdIndex = -1;
                                editarItem = false;
                                _totalConsumo = _totalConsumo - costoOld;
                                _totalConsumo =
                                    _totalConsumo + double.parse(costoItem);
                                print('alee');
                                print(costoOld);
                                print(double.parse(costoItem));
                                conceptoGastpField.text = '';
                                montodelGastoField.text = '';
                              }
                            });
                          }
                        },
                        child: Text('Armar Boleta de Gastos')),
                  )
                ],
              ),
              SizedBox(height: 10),
              Text(
                '---> TOTAL EGRESOS: ${_totalConsumo.toStringAsFixed(2)} Bs.',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 20),
              itemgastos.length == 0
                  ? Text("Boleta de Gastos Vacia",
                      style: TextStyle(fontSize: 12))
                  : Expanded(
                      child: ListView.builder(
                      itemCount: itemgastos.length,
                      itemBuilder: (context, index) => getRow(index),
                    ))
            ],
          ),
        ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            tooltip: 'Agragar Gasto',
            child: Icon(Icons.add),
            onPressed: () {
              if (globals.gastoLista.isNotEmpty &&
                  conceptoGastpField.text.isEmpty &&
                  montodelGastoField.text.isEmpty &&
                  globals.formattedDateGlobal.isNotEmpty) {
                addGasto(globals.gastoLista, _totalConsumo,
                    globals.formattedDateGlobal, 'No Consolidado');
                _totalConsumo = 0;
                globals.gastoLista = [];
                conceptoGastpField.text = '';
                montodelGastoField.text = '';
                itemgastos.clear();
                itemgastos = [];
                showAlert(QuickAlertType.success);
              } else {
                showAlert(QuickAlertType.error);
              }
              setState(() {});
              /*   Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));*/
            },
          ),
          FloatingActionButton(
            tooltip: 'Vaciar Boleta',
            child: Icon(Icons.remove),
            onPressed: () {
              globals.gastoLista = [];
              conceptoGastpField.text = '';
              montodelGastoField.text = '';
              itemgastos.clear();
              itemgastos = [];
              _totalConsumo = 0;
              setState(() {});
              /*   Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));*/
            },
          ),
        ]));
  }

  Widget getRow(int index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              index % 2 == 0 ? Colors.deepPurpleAccent : Colors.purple,
          foregroundColor: Colors.white,
          child: Text(
            itemgastos[index].item[0],
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              itemgastos[index].item,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text('Gasto: ${itemgastos[index].gasto} Bs.',
                style: TextStyle(
                  fontSize: 15,
                )),
          ],
        ),
        trailing: SizedBox(
          width: 120,
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    conceptoGastpField.text = itemgastos[index].item;
                    montodelGastoField.text = itemgastos[index].gasto;
                    editarItem = true;
                    setState(() {
                      selecetdIndex = index;
                    });
                  },
                  child: Icon(Icons.edit)),
              InkWell(
                  onTap: (() {
                    setState(() {
                      _totalConsumo =
                          _totalConsumo - double.parse(itemgastos[index].gasto);
                      itemgastos.removeAt(index);
                    });
                  }),
                  child: Icon(Icons.delete)),
            ],
          ),
        ),
      ),
    );
  }
}
