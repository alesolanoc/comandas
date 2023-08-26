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

class ListadoAll extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListadoAllState();
  }
}

List<String> options = [
  'Todo',
  'central',
  'sucursal 1',
  'Baja',
  'Merendar',
  'Reposicion'
];

class _ListadoAllState extends State<ListadoAll> {
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
  int sumaCantidadConsumida = 0;
  double sumaTotalConsumida = 0;

  void showAlert(QuickAlertType quickAlertType) {
    QuickAlert.show(context: context, type: quickAlertType);
  }

  @override
  void initState() {
    globals.ListaDeProductosItem = [];
    globals.LsitaDeProductosAgencia = [];
    globals.ListaDeProductosCantidad = [];
    globals.listaItemDeUnaComanda = [];
    globals.listaCantidadDeUnaComanda = [];
    globals.listaPrecioDeUnaComanda = [];
    globals.ListaDeItemEnComanda = [];
    globals.ListaDeNumeroComandaEnComanda = [];
    globals.ListaDeMesaEnComanda = [];
    globals.listaDeComandasDetalle = [];
    // final jsonstringmap = json.decode(snaps
    dateInput.text = ""; //set the initial value of text field
    descuentoField.text = '0';
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
      appBar: AppBar(title: Text('Listado Detallado por Item  -  Coffeina')),
      body: Padding(
        padding: EdgeInsets.all(15),
        //  height: MediaQuery.of(context).size.width / 3,

        child: Column(children: [
          TextField(
            controller: dateInput,
            //editing controller of this TextField
            decoration: InputDecoration(
                icon: Icon(Icons.calendar_today), //icon of text field
                labelText: "Enter Date" //label text of field
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
                globals.formattedDateGlobalListado = formattedDate;
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
                hintText: 'Fecha: ' + globals.formattedDateGlobalListado,
                enabled: false,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
          /*   Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Expanded(
                  child: Container(
                width: double.infinity,
                child: RadioListTile(
                  title: const Text('Todo'),
                  value: options[0],
                  groupValue: currentOption,
                  onChanged: (value) {
                    setState(() {
                      currentOption = value.toString();
                      seleccionarOpcion = 1;
                      print(check3);
                    });
                  },
                ),
              )),
            ]),*/
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Expanded(
                child: Container(
                    width: double.infinity,
                    child: RadioListTile(
                      title: const Text('central'),
                      value: options[1],
                      groupValue: currentOption,
                      onChanged: (value) {
                        setState(() {
                          currentOption = value.toString();
                          seleccionarOpcion = 2;
                          //           print(check3);
                        });
                      },
                    ))),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Expanded(
                child: Container(
              width: double.infinity,
              child: RadioListTile(
                title: const Text('sucursal 1'),
                value: options[2],
                groupValue: currentOption,
                onChanged: (value) {
                  setState(() {
                    currentOption = value.toString();
                    seleccionarOpcion = 3;
                    //             print(check3);
                  });
                },
              ),
            )),
          ]),
          FutureBuilder(
              future: getAllProducts(currentOption, seleccionarOpcion, check3!),
              builder: ((context, snapshop) {
                if (snapshop.hasData) {
                  globals.ListaDeProductosItem = [];
                  globals.LsitaDeProductosAgencia = [];
                  globals.ListaDeProductosCantidad = [];
                  globals.ListaDeTotalConsumido = [];
                  String jsonstringmap = json.encode(snapshop.data);
                  snapshop.data?.forEach((item) {
                    globals.ListaDeProductosItem.add(item['item']);
                    globals.LsitaDeProductosAgencia.add(item['agencia']);
                    globals.ListaDeProductosCantidad.add(item['cantidad']);
                  });
                }
                return globals.formattedDateGlobalListado.isEmpty ||
                        dateInput == ''
                    ? Text("No hay Productos", style: TextStyle(fontSize: 22))
                    : Expanded(
                        child: ListView.builder(
                        itemCount: globals.ListaDeProductosItem.length,
                        itemBuilder: (context, index) =>
                            getRowInventario(index),
                      ));
              })),
        ]),
      ),
      /*      floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            tooltip: 'Impresion',
            child: Icon(Icons.print),
            onPressed: () {
              print('pdf');
              print(
                  'globals.ListaDeTotalConsumidoooooooooooooooooooooooooooooooooooo');
              print(globals.listaDeComandasDetalle);
              if (globals.ListaDeProductosItem.isNotEmpty) {
                String cadena = globals.listaDeComandasDetalle.toString();
                print('cadenaaaaaaaaaaaaaaaaaaaa');
                print(cadena);
             /*   printDoc8(
                    globals.formattedDateGlobalListado,
                    globals.ListaDeProductosItem,
                    globals.LsitaDeProductosAgencia,
                    globals.ListaDeProductosCantidad,
                    globals.listaDeComandasDetalle,
                    cadena);*/
                //  globals.listaDeComandasDetalle,
                // globals.ListaDeTotalConsumido);
              } else {
                showAlert(QuickAlertType.warning);
              }

              setState(() {});
              /*   Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));*/
            },
          ),
        ])*/
    );
  }

  Widget getRowInventario(int index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              index % 2 == 0 ? Colors.deepPurpleAccent : Colors.purple,
          foregroundColor: Colors.white,
          child: Text(
            globals.ListaDeProductosItem[index][0].toString() +
                globals.ListaDeProductosItem[index][1].toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Item: ' + globals.ListaDeProductosItem[index].toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Cantidad en Stock: ' +
                globals.ListaDeProductosCantidad[index].toString(), //.item,
          ),
          Text(
            'Agencia: ' + globals.LsitaDeProductosAgencia[index], //.item,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          FutureBuilder(
              future: getAComandaFromProductName(
                  globals.formattedDateGlobalListado,
                  globals.LsitaDeProductosAgencia[index],
                  globals.ListaDeProductosItem[index]),
              builder: ((context, snapshop1) {
                if (snapshop1.hasData) {
                  //verifica                globals.listaDeComandas = [];
                  globals.listaItemDeUnaComanda = [];
                  globals.listaCantidadDeUnaComanda = [];
                  globals.listaPrecioDeUnaComanda = [];
                  globals.ListaDeItemEnComanda = [];
                  globals.ListaDeNumeroComandaEnComanda = [];
                  globals.ListaDeMesaEnComanda = [];
                  globals.listaDeComandasDetalle = [];
                  globals.ListaDeTotalConsumido = [];
                  sumaCantidadConsumida = 0;
                  sumaTotalConsumida = 0;
                  // final jsonstringmap = json.decode(snapshop1.data as String);
                  snapshop1.data?.forEach((item1) {
                    //  print('snapshop1.data');
                    //  print(snapshop1.data);
                    //    print(jsonstringmap['precio']);
                    globals.listaItemDeUnaComanda.add(item1['item']);
                    globals.listaCantidadDeUnaComanda.add(item1['cantidad']);
                    globals.listaPrecioDeUnaComanda.add(item1['precio']);
                    globals.ListaDeHoraEnComanda.add(item1['creacionTime']);
                    globals.ListaDeNumeroComandaEnComanda.add(
                        item1['numeroComanda']);
                    globals.ListaDeMesaEnComanda.add(item1['mesa']);
                    sumaCantidadConsumida =
                        ((sumaCantidadConsumida + item1['cantidad']) as int?)!;
                    sumaTotalConsumida = sumaTotalConsumida +
                        (item1['cantidad'] * item1['precio']);
                    globals.ListaDeTotalConsumido.add(sumaCantidadConsumida);
                  });
                  print('asdfasdfasdf');
                  /*        if (snapshop1.hasData) {
                    globals.listaDeComandasDetalle.add(snapshop1.data!);
                  } else {
                    globals.listaDeComandasDetalle.add([
                      {'cantidad': 0}
                    ]);
                  }*/
                  globals.ListaDeTotalConsumido.add(sumaCantidadConsumida);
                  print('ListaDeTotalConsumido');
                  print(globals.ListaDeTotalConsumido);
                  print('sumaCantidadConsumida');
                  print(globals.listaDeComandasDetalle);
                }

                return globals.listaItemDeUnaComanda.isNull ||
                        globals.listaItemDeUnaComanda.isEmpty
                    ? Text(
                        'No hay comandas', //.item,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          Text(
                            'Cantidad Consumida: ' +
                                sumaCantidadConsumida.toString(), //.item,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurpleAccent),
                          ),
                          Text(
                            'Total Consumido: ' +
                                sumaTotalConsumida.toString() +
                                ' Bs.', //.item,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurpleAccent),
                          ),
                          Text(
                            'Comandas: ' +
                                globals.ListaDeNumeroComandaEnComanda
                                    .toString(), //.item,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount:
                                globals.ListaDeNumeroComandaEnComanda.length,
                            itemBuilder: (context, index) =>
                                getRowOfAComanda(index),
                          )
                        ]));
                /*       ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: globals.listaDeComandasDetalle.length,
                  itemBuilder: (context, index) => getRowOfAComanda(index),
                );*/
                //  );
              })),
        ]),
      ),
    );
  }

  Widget getRowOfAComanda(int index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: index % 2 == 0 ? Colors.orange : Colors.deepOrange,
          foregroundColor: Colors.white,
          child: Text(
            globals.ListaDeNumeroComandaEnComanda[index].toString(),
            ///////      pedido[index].item[0],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nro Comanda: ' +
                  globals.ListaDeNumeroComandaEnComanda[index].toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Cantidad: ' +
                  globals.listaCantidadDeUnaComanda[index].toString(),
            ),
            Text(
              'Mesa: ' + (globals.ListaDeMesaEnComanda[index]).toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Hora: ' + globals.ListaDeHoraEnComanda[index].toString(),
            ),
            Text(
              'Item: ' + globals.listaItemDeUnaComanda[index].toString(),
            ),
          ],
        ),
      ),
    );
  }
}
