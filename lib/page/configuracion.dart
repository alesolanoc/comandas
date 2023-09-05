import 'dart:convert';
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
final List totalConsumos = [];
List<FlSpot> example = [];

class Agencia {
  String agencia;
  Agencia({required this.agencia});
  Map<String, dynamic> toJson() => {"agencia": agencia};
}

class Configuracion extends StatefulWidget {
  @override
  _ConfiguracionState createState() => _ConfiguracionState();
}

class _ConfiguracionState extends State<Configuracion> {
  List<Agencia> agencia = List.empty(growable: true);
  List newAgenciaList = [];
  TextEditingController dateInputFinal = TextEditingController();
  TextEditingController dateInputInicial = TextEditingController();
  int? fechaIni;
  int? fechaFin;
  int? dias;
  bool loading = true;

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
          await getComandasForADay(agenciaParaVer, formattedDate, 'Cobrado');

      totalPrices = 0;
      ventas.forEach((element) {
        totalPrices = totalPrices + element['totalConsumo'];
      });
      days.add(totalPrices);
    }
    globals.dayss = days;

    return days;
  }

  @override
  void initState() {
    dateInputFinal.text = "";
    dateInputInicial.text = ""; //set the initial value of text field
    globals.dayss = [];
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
            'Estadisticas  -  Coffeina',
            style: TextStyle(color: Colors.black, fontSize: 10),
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
                            color: Colors.black, fontSize: 10, height: 2.0),
                      ),
                      isExpanded: true,
                      menuMaxHeight: 350,
                      iconSize: 36,
                      style: TextStyle(color: Colors.black, fontSize: 22),
                      items: globals.newAgenciaList
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child:
                                    Text(item, style: TextStyle(fontSize: 10)),
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
                      fontSize: 10), //label text of field
                ),
                readOnly: true,
                //set it true, so that user will not able to edit text
                onTap: () async {
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
                      fontSize: 10), //la //label text of field
                ),
                readOnly: true,
                //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2100));

                  if (pickedDate != null) {
                    fechaFin = pickedDate.day;
                    dias = (fechaFin! - fechaIni!)!;

                    //   }
                    //  print(
                    //      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    globals.formattedDateGlobalFinal = pickedDate;
                    //  print(
                    //      formattedDate); //formatted date output using intl package =>  2021-03-16
                    /*   days = getDaysInBetween(globals.formattedDateGlobalInicial,
                      globals.formattedDateGlobalFinal);
                  int i = 0;
                  //List ventas;
                  double precio;
                  double totalPrice = 0;
                  //final totalConsumos = [];
                  days.forEach((day) async {
                    //   print(day.toString().split(' ')[0]);
                    ventas = await getComandasForADay(
                        "central", day.toString().split(' ')[0], 'Cobrado');
                    totalPrice = 0;
                    ventas.forEach((element) {
                      totalPrice = totalPrice + element['totalConsumo'];
                    });
                    totalConsumos.add(totalPrice);
                    //           if (ventas.isNotEmpty) {
                    print(i);
                    print(totalPrice);
                    //   }
                    i++;
                    print('totalConsumos');
                    print(totalConsumos);

                    example = totalConsumos.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value);
                    }).toList();
                    print('spots1');
                    print(example);

                    grafica();
                    print('asdfasdfasdfasdf');
                  });
                  print('totalConsumossssss');
                  print(totalConsumos);
                  example = totalConsumos.asMap().entries.map((e) {
                    return FlSpot(e.key.toDouble(), e.value);
                  }).toList();
                  print('spots');
                  print(example);
                  final List<double> example1 = [
                    1.3,
                    1,
                    1.8,
                    1.5,
                    2.2,
                    1.8,
                    3,
                  ];

                  example = example1.asMap().entries.map((e) {
                    return FlSpot(e.key.toDouble(), e.value);
                  }).toList();*/

                    //  print(ventas);
                    setState(() {
                      dateInputFinal.text =
                          formattedDate; //set output date to TextField value.
                      //  grafica();
                    });
                  } else {}
                },
              ),
              Text("Ingresos-> " + globals.agenciaSeleccionadaParaVer1,
                  style: TextStyle(fontSize: 18)),
              /*      FutureBuilder<String>(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final val = getData();
                  print(val);
                }
                return Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  height: 300,
                  child: LineChart(
                    LineChartData(
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: example,
                            isCurved: true,
                            barWidth: 3,
                            color: Colors.red,
                            /*spots: [
                              const FlSpot(0, 10),
                              const FlSpot(7, 30),
                              const FlSpot(3, 15)
                            ]*/
                          )
                        ]),
                  ),
                );
              },
            ),*/
              /* Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: 300,
              child: LineChart(
                LineChartData(
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: example,
                        isCurved: true,
                        barWidth: 3,
                        color: Colors.red,
                        /*spots: [
                              const FlSpot(0, 10),
                              const FlSpot(7, 30),
                              const FlSpot(3, 15)
                            ]*/
                      )
                    ]),
              ),
            ),*/

              globals.formattedDateGlobalFinal.day ==
                      DateTime.now().add(const Duration(days: 1)).day
                  ? Text("No hay datos", style: TextStyle(fontSize: 22))
                  : FutureBuilder(
                      future: getDaysInBetween1(
                          globals.agenciaSeleccionadaParaVer1,
                          globals.formattedDateGlobalInicial,
                          globals.formattedDateGlobalFinal),
                      builder: ((context, snapshop) {
                        if (snapshop.hasData) {
                          /*          List lista = getDaysInBetween(
                          globals.formattedDateGlobalInicial,
                          globals.formattedDateGlobalFinal);*/
                          int i = 0;
                          /*         print('globals.formattedDateGlobalFinal');
                      print(DateTime.now().add(const Duration(days: 1)).day);
                      print(globals.formattedDateGlobalFinal.day);
                      print(globals.formattedDateGlobalInicial.day);
                      print('lista');
                      print(lista);*/
                          double precio;
                          double totalPrice = 0;
                          /*             print('snapshop.hasData');
                      print(snapshop.data);*/

                          //      if (lista != []) {
                          snapshop.data?.forEach((item) {
                            //            lista.forEach((item) async {
                            // days1.add(item);

                            // ignore: await_only_futures
                            /*                  ventas = await getComandasForADay("central",
                              item.toString().split(' ')[0], 'Cobrado');
                          print('ventas');
                          print(ventas);
                          totalPrice = 0;
                          ventas.forEach((element) {
                            print('element');
                            print(element['totalConsumo']);
                            totalPrice = totalPrice + element['totalConsumo'];
                            print('totalPrice');
                            print(totalPrice);
                          });*/
                            totalConsumos.add(totalPrice);
                            //           if (ventas.isNotEmpty) {

                            //   }
                            i++;

                            globals.totalConsumoss = totalConsumos;

                            example = totalConsumos.asMap().entries.map((e) {
                              return FlSpot(e.key.toDouble(), e.value);
                            }).toList();
                          });
                          //   }

                          /*ays1');
                      print(days1);
                      print('example');
                      print(example);
                      globals.totalConsumoss = totalConsumos;
                      print(globals.dayss);*/
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
                                itemCount: globals.dayss.length,
                                itemBuilder: (context, index) =>
                                    getRowInventario(index),
                              ));
                      })),
              /*         SizedBox(height: 10),
            // Text(example as String),
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: 300,
              child: LineChart(
                LineChartData(
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: example,
                        isCurved: true,
                        barWidth: 3,
                        color: Colors.red,
                        /*spots: [
                              const FlSpot(0, 10),
                              const FlSpot(7, 30),
                              const FlSpot(3, 15)
                            ]*/
                      )
                    ]),
              ),
            )*/
            ],
          ),
        ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            tooltip: 'Impresion',
            child: Icon(Icons.print),
            onPressed: () {
              if (globals.dayss.isNotEmpty) {
                double total = 0;
                for (var i = 0; i < globals.dayss.length; i = i + 2) {
                  total = total + globals.dayss[i + 1];
                }
                printDoc6(globals.agenciaSeleccionadaParaVer1, DateTime.now(),
                    globals.dayss, total);
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
                  globals.dayss[index][8] + globals.dayss[index][9],
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fecha: ' + globals.dayss[index].toString(), //.item,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  Text(
                      'Total Ingreso: ' +
                          globals.dayss[index + 1].toStringAsFixed(2) +
                          ' Bs.',
                      style: TextStyle(
                        fontSize: 10,
                      ))
                ],
              ),
            ),
          )
        : Center();
  }

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
          "central", day.toString().split(' ')[0], 'Cobrado');
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
  }

  Widget grafica() {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      height: 300,
      child: LineChart(
        LineChartData(borderData: FlBorderData(show: false), lineBarsData: [
          LineChartBarData(
            spots: example,
            isCurved: true,
            barWidth: 3,
            color: Colors.red,
            /*spots: [
                              const FlSpot(0, 10),
                              const FlSpot(7, 30),
                              const FlSpot(3, 15)
                            ]*/
          )
        ]),
      ),
    );
  }
}
