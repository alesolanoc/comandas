import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/page/printDoc.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'globals.dart' as globals;
import 'package:flutter/services.dart';
import 'package:flutter_application_1/page/firesbase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int bandera = 0;
String displayText = '';
String displayTextPrecio = '';

class Inventario extends StatefulWidget {
  @override
  _InventarioState createState() => _InventarioState();
}

class _InventarioState extends State<Inventario> {
  late TextEditingController controller;
  late TextEditingController controller1;
  String cantidadModifica = '';
  String cantidadModificaPrecio = '';
  String nuevoProducto = '';

  void showAlert(QuickAlertType quickAlertType) {
    QuickAlert.show(context: context, type: quickAlertType, width: 100);
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller1 = TextEditingController();
    globals.agenciaSeleccionadaParaVer = '';
  }

  @override
  void dispose() {
    controller.dispose();
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? _selectedVal1;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: AppBar(
              title: Text(
            'Inventario  -  Coffeina',
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
                      snapshop.data?.forEach((item) {
                        globals.newAgenciaList.add(item['agencia']);
                      });
                      // newAgenciaList = globals.newAgenciaList;
                    }
                    return const Center();
                  })),
              Text(
                "Inventario",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black),
              ),
              //     SizedBox(height: 10),
              Text(
                globals.agenciaSeleccionadaParaVer,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black),
              ),
              //        SizedBox(height: 10),
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
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(width: 3, color: Colors.grey),
                        ),
                      ),
                      hint: Text(
                        'Seleccione Agencia',
                        style: TextStyle(color: Colors.black, fontSize: 15),
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
                          () => globals.agenciaSeleccionadaParaVer = item!),
                    );
                  })),
              /*         DropdownButtonFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(width: 3, color: Colors.grey),
                ),
              ),
              hint: Text('Seleccione Agencia'),
              isExpanded: true,
              menuMaxHeight: 350,
              iconSize: 36,
              style: TextStyle(color: Colors.black, fontSize: 22),
              items: globals.newAgenciaList
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item, style: TextStyle(fontSize: 16)),
                      ))
                  .toList(),
              onChanged: (item) =>
                  setState(() => globals.agenciaSeleccionadaParaVer = item!),
            ),*/
              FutureBuilder(
                  future: getProductos(globals.agenciaSeleccionadaParaVer),
                  builder: ((context, snapshop) {
                    if (snapshop.hasData) {
                      globals.newListInventario = [];
                      globals.newListInventarioCanitdad = [];
                      globals.newListInventarioPrecio = [];
                      String jsonstringmap = json.encode(snapshop.data);
                      snapshop.data?.forEach((item) {
                        globals.newListInventario.add(item['item']);
                        globals.newListInventarioCanitdad.add(item['cantidad']);
                        globals.newListInventarioPrecio.add(item['precio']);
                        globals.newListUpdate.add(item['lastUpdate']);
                      });
                    }
                    return globals.newListInventario.length == 0
                        ? Text("Inventario vacio",
                            style: TextStyle(fontSize: 15))
                        : Expanded(
                            child: ListView.builder(
                            itemCount: globals.newListInventario.length,
                            itemBuilder: (context, index) =>
                                getRowInventario(index),
                          ));
                  })),
            ],
          ),
        ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            tooltip: 'Agregar Item',
            child: Icon(Icons.add),
            onPressed: () async {
              if (globals.agenciaSeleccionadaParaVer.isNotEmpty) {
                print('ggggggg');
                final nuevoProducto = await openDialogNuevoProducto(
                    globals.agenciaSeleccionadaParaVer);
                print(nuevoProducto);
                if (nuevoProducto != null) {
                  setState(() => this.nuevoProducto = nuevoProducto);
                  if (nuevoProducto.isNotEmpty) {
                    addProducto(nuevoProducto, 0,
                        globals.agenciaSeleccionadaParaVer, 0);
                    showAlert(QuickAlertType.success);
                  } else {
                    showAlert(QuickAlertType.error);
                  }
                }
              } else {
                showAlert(QuickAlertType.error);
              }
            },
          ),
          FloatingActionButton(
            tooltip: 'Impresion',
            child: Icon(Icons.print),
            onPressed: () {
              if (globals.agenciaSeleccionadaParaVer.isNotEmpty) {
                print('globals.newListInventario');
                print(globals.newListInventario);
                printDoc5(
                    globals.agenciaSeleccionadaParaVer,
                    DateTime.now(),
                    globals.newListInventario,
                    globals.newListInventarioCanitdad,
                    globals.newListInventarioPrecio,
                    globals.newListUpdate);
              } else {
                showAlert(QuickAlertType.error);
              }
              setState(() {});
              /*   Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));*/
            },
          ),
        ]));
  }

  Widget getRowInventario(int index) {
    print('bandera');
    print(bandera);
/*    if (bandera == 0) {*/
    displayText = globals.newListInventarioCanitdad[index].toString();
    //  }
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              index % 2 == 0 ? Colors.deepPurpleAccent : Colors.purple,
          foregroundColor: Colors.white,
          child: Text(
            globals.newListInventario[index][0],
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre: ' + globals.newListInventario[index].toString(), //.item,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text('Cantidad: ' + displayText, style: TextStyle(fontSize: 15)),
            Text(
              'Precio: ' +
                  globals.newListInventarioPrecio[index].toString() +
                  ' Bs.', //.item,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        trailing: SizedBox(
          width: 120,
          child: Row(
            children: [
              InkWell(
                  onTap: () async {
                    globals.productoAModificar =
                        globals.newListInventario[index].toString();
                    globals.cantidadAModificar =
                        globals.newListInventarioCanitdad[index].toString();

                    final cantidadModifica = await openDialog(
                        globals.newListInventario[index].toString(),
                        globals.newListInventarioCanitdad[index].toString(),
                        globals.newListInventarioPrecio[index].toString());
                    if (cantidadModifica != null) {
                      setState(() => this.cantidadModifica = cantidadModifica);
                      bandera = 1;
                      print('banderas');
                      print(bandera);
                      displayText = cantidadModifica;
                      print(cantidadModifica);
                      print("aaaaaaaa");
                      updateProductInventario(
                          globals.agenciaSeleccionadaParaVer,
                          globals.productoAModificar,
                          globals.newListInventarioCanitdad[index],
                          cantidadModifica!,
                          globals.newListInventarioPrecio[index]);
                      print("bbbbbbbbbb");
                      showAlert(QuickAlertType.success);
                    }
                  },
                  child: Icon(Icons.playlist_add)),
              SizedBox(width: 20),
              InkWell(
                  onTap: () async {
                    globals.productoAModificar =
                        globals.newListInventario[index].toString();
                    globals.cantidadAModificar =
                        globals.newListInventarioCanitdad[index].toString();

                    final cantidadModificaPrecio = await openDialogPrice(
                        globals.newListInventario[index].toString(),
                        globals.newListInventarioCanitdad[index].toString(),
                        globals.newListInventarioPrecio[index].toString());
                    if (cantidadModificaPrecio != null) {
                      //       setState(() => this.cantidadModifica = cantidadModifica);
                      setState(() {});
                      bandera = 1;
                      print('banderas');
                      print(bandera);
                      displayTextPrecio = cantidadModificaPrecio;
                      print(cantidadModificaPrecio);
                      print("aaaaaaaa");
                      updateProductPrecio(
                          globals.agenciaSeleccionadaParaVer,
                          globals.productoAModificar,
                          double.parse(cantidadModificaPrecio));
                      print("bbbbbbbbbb");
                      showAlert(QuickAlertType.success);
                    }
                  },
                  child: Icon(Icons.attach_money)),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> openDialog(String prod, String canti, String precio) =>
      showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(prod + '--> Cantidad: ' + canti),
                content: TextField(
                  autofocus: true,
                  decoration: InputDecoration(hintText: 'Ingrese Cantdad'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: controller,
                ),
                actions: [
                  TextButton(onPressed: submit, child: Text('Confirme'))
                ],
              ));

  void submit() {
    print('submit');
    print(globals.agenciaSeleccionadaParaVer);
    print(globals.productoAModificar);
    print(globals.cantidadAModificar);
    print('submit1');
//    updateProductInventario(globals.agenciaSeleccionadaParaVer,
    //      globals.productoAModificar, int.parse(globals.cantidadAModificar));
    Navigator.of(context).pop(controller.text);
    controller.clear();
  }

  Future<String?> openDialogPrice(String prod, String canti, String precio) =>
      showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(prod + '--> Precio: ' + precio + ' Bs.'),
                content: TextField(
                  autofocus: true,
                  decoration: InputDecoration(hintText: 'Ingrese Precio'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ],
                  controller: controller,
                ),
                actions: [
                  TextButton(onPressed: submit, child: Text('Confirme'))
                ],
              ));

  Future<String?> openDialogNuevoProducto(String agencia) => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Inserte Nuevo Producto en : ' + agencia),
            content: Form(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                autofocus: true,
                decoration: InputDecoration(hintText: 'Ingrese Nuevo Producto'),
                controller: controller1,
              ),
            ])),
            actions: [
              TextButton(onPressed: submitProduct, child: Text('Confirme'))
            ],
          ));

  void submitProduct() {
    //  addProducto(nuevoProducto, 0, globals.agenciaSeleccionadaParaVer);
    Navigator.of(context).pop(controller1.text);
    controller1.clear();
  }
}
