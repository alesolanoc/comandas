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

class GastosListados extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GastosListadosState();
  }
}

List<String> options = ['Todo', 'central', 'sucursal 1'];

class _GastosListadosState extends State<GastosListados> {
  late TextEditingController controller;
  TextEditingController agenciaField = TextEditingController();
  TextEditingController nombreClienteField = TextEditingController();
  TextEditingController numeroDeMesaField = TextEditingController();
  TextEditingController horaField = TextEditingController();
  TextEditingController codigoComandaField = TextEditingController();
  TextEditingController numeroComandaField = TextEditingController();
  TextEditingController statusField = TextEditingController();
  TextEditingController totalConsumoField = TextEditingController();
  TextEditingController descuentoField = TextEditingController();
  double totalConsumo = 0;
  double descuento = 0;
  String currentOption = options[0];
  TextEditingController dateInput = TextEditingController();
  bool? check3 = false;
  int seleccionarOpcion = 1;
  void showAlert(QuickAlertType quickAlertType) {
    QuickAlert.show(context: context, type: quickAlertType);
  }

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    descuentoField.text = '0';
    totalConsumo = 0;
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
        appBar: AppBar(title: Text('Listado de Gastos  -  Coffeina')),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: Column(children: [
            TextField(
              controller: dateInput,
              //editing controller of this TextField
              decoration: InputDecoration(
                  icon: Icon(Icons.calendar_today), //icon of text field
                  labelText: "Ingrese Fecha" //label text of field
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
              // controller: nombreClienteField,
              decoration: InputDecoration(
                  hintText: 'Fecha: ' + globals.formattedDateGlobal,
                  enabled: false,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
            FutureBuilder(
                future: getGastos(globals.formattedDateGlobal),
                builder: ((context, snapshop) {
                  if (snapshop.hasData) {
                    globals.inventarioNumeroGasto = [];
                    globals.inventarioTotalGasto = [];
                    globals.inventarioCreationDateGasto = [];
                    globals.inventarioConceptoGasto = [];
                    String jsonstringmap = json.encode(snapshop.data);
                    snapshop.data?.forEach((item) {
                      globals.inventarioNumeroGasto.add(item['numeroGasto']);
                      globals.inventarioConceptoGasto.add(item['item']);
                      globals.inventarioTotalGasto.add(item['precio']);
                      globals.inventarioUID.add(item['uid']);
                      globals.inventarioCreationDateGasto
                          .add(item['creacionDate']);
                      globals.inventarioCodigoGastp.add(item['codigoGastp']);
                    });
                    print('globals.inventarioUID');
                    print(globals.inventarioCodigoGastp);
                  }

                  return globals.formattedDateGlobal.isEmpty || dateInput == ''
                      ? Text("No hay gastos", style: TextStyle(fontSize: 22))
                      : Expanded(
                          child: ListView.builder(
                          itemCount: globals.inventarioNumeroGasto.length,
                          itemBuilder: (context, index) =>
                              getRowInventario(index),
                        ));
                })),
            SizedBox(height: 10),
            FutureBuilder(
                future: getGastosTotal(globals.formattedDateGlobal),
                builder: ((context, snapshop1) {
                  if (snapshop1.hasData) {
                    String jsonstringmap = json.encode(snapshop1.data);
                    totalConsumo = snapshop1.data!;
                  }

                  return Text(
                    '-> TOTAL EGRESOS: ' + totalConsumo.toString() + ' Bs.',
                    style: TextStyle(fontSize: 25),
                  );
                })),
          ]),
        ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            tooltip: 'Impresion',
            child: Icon(Icons.print),
            onPressed: () {
              if (globals.inventarioNumeroGasto.isNotEmpty) {
                printDoc3(
                    globals.formattedDateGlobal,
                    globals.inventarioNumeroGasto,
                    globals.inventarioTotalGasto,
                    globals.inventarioCreationDateGasto,
                    globals.inventarioConceptoGasto,
                    totalConsumo);
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
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              index % 2 == 0 ? Colors.deepPurpleAccent : Colors.purple,
          foregroundColor: Colors.white,
          child: Text(
            globals.inventarioNumeroGasto[index].toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Nro. Gasto: ' + globals.inventarioNumeroGasto[index].toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Descrip: ' + globals.inventarioConceptoGasto[index],
          ),
          Text(
            'Gasto: ' +
                globals.inventarioTotalGasto[index].toString() +
                ' Bs.', //.item,
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ]),
        trailing: SizedBox(
          width: 70,
          child: Row(
            children: [
              InkWell(
                  onTap: (() {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Container(
                              child: AlertDialog(
                            title: Text('Confirmar Eliminacion ?'),
                            content: /* descuentoField.text.isEmpty
                                                ? Text('Consumo Total -> ' +
                                                    ((double.parse(
                                                            totalConsumo)))
                                                        .toString() +
                                                    ' Bs.')
                                                : */
                                Text('Gasto -> ' +
                                    globals.inventarioConceptoGasto[index]),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  totalConsumo = totalConsumo -
                                      globals.inventarioTotalGasto[index];
                                  Navigator.pop(context);
                                  setState(() {});
                                },
                                child: Text('No'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await updateStatusGasto(
                                      globals.inventarioCodigoGastp[index]);
                                  Navigator.pop(context);
                                  setState(() {});
                                },
                                child: Text('Si'),
                              ),
                            ],
                          ));
                        });
                  }),
                  child: Icon(Icons.remove)),
            ],
          ),
        ),
      ),
    );
  }
}

double suma() {
  return globals.inventarioTotalGasto.fold(0, (a, b) => a + b);
}
