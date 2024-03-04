import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/page/printDoc.dart';
import 'package:flutter_application_1/page/printable_data.dart';
import 'package:intl/intl.dart';
import 'package:open_document/my_files/init.dart';
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

class ListadoDetallado extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListadoDetalladoState();
  }
}

List<String> options = [
  'Todo',
  'central',
  'sucursal 1',
  'Baja',
  'Merendar',
  'Reposicion',
  'Eliminado'
];

class _ListadoDetalladoState extends State<ListadoDetallado> {
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
    QuickAlert.show(context: context, type: quickAlertType, width: 100);
  }

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    descuentoField.text = '0';
    super.initState();
    controller = TextEditingController();
    globals.formattedDateGlobal = '';
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
            'Listado Detallado de Comandas  -  Coffeina',
            style: TextStyle(color: Colors.black, fontSize: 20),
          )),
        ),
        body: Padding(
          padding: EdgeInsets.all(15),
          //  height: MediaQuery.of(context).size.width / 3,

          child: Column(children: [
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
              //set it true, so that user will not able to edit text
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2100));

                if (pickedDate != null) {
                  //    print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  globals.formattedDateGlobal = formattedDate;
                  //    print(formattedDate); //formatted date output using intl package =>  2021-03-16

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
                  isDense: true, // Added this
                  contentPadding: EdgeInsets.all(8),
                  hintText: 'Fecha: ' + globals.formattedDateGlobal,
                  hintStyle: TextStyle(fontSize: 15),
                  enabled: false,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Expanded(
                  child: SizedBox(
                width: 10,
                height: 30,
                child: Container(
                    width: double.infinity,
                    child: RadioListTile(
                      title: const Text(
                        'Todo',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      value: options[0],
                      groupValue: currentOption,
                      onChanged: (value) {
                        setState(() {
                          currentOption = value.toString();
                          seleccionarOpcion = 1;
                          print(check3);
                        });
                      },
                    )),
              )),
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
                                check3 = value;
                                print(seleccionarOpcion);
                                print(check3);
                              });
                            },
                            title: Text(
                              "Cobrados?",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ))))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Expanded(
                  child: SizedBox(
                      width: 10,
                      height: 30,
                      child: Container(
                          width: double.infinity,
                          child: RadioListTile(
                            title: const Text(
                              'central',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            value: options[1],
                            groupValue: currentOption,
                            onChanged: (value) {
                              setState(() {
                                currentOption = value.toString();
                                seleccionarOpcion = 2;
                                print(check3);
                              });
                            },
                          )))),
              Expanded(
                  child: SizedBox(
                      width: 10,
                      height: 30,
                      child: Container(
                          width: double.infinity,
                          child: RadioListTile(
                            title: const Text(
                              'Baja',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            value: options[3],
                            groupValue: currentOption,
                            onChanged: (value) {
                              setState(() {
                                currentOption = value.toString();
                                seleccionarOpcion = 4;
                                print(check3);
                              });
                            },
                          )))),
              Expanded(
                  child: SizedBox(
                      width: 10,
                      height: 30,
                      child: Container(
                          width: double.infinity,
                          child: RadioListTile(
                            title: const Text(
                              'Reponer',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            value: options[5],
                            groupValue: currentOption,
                            onChanged: (value) {
                              setState(() {
                                currentOption = value.toString();
                                seleccionarOpcion = 6;
                                print(check3);
                              });
                            },
                          )))),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Expanded(
                  child: SizedBox(
                      width: 10,
                      height: 30,
                      child: Container(
                        width: double.infinity,
                        child: RadioListTile(
                          title: const Text(
                            'sucursal 1',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          value: options[2],
                          groupValue: currentOption,
                          onChanged: (value) {
                            setState(() {
                              currentOption = value.toString();
                              seleccionarOpcion = 3;
                              print(check3);
                            });
                          },
                        ),
                      ))),
              Expanded(
                  child: SizedBox(
                      width: 10,
                      height: 30,
                      child: Container(
                        width: double.infinity,
                        child: RadioListTile(
                          title: const Text(
                            'Merendar',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          value: options[4],
                          groupValue: currentOption,
                          onChanged: (value) {
                            setState(() {
                              currentOption = value.toString();
                              seleccionarOpcion = 5;
                              print(check3);
                            });
                          },
                        ),
                      ))),
              Expanded(
                  child: SizedBox(
                      width: 10,
                      height: 30,
                      child: Container(
                        width: double.infinity,
                        child: RadioListTile(
                          title: const Text(
                            'Eliminadas',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          value: options[6],
                          groupValue: currentOption,
                          onChanged: (value) {
                            setState(() {
                              currentOption = value.toString();
                              seleccionarOpcion = 7;
                              print(check3);
                            });
                          },
                        ),
                      )))
            ]),
            FutureBuilder(
                future: getComandas(currentOption, globals.formattedDateGlobal,
                    seleccionarOpcion, check3!),
                builder: ((context, snapshop) {
                  if (snapshop.hasData) {
                    globals.inventarioNumeroComanda = [];
                    globals.inventarioNombreCliente = [];
                    globals.inventarioCreationDate = [];
                    globals.inventarioAgencia = [];
                    globals.inventarioNumeroMesa = [];
                    globals.inventarioHora = [];
                    globals.inventarioCodigoComanda = [];
                    globals.inventarioTotalConsumo = [];
                    globals.inventarioStatus = [];
                    globals.inventarioDescuento = [];
                    globals.listaDeComandas = [];
                    globals.listaDeComandas1 = [];
                    String jsonstringmap = json.encode(snapshop.data);
                    snapshop.data?.forEach((item) {
                      globals.inventarioNumeroComanda
                          .add(item['numeroComanda']);
                      globals.inventarioNombreCliente
                          .add(item['nombreCliente']);
                      globals.inventarioCreationDate.add(item['creacionDate']);
                      globals.inventarioAgencia.add(item['agencia']);
                      globals.inventarioNumeroMesa.add(item['mesa']);
                      globals.inventarioHora.add(item['creacionTime']);
                      globals.inventarioCodigoComanda
                          .add(item['codigoComanda']);
                      globals.inventarioTotalConsumo.add(item['totalConsumo']);
                      globals.inventarioStatus.add(item['status']);
                      globals.inventarioDescuento.add(item['descuento']);
                    });
                  }

                  return globals.formattedDateGlobal.isEmpty || dateInput == ''
                      ? Text("No hay comandas", style: TextStyle(fontSize: 15))
                      : Expanded(
                          child: ListView.builder(
                          itemCount: globals.inventarioNumeroComanda.length,
                          itemBuilder: (context, index) =>
                              getRowInventario(index),
                        ));
                })),
          ]),
        ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            tooltip: 'Impresion',
            child: Icon(Icons.print),
            onPressed: () {
              print('pdf');
              print(globals.inventarioNumeroComanda);
              print(globals.listaDeComandas);
              if (globals.inventarioNumeroComanda.isNotEmpty) {
                printDoc7(
                    globals.formattedDateGlobal,
                    globals.inventarioNumeroComanda,
                    globals.inventarioTotalConsumo,
                    globals.inventarioCreationDate,
                    globals.inventarioHora,
                    globals.inventarioStatus,
                    globals.inventarioDescuento,
                    globals.inventarioAgencia,
                    globals.inventarioCodigoComanda,
                    globals.listaDeComandas);
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
            globals.inventarioNumeroComanda[index].toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Nro. Comanda: ' +
                globals.inventarioNumeroComanda[index].toString() +
                ' -> Status: ' +
                globals.inventarioStatus[index], //.item,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text('Cliente: ' + globals.inventarioNombreCliente[index],
              style: TextStyle(fontSize: 15) //.item,
              ),
          Text(
            'Hora: ' + globals.inventarioHora[index], //.item,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text('Agencia: ' + globals.inventarioAgencia[index],
              style: TextStyle(fontSize: 15) //.item,
              ),
          FutureBuilder(
              future: getAComanda(globals.inventarioCodigoComanda[index]),
              builder: ((context, snapshop1) {
                Timer(Duration(seconds: 3), () {});
                if (snapshop1.hasData) {
                  //verifica                globals.listaDeComandas = [];
                  globals.listaItemDeUnaComanda = [];
                  globals.listaCantidadDeUnaComanda = [];
                  globals.listaPrecioDeUnaComanda = [];
                  // final jsonstringmap = json.decode(snapshop1.data as String);
                  snapshop1.data?.forEach((item1) {
                    //  print('snapshop1.data');
                    //  print(snapshop1.data);
                    //    print(jsonstringmap['precio']);
                    globals.listaItemDeUnaComanda.add(item1['item']);
                    globals.listaCantidadDeUnaComanda.add(item1['cantidad']);
                    globals.listaPrecioDeUnaComanda.add(item1['precio']);
                  });
                  globals.listaDeComandas.add(snapshop1.data!);
                  print('globals.inventarioCodigoComanda[index]');
                  print(globals.inventarioCodigoComanda[index]);
                  print('globals.listaItemDeUnaComandaaaa');
                  print(globals.listaDeComandas);
                  print('globals.listaItemDeUnaComanda.length');
                  print(globals.listaItemDeUnaComanda.length);
                }
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: globals.listaItemDeUnaComanda.length,
                  itemBuilder: (context, index) => getRowOfAComanda(index),
                );
                //  );
              })),
          globals.inventarioDescuento[index] != 0
              ? Row(children: [
                  Text(
                      'Total ' +
                          (globals.inventarioTotalConsumo[index] -
                                  globals.inventarioDescuento[index])
                              .toStringAsFixed(2) +
                          ' Bs.', //.item,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Text(
                    '   -> Desc: ' +
                        globals.inventarioDescuento[index].toStringAsFixed(2) +
                        ' Bs.', //.item,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  )
                ])
              : Text(
                  'Total: ' +
                      (globals.inventarioTotalConsumo[index])
                          .toStringAsFixed(2) +
                      ' Bs.', //.item,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ]),
        trailing: SizedBox(
          width: 70,
          child: Row(
            children: [
              InkWell(
                  onTap: (() {
                    final cantidadModifica = openDialog(
                        globals.inventarioAgencia[index],
                        globals.inventarioNumeroComanda[index].toString(),
                        globals.inventarioNombreCliente[index],
                        globals.inventarioNumeroMesa[index].toString(),
                        globals.inventarioHora[index],
                        globals.inventarioCodigoComanda[index],
                        globals.inventarioTotalConsumo[index].toString(),
                        globals.inventarioStatus[index],
                        globals.inventarioDescuento[index].toString(),
                        globals.inventarioCreationDate[index]);
                  }),
                  child: Icon(Icons.flatware)),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> openDialog(
          String agenciaNombre,
          String numeroComanda,
          String nombreCliente,
          String numeroMesa,
          String hora,
          String codigoComanda,
          String totalConsumo,
          String status,
          String descuento1,
          String fecha) =>
      showDialog<String>(
          context: context,
          builder: (context) => DraggableScrollableSheet(
                initialChildSize: 0.9,
                minChildSize: 0.5,
                maxChildSize: 1,
                builder: (context, controller) => Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  child: Material(
                      child: ListView(children: [
                    Text(
                      '----->Numero de Comanda: ' + numeroComanda,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: agenciaField,
                      decoration: InputDecoration(
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(8),
                          prefixIcon: Icon(Icons.home),
                          hintText: 'Agencia: ' + agenciaNombre,
                          hintStyle: TextStyle(fontSize: 15),
                          enabled: false,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: nombreClienteField,
                      decoration: InputDecoration(
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(8),
                          prefixIcon: Icon(Icons.person),
                          hintText: 'Nombre: ' + nombreCliente,
                          hintStyle: TextStyle(fontSize: 15),
                          enabled: false,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: numeroDeMesaField,
                      decoration: InputDecoration(
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(8),
                          prefixIcon: Icon(Icons.table_bar),
                          hintText: 'Nro. de Mesa: ' + numeroMesa,
                          hintStyle: TextStyle(fontSize: 15),
                          enabled: false,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: horaField,
                      decoration: InputDecoration(
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(8),
                          prefixIcon: Icon(Icons.alarm),
                          hintText: "Hora: " + hora,
                          hintStyle: TextStyle(fontSize: 15),
                          enabled: false,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: statusField,
                      decoration: InputDecoration(
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(8),
                          prefixIcon: Icon(Icons.fiber_smart_record),
                          hintText: "Status: " + status,
                          hintStyle: TextStyle(fontSize: 15),
                          enabled: false,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                    ),
                    FutureBuilder(
                        future: getAComanda(codigoComanda),
                        builder: ((context, snapshop) {
                          if (snapshop.hasData) {
                            globals.listaItemDeUnaComanda = [];
                            globals.listaCantidadDeUnaComanda = [];
                            globals.listaPrecioDeUnaComanda = [];
                            String jsonstringmap = json.encode(snapshop.data);
                            snapshop.data!.forEach((item) {
                              globals.listaItemDeUnaComanda.add(item['item']);
                              globals.listaCantidadDeUnaComanda
                                  .add(item['cantidad']);
                              globals.listaPrecioDeUnaComanda
                                  .add(item['precio']);
                            });
                          }
                          return ListView.builder(
                            //   scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: globals.listaItemDeUnaComanda.length,
                            itemBuilder: (context, index1) =>
                                getRowOfAComanda(index1),
                          );
                          //  );
                        })),
                    SizedBox(height: 10),
                    status == 'No Cobrado'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                Text(
                                  'Inserte Descuento -> ',
                                  style: TextStyle(fontSize: 15),
                                ),
                                SizedBox(
                                    width: 250,
                                    child: TextField(
                                      controller: descuentoField,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                          isDense: true, // Added this
                                          contentPadding: EdgeInsets.all(8),
                                          prefixIcon: Icon(Icons.attach_money),
                                          // hintText: "Inserte Descuento",
                                          enabled: true,
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)))),
                                    )),
                              ])
                        : descuento1 != '0'
                            ? TextField(
                                // controller: descuentoField,
                                decoration: InputDecoration(
                                    isDense: true, // Added this
                                    contentPadding: EdgeInsets.all(8),
                                    prefixIcon: Icon(Icons.attach_money),
                                    hintText:
                                        'Descuento: ' + descuento1 + ' Bs.',
                                    hintStyle: TextStyle(fontSize: 15),
                                    enabled: false,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)))),
                              )
                            : SizedBox(height: 10),
                    TextField(
                      controller: totalConsumoField,
                      decoration: InputDecoration(
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(8),
                          prefixIcon: Icon(Icons.attach_money),
                          hintText: "TOTAL : " +
                              (double.parse(totalConsumo) -
                                      double.parse(descuento1))
                                  .toStringAsFixed(2) +
                              ' Bs.',
                          hintStyle: TextStyle(fontSize: 15),
                          enabled: false,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                    ),
                    SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Column(children: [
                        ElevatedButton(
                            /*  style: ElevatedButton.styleFrom(
                                fixedSize: const Size(100, 37),
                                primary: Colors
                                    .redAccent, //background color of button
                                side: BorderSide(
                                    width: 1,
                                    color:
                                        Colors.brown), //border width and color
                                elevation: 1, //elevation of button
                                shape: RoundedRectangleBorder(
                                    //to set border radius to button
                                    borderRadius: BorderRadius.circular(30)),
                                padding: EdgeInsets.all(
                                    20) //content padding inside button
                                ),*/
                            child: Text('Cobrar'),
                            onPressed: status == 'No Cobrado'
                                ? () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                              child: AlertDialog(
                                            title: Text('Confirmar Cobro ?'),
                                            content: /* descuentoField.text.isEmpty
                                                ? Text('Consumo Total -> ' +
                                                    ((double.parse(
                                                            totalConsumo)))
                                                        .toString() +
                                                    ' Bs.')
                                                : */
                                                Text('Consumo Total -> ' +
                                                    ((double.parse(
                                                                totalConsumo) -
                                                            double.parse(
                                                                descuentoField
                                                                    .text)))
                                                        .toString() +
                                                    ' Bs.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  setState(() {});
                                                },
                                                child: Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  // descuento =
                                                  //   descuentoField.text='';
                                                  final status =
                                                      await updateStatusCommanda(
                                                          codigoComanda,
                                                          'Cobrado',
                                                          double.parse(
                                                              descuentoField
                                                                  .text));
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  descuentoField.text = '0';
                                                  setState(() {});
                                                },
                                                child: Text('Si'),
                                              ),
                                            ],
                                          ));
                                        });
                                  }
                                : null),
                      ]),
                      SizedBox(width: 10),
                      ElevatedButton(
                          /*   style: ElevatedButton.styleFrom(
                              fixedSize: const Size(120, 37),
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
                          child: Text('Volver Atras'),
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {});
                          }),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        /*   style: ElevatedButton.styleFrom(
                            fixedSize: const Size(100, 37),
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
                        child: Text('Print'),
                        onPressed: () {
                          var user = jsonEncode(globals.comandaLista);
                          String user1 = user;
                          var ab = json.decode(user1).toList();
                          /*    print('ab');
                          print(ab);
                          print(globals.listaItemDeUnaComanda);
                          print(globals.listaCantidadDeUnaComanda);
                          print(globals.listaPrecioDeUnaComanda);*/
                          if (status == 'Cobrado') {
                            printDoc2(
                                int.parse(numeroComanda),
                                nombreCliente,
                                int.parse(numeroMesa),
                                agenciaNombre,
                                globals.listaItemDeUnaComanda,
                                globals.listaCantidadDeUnaComanda,
                                globals.listaPrecioDeUnaComanda,
                                fecha,
                                double.parse(totalConsumo),
                                descuento1,
                                2);
                          } else {
                            printDoc2(
                                int.parse(numeroComanda),
                                nombreCliente,
                                int.parse(numeroMesa),
                                agenciaNombre,
                                globals.listaItemDeUnaComanda,
                                globals.listaCantidadDeUnaComanda,
                                globals.listaPrecioDeUnaComanda,
                                fecha,
                                double.parse(totalConsumo),
                                descuentoField.text,
                                2);
                          }
                          //  globals.totalConsumo);
                        },
                      )
                    ]),
                  ])),
                ),
              ));

  Widget getRowOfAComanda(int index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: index % 2 == 0 ? Colors.orange : Colors.deepOrange,
          foregroundColor: Colors.white,
          child: Text(
            globals.listaItemDeUnaComanda[index][0],
            ///////      pedido[index].item[0],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Item: ' + globals.listaItemDeUnaComanda[index],
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
                'Cantidad: ' +
                    globals.listaCantidadDeUnaComanda[index].toString() +
                    ' --> Precio Unitario: ' +
                    globals.listaPrecioDeUnaComanda[index].toStringAsFixed(2) +
                    ' Bs.',
                style: TextStyle(fontSize: 15)),
            Text(
              'Total del Item: ' +
                  (globals.listaPrecioDeUnaComanda[index] *
                          globals.listaCantidadDeUnaComanda[index])
                      .toStringAsFixed(2) +
                  ' Bs.',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        /*  trailing: SizedBox(
        width: 70,
        child: Row(
          children: [
            InkWell(
                onTap: (() {
                  setState(() {
                    ///////               pedido.removeAt(index);
                  });
                }),
                child: Icon(Icons.delete)),
          ],
        ),
      ),*/
      ),
    );
  }
}
