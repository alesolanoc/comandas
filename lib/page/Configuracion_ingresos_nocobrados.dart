import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:js_interop';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/page/printDoc.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'globals.dart' as globals;
import 'package:flutter/services.dart';
import 'package:flutter_application_1/page/firesbase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<DateTime> days = [];
List<DateTime> days1 = [];

List ventas = [];
List totalConsumos = [];
List<FlSpot> example = [];

class Agencia {
  String agencia;
  Agencia({required this.agencia});
  Map<String, dynamic> toJson() => {"agencia": agencia};
}

class Configuracion1 extends StatefulWidget {
  @override
  _Configuracion1State createState() => _Configuracion1State();
}

class _Configuracion1State extends State<Configuracion1> {
  List<Agencia> agencia = List.empty(growable: true);
  List newAgenciaList = [];
  TextEditingController dateInputFinal = TextEditingController();
  TextEditingController dateInputInicial = TextEditingController();
  int? fechaIni;
  int? fechaFin;
  int? dias;
  bool loading = true;
  bool check3 = false;

  void showAlert(QuickAlertType quickAlertType) {
    QuickAlert.show(context: context, type: quickAlertType, width: 100);
  }

  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }

    return days;
  }

  Future<List> getDaysInBetween1(
      String agenciaParaVer, DateTime startDate, DateTime endDate) async {
    List days = [];
    DateTime temp;
    double totalPrices = 0;
    loading = false;

    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      temp = startDate.add(Duration(days: i));
      String formattedDate = DateFormat('yyyy-MM-dd').format(temp);
      days.add(formattedDate);

      ventas =
          await getComandasForADay(agenciaParaVer, formattedDate, 'No Cobrado');

      totalPrices = 0;
      ventas.forEach((element) {
        totalPrices =
            totalPrices + element['totalConsumo'] - element['descuento'];
      });
      days.add(totalPrices);
    }
    globals.dayss1 = days;

    return days;
  }

  @override
  void initState() {
    globals.agenciaSeleccionadaParaVer1 = '';
    globals.formattedDateGlobalFinal =
        DateTime.now().add(const Duration(days: 1));
    dateInputFinal.text = "";
    dateInputInicial.text = ""; //set the initial value of text field
    globals.dayss1 = [];
    // lazyValue = "ss";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? _selectedVal1;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: AppBar(
              title: Text(
            'Estadisticas No Cobradas  -  Coffeina',
            style: TextStyle(color: Colors.black, fontSize: 20),
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              FutureBuilder(
                  future: getAgencias(),
                  builder: ((context, snapshop) {
                    if (snapshop.hasData) {
                      globals.newAgenciaList = [];
                      String jsonstringmap = json.encode(snapshop.data);
                      check3 = false;
                      snapshop.data?.forEach((item) {
                        globals.newAgenciaList.add(item['agencia']);
                      });
                      // newAgenciaList = globals.newAgenciaList;
                    }
                    return DropdownButtonFormField(
                      borderRadius: BorderRadius.circular(20),
                      decoration: InputDecoration(
                        isDense: true, // Added this
                        contentPadding: EdgeInsets.all(8),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(width: 3, color: Colors.grey),
                        ),
                      ),
                      hint: Text(
                        'Seleccione Agencia',
                        style: TextStyle(
                            color: Colors.black, fontSize: 15, height: 2.0),
                      ),
                      isExpanded: true,
                      menuMaxHeight: 350,
                      iconSize: 36,
                      style: TextStyle(color: Colors.black, fontSize: 22),
                      items: globals.newAgenciaList
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child:
                                    Text(item, style: TextStyle(fontSize: 15)),
                              ))
                          .toList(),
                      onChanged: (item) => setState(
                          () => globals.agenciaSeleccionadaParaVer1 = item!),
                    );
                  })),
              TextField(
                controller: dateInputInicial,
                //editing controller of this TextField
                decoration: InputDecoration(
                  isDense: true, // Added this
                  contentPadding: EdgeInsets.all(8),
                  icon: Icon(Icons.calendar_today), //icon of text field
                  labelText: "Ingrese Fecha Inicial",
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontSize: 15), //label text of field
                ),
                readOnly: true,
                //set it true, so that user will not able to edit text
                onTap: () async {
                  check3 = false;
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2100));

                  if (pickedDate != null) {
                    fechaIni = pickedDate.day;
                    // print(
                    //      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    globals.formattedDateGlobalInicial = pickedDate;
                    //    print(
                    //      formattedDate); //formatted date output using intl package =>  2021-03-16

                    setState(() {
                      dateInputInicial.text =
                          formattedDate; //set output date to TextField value.
                    });
                  } else {}
                },
              ),
              TextField(
                controller: dateInputFinal,
                //editing controller of this TextField
                decoration: InputDecoration(
                  isDense: true, // Added this
                  contentPadding: EdgeInsets.all(8),
                  icon: Icon(Icons.calendar_today), //icon of text field
                  labelText: "Ingrese Fecha Final",
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontSize: 15), //la //label text of field
                ),
                readOnly: true,
                //set it true, so that user will not able to edit text
                onTap: () async {
                  check3 = false;
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2100));

                  if (pickedDate != null) {
                    fechaFin = pickedDate.day;
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    globals.formattedDateGlobalFinal = pickedDate;
                    setState(() {
                      dateInputFinal.text = formattedDate;
                    });
                  } else {}
                },
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Expanded(
                    child: SizedBox(
                        width: 10,
                        height: 30,
                        child: Container(
                            width: double.infinity,
                            child: CheckboxListTile(
                              value: check3,
                              controlAffinity: ListTileControlAffinity
                                  .leading, //checkbox at left
                              onChanged: (bool? value) {
                                setState(() {
                                  check3 = value!;
                                  print(check3);
                                  if (check3 == true) {
                                    example =
                                        totalConsumos.asMap().entries.map((e) {
                                      return FlSpot(e.key.toDouble(), e.value);
                                    }).toList();

                                    print('totalConsumos11');
                                    print(totalConsumos);
                                    print('exampleeeeee');
                                    print(example);
                                  }
                                });
                              },
                              title: Text(
                                "Grafica ?",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                            ))))
              ]),
              Text(
                  "Ingresos No Cobrados-> " +
                      globals.agenciaSeleccionadaParaVer1,
                  style: TextStyle(fontSize: 18)),
              (globals.formattedDateGlobalFinal.day ==
                          DateTime.now().add(const Duration(days: 1)).day) ||
                      (dateInputFinal.text.isEmpty ||
                          dateInputFinal.text.isNull) ||
                      (dateInputInicial.text.isEmpty ||
                          dateInputInicial.text.isNull) ||
                      (globals.agenciaSeleccionadaParaVer1.isEmpty ||
                          globals.agenciaSeleccionadaParaVer1.isNull)
                  ? Text("No hay datos", style: TextStyle(fontSize: 22))
                  : FutureBuilder(
                      future: getDaysInBetween1(
                          globals.agenciaSeleccionadaParaVer1,
                          globals.formattedDateGlobalInicial,
                          globals.formattedDateGlobalFinal),
                      builder: ((context, snapshop) {
                        if (snapshop.hasData) {
                          int i = 0;

                          totalConsumos = [];
                          example = [];
                          dias = (fechaFin! - fechaIni!)!;
                          days = getDaysInBetween(
                              globals.formattedDateGlobalInicial,
                              globals.formattedDateGlobalFinal);
                          //     int i = 0;
                          double precio;
                          double totalPrice = 0;
                          double descuento = 0;
                          days.forEach((day) async {
                            ventas = await getComandasForADayForTotalIngresos(
                                globals.agenciaSeleccionadaParaVer1,
                                day.toString().split(' ')[0],
                                'No Cobrado');
                            //                    await Future.delayed(const Duration(seconds: 1));
                            totalPrice = 0;

                            ventas.forEach((element) {
                              totalPrice = totalPrice +
                                  (element['totalConsumo'] -
                                      element['descuento']);
                            });
                            totalConsumos.add(totalPrice);
                            i++;
                            print('totalConsumos');
                            print(totalConsumos);
                          });
                          loading = true;
                        }
                        return loading == false
                            ? Center(
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : Expanded(
                                child: ListView.builder(
                                itemCount: globals.dayss1.length,
                                itemBuilder: (context, index) =>
                                    getRowInventario(index),
                              ));
                      })),
              check3 == true
                  ? Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      height: 300,
                      child: LineChart(
                        LineChartData(
                            borderData: FlBorderData(show: true),
                            lineBarsData: [
                              LineChartBarData(
                                spots: example,
                                isCurved: false,
                                barWidth: 3,
                                color: Colors.red,
                              ),
                            ]),
                      ),
                    )
                  : Center()
            ],
          ),
        ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            tooltip: 'Impresion',
            child: Icon(Icons.print),
            onPressed: () {
              if (globals.dayss1.isNotEmpty) {
                double total = 0;
                for (var i = 0; i < globals.dayss1.length; i = i + 2) {
                  total = total + globals.dayss1[i + 1];
                }
                printDoc9(globals.agenciaSeleccionadaParaVer1, DateTime.now(),
                    globals.dayss1, total);
              } else {
                showAlert(QuickAlertType.warning);
              }

              setState(() {});
              /*   Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));*/
            },
          ),
        ]));
  }

  Widget getRowInventario(int index) {
    return index % 2 == 0
        ? Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    index % 2 == 0 ? Colors.deepPurpleAccent : Colors.purple,
                foregroundColor: Colors.white,
                child: Text(
                  globals.dayss1[index][8] + globals.dayss1[index][9],
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fecha: ' + globals.dayss1[index].toString(), //.item,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                      'Total Ingreso No Cobrado: ' +
                          globals.dayss1[index + 1].toStringAsFixed(2) +
                          ' Bs.',
                      style: TextStyle(
                        fontSize: 15,
                      ))
                ],
              ),
            ),
          )
        : Center();
  }
/*
  List<FlSpot> getData() {
    days = getDaysInBetween(
        globals.formattedDateGlobalInicial, globals.formattedDateGlobalFinal);
    int i = 0;
    //List ventas;
    double precio;
    double totalPrice = 0;
    //final totalConsumos = [];
    days.forEach((day) async {
      //   print(day.toString().split(' ')[0]);
      ventas = await getComandasForADay(
          "central", day.toString().split(' ')[0], 'No Cobrado');
      totalPrice = 0;
      ventas.forEach((element) {
        totalPrice = totalPrice + element['totalConsumo'];
      });
      totalConsumos.add(totalPrice);
      //           if (ventas.isNotEmpty) {

      //   }
      i++;

      example = totalConsumos.asMap().entries.map((e) {
        return FlSpot(e.key.toDouble(), e.value);
      }).toList();

      grafica();
    });
    example = totalConsumos.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value);
    }).toList();
    return example;
  }*/

  Widget grafica() {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      height: 300,
      child: LineChart(
        LineChartData(borderData: FlBorderData(show: false), lineBarsData: [
          LineChartBarData(
              //   spots: example,
              isCurved: true,
              barWidth: 3,
              color: Colors.red,
              spots: [
                const FlSpot(0, 10),
                const FlSpot(7, 30),
                const FlSpot(3, 15)
              ])
        ]),
      ),
    );
  }
}
