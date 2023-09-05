import 'dart:convert';
import 'dart:html';
import 'dart:js_util';
import 'package:flutter_application_1/page/printDoc.dart';
import 'package:open_document/open_document.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import 'chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/page/firesbase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart' as globals;
import 'package:path_provider/path_provider.dart';
//import 'package:syncfusion_flutter_pdf/pdf.dart';

//  https://www.youtube.com/watch?v=mRAoet5emfo

FirebaseFirestore db = FirebaseFirestore.instance;

class Pedido {
  String item;
  String cantidad;
  String precio;
  Pedido({required this.item, required this.cantidad, required this.precio});
  Map<String, dynamic> toJson() =>
      {"item": item, "cantidad": cantidad, "precio": precio};
}

class Agencia {
  String agencia;
  Agencia({required this.agencia});
  Map<String, dynamic> toJson() => {"agencia": agencia};
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool merienda = false;
  bool baja = false;
  bool reposicion = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController itemController = TextEditingController();
  TextEditingController cantidadController = TextEditingController();
  TextEditingController precioController = TextEditingController();

  TextEditingController nombreclienteController = TextEditingController();
  TextEditingController mesaController = TextEditingController();
  TextEditingController numeroComandaController = TextEditingController();
  List<Pedido> pedido = List.empty(growable: true);
  //List<Agencia> agencia = List.empty(growable: true);
  TextEditingController textarea = TextEditingController();
  String? _autocompleteSelection;
  CollectionReference _referenceProductosList =
      FirebaseFirestore.instance.collection('productos');

  String? _selectedVal = "Cafe";
  //String? _selectedVal1 = "";
  int _itemCount = 0;
  int selectedIndex = 0;
  List newList = [];
  List newListPrecio = [];
  double _totalConsumo = 0;
  List newAgenciaList = [];
  bool disableDropdown = true;
  String? agenciaa;
  String? productoo;
  String numeroComandaContr = '0';

  void showAlert(QuickAlertType quickAlertType, String mensaje) {
    QuickAlert.show(
        context: context, type: quickAlertType, text: mensaje, width: 100);
  }

  populate(String AgenciaSelec) async {
    var data = await getProductos(AgenciaSelec);

    if (data.isNotEmpty) {
      globals.newList = [];
      globals.newListPrecio = [];
      int i = 0;
      String jsonstringmap = json.encode(data);
      data?.forEach((item) {
        globals.newList.add(item['item']);
        globals.newListPrecio.add(item['precio']);
        if (i == 0) {
          productoo = item['item'];
        }
        i = i + 1;
      });
      newAgenciaList = globals.newAgenciaList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: AppBar(
              title: Text(
            'Comanda Nro.--> ' + numeroComandaContr,
            style: TextStyle(color: Colors.black, fontSize: 12),
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // SizedBox(height: 10),
              FutureBuilder(
                  future: getAgencias(),
                  builder: ((context, snapshop) {
                    if (snapshop.hasData) {
                      globals.newAgenciaList = [];
                      String jsonstringmap = json.encode(snapshop.data);
                      snapshop.data?.forEach((item) {
                        globals.newAgenciaList.add(item['agencia']);
                      });
                      newAgenciaList = globals.newAgenciaList;
                    }
                    return DropdownButtonFormField(
                        borderRadius: BorderRadius.circular(20),
                        decoration: InputDecoration(
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(8),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(width: 3, color: Colors.grey),
                          ),
                        ),
                        hint: Text(
                          'Seleccione Agencia para Comandas',
                          style: TextStyle(
                              color: Colors.black, fontSize: 10, height: 2.0),
                        ),
                        isExpanded: true,
                        menuMaxHeight: 350,
                        iconSize: 36,
                        style: TextStyle(
                            color: Colors.black, fontSize: 10, height: 2.0),
                        items: globals.newAgenciaList
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item,
                                      style:
                                          TextStyle(fontSize: 10, height: 2.0)),
                                ))
                            .toList(),
                        onChanged: pedido.isNotEmpty
                            ? null
                            : (item) {
                                setState(() {
                                  globals.agenciaSeleccionada = item.toString();
                                  populate(globals.agenciaSeleccionada);
                                  disableDropdown = false;
                                  productoo = null;
                                });
                              }

//              onChanged: (item) => setState(() => _selectedVal1 = item),
                        );
                  })),
              //           Text('AGENCIA  --->  ' + globals.agenciaSeleccionada),
/*            SizedBox(height: 10),
            TextField(
              controller: nombreclienteController,
              decoration: InputDecoration(
                  hintText: "Nombre cliente",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),*/
              //      SizedBox(height: 10),
              TextField(
                style: TextStyle(fontSize: 10.0, height: 2.5),
                controller: mesaController,
                decoration: InputDecoration(
                    isDense: true, // Added this
                    contentPadding: EdgeInsets.all(8),
                    hintText: "Numero de Mesa",
                    hintStyle: TextStyle(fontSize: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              //    SizedBox(height: 10),

              //   SizedBox(height: 10),
              FutureBuilder(
                  future: getProductos(globals.agenciaSeleccionada),
                  builder: ((context, snapshop) {
                    if (snapshop.hasData) {
                      globals.newList = [];
                      globals.newListPrecio = [];
                      String jsonstringmap = json.encode(snapshop.data);
                      snapshop.data?.forEach((item) {
                        globals.newList.add(item['item']);
                        globals.newListPrecio.add(item['precio']);
                      });
                      newList = globals.newList;
                      newListPrecio = globals.newListPrecio;
                    }
                    return DropdownButtonFormField(
                        borderRadius: BorderRadius.circular(20),
                        decoration: InputDecoration(
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(8),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(width: 3, color: Colors.grey),
                          ),
                        ),
                        hint: Text(
                          'Seleccione un Producto',
                          style: TextStyle(color: Colors.black, fontSize: 10),
                        ),
                        isExpanded: true,
                        menuMaxHeight: 350,
                        iconSize: 36,
                        value: productoo,
                        style: TextStyle(color: Colors.black, fontSize: 10),
                        items: globals.newList
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item,
                                      style: TextStyle(fontSize: 10)),
                                ))
                            .toList(),
                        onChanged: disableDropdown
                            ? null
                            : (item) {
                                setState(() {
                                  _selectedVal = item as String?;
                                });
                              });
                  })),
              //    SizedBox(height: 10),
              TextField(
                style: TextStyle(fontSize: 10.0, height: 2.5),
                controller: cantidadController,
                decoration: InputDecoration(
                    isDense: true, // Added this
                    contentPadding: EdgeInsets.all(8),
                    hintText: "Inserte Cantidad",
                    hintStyle: TextStyle(fontSize: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              //    SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    /*          child: SizedBox(
                    height: 35, //height of button
                    width: 35, //width of button*/

                    child: ElevatedButton(
                        /* style: ElevatedButton.styleFrom(
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
                        onPressed: () async {
                          if (cantidadController.text.isNotEmpty) {
                            int totalComandas = await collectionSumValue();

                            numeroComandaContr = totalComandas.toString();
                            String mensajeAControlador = numeroComandaContr;
                            numeroComandaController.text = mensajeAControlador;

                            String cantidad = cantidadController.text;
                            String item = _selectedVal ?? "";
                            final precio = await getPrecioOfAProductos(
                                globals.agenciaSeleccionada, item);
                            _totalConsumo = _totalConsumo +
                                (precio[0]['precio'] * int.parse(cantidad));
                            globals.totalConsumo = _totalConsumo;
                            globals.bandera = 1;
                            if (item.isNotEmpty &&
                                cantidad.isNotEmpty &&
                                globals.bandera == 1) {
                              setState(() {
                                itemController.text = '';
                                cantidadController.text = '';
                                precioController.text = '';
                                globals.comandaLista = [];
                                pedido.add(Pedido(
                                    item: item,
                                    cantidad: cantidad,
                                    precio: globals.precioo.toString()));
                                globals.comandaLista = pedido;
                                globals.sucursal = globals.agenciaSeleccionada;
                                if (mesaController.text.isEmpty) {
                                  mesaController.text = '0';
                                }
                                globals.numeroMesa =
                                    int.parse(mesaController.text);
                                if (nombreclienteController.text.isEmpty) {
                                  nombreclienteController.text = "coffeina";
                                }
                                globals.nombreCliente =
                                    nombreclienteController.text;
                                if (numeroComandaController.text.isEmpty) {
                                  numeroComandaController.text = '0';
                                }
                                globals.numeroComanda =
                                    int.parse(numeroComandaController.text);
                                collectionSum();
                              });
                            }
                          } else {
                            showAlert(
                                QuickAlertType.error, 'Debe armar la Comanda.');
                          }
                        },
                        child: Text('Armar la Comanda',
                            style: TextStyle(fontSize: 10))),
                  ) //)
                ],
              ),
              //       SizedBox(height: 10),
              Text(
                '---> TOTAL A CONSUMIR: ${_totalConsumo.toStringAsFixed(2)} Bs.',
                style: TextStyle(fontSize: 15),
              ),
              //     SizedBox(height: 20),
              pedido.isEmpty
                  ? Text("comanda vacia", style: TextStyle(fontSize: 15))
                  : Expanded(
                      child: ListView.builder(
                      itemCount: pedido.length,
                      itemBuilder: (context, index) => getRow(index),
                    ))
            ],
          ),
        ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: 'Grabar Comanda',
            onPressed: () {
              if (globals.comandaLista.isNotEmpty) {
                collectionSum();
                addComanda(
                    globals.comandaLista,
                    globals.nombreCliente,
                    globals.numeroMesa,
                    globals.numeroComanda,
                    globals.sucursal,
                    globals.countComandas,
                    globals.totalConsumo,
                    'No Cobrado');
                var user = jsonEncode(globals.comandaLista);
                String user1 = user;
                var ab = json.decode(user1).toList();
                printDoc1(
                    globals.numeroComanda,
                    globals.nombreCliente,
                    globals.numeroMesa,
                    globals.sucursal,
                    ab,
                    globals.totalConsumo,
                    1);
                _totalConsumo = 0;

                //    showAlert(QuickAlertType.success);
              } else {
                showAlert(QuickAlertType.error, 'Debe armar la Comanda.');
              }
              globals.comandaLista = [];
              globals.nombreCliente = "";
              collectionSum();
              globals.bandera = 1;
              itemController.text = '';
              cantidadController.text = '';
              mesaController.text = '';
              nombreclienteController.text = '';
              numeroComandaController.text = '';
              pedido.clear();
              pedido = [];

              setState(() {
                productoo = null;
              });
              /*   Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));*/
            },
          ),
          FloatingActionButton(
            tooltip: 'Limpiar Comanda',
            child: Icon(Icons.remove),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Container(
                        child: AlertDialog(
                      title: Text('Confirmar Limpieza de Comanda ?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {});
                          },
                          child: Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            globals.comandaLista = [];
                            globals.nombreCliente = "";
                            collectionSum();
                            globals.bandera = 1;
                            itemController.text = '';
                            cantidadController.text = '';
                            mesaController.text = '';
                            nombreclienteController.text = '';
                            numeroComandaController.text = '';
                            pedido.clear();
                            pedido = [];
                            _totalConsumo = 0;

                            Navigator.pop(context);
                            setState(() {
                              productoo = null;
                            });
                          },
                          child: Text('Si'),
                        ),
                      ],
                    ));
                  });

/*              globals.comandaLista = [];
              globals.nombreCliente = "";
              collectionSum();
              globals.bandera = 1;
              itemController.text = '';
              cantidadController.text = '';
              mesaController.text = '';
              nombreclienteController.text = '';
              numeroComandaController.text = '';
              pedido.clear();
              pedido = [];
              _totalConsumo = 0;
              setState(() {
                productoo = null;
              });*/
              /*   Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));*/
            },
          ),
          FloatingActionButton(
            tooltip: 'Merendar',
            child: Icon(Icons.person),
            onPressed: () async {
              if (globals.comandaLista.isNotEmpty) {
                collectionSum();

                await showDialog(
                    context: context,
                    builder: (context) {
                      return Container(
                          child: AlertDialog(
                        title: Text('Confirmar Merienda ?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              merienda = false;
                              Navigator.pop(context);
                              setState(() {});
                            },
                            child: Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              merienda = true;
                              addMerendar(
                                  globals.comandaLista,
                                  globals.nombreCliente,
                                  globals.numeroMesa,
                                  globals.numeroComanda,
                                  globals.sucursal,
                                  globals.countComandas,
                                  globals.totalConsumo,
                                  'Merendar');
                              Navigator.pop(context);

                              setState(() {});
                            },
                            child: Text('Si'),
                          ),
                        ],
                      ));
                    });
                var user = jsonEncode(globals.comandaLista);
                String user1 = user;
                var ab = json.decode(user1).toList();
                /*         printDoc1(
                    globals.numeroComanda,
                    globals.nombreCliente,
                    globals.numeroMesa,
                    globals.sucursal,
                    ab,
                    globals.totalConsumo,
                    1);*/
                _totalConsumo = 0;

                globals.comandaLista = [];
                globals.nombreCliente = "";
                collectionSum();
                globals.bandera = 1;
                itemController.text = '';
                cantidadController.text = '';
                mesaController.text = '';
                nombreclienteController.text = '';
                numeroComandaController.text = '';
                pedido.clear();
                pedido = [];
                if (merienda) {
                  //        showAlert(QuickAlertType.success);
                }
              } else {
                showAlert(QuickAlertType.error, 'Debe armar la Comanda.');
              }
              setState(() {
                productoo = null;
              });
            },
          ),
          FloatingActionButton(
            tooltip: 'Baja de Items',
            child: Icon(Icons.filter_list),
            onPressed: () async {
              if (globals.comandaLista.isNotEmpty) {
                collectionSum();
                await showDialog(
                    context: context,
                    builder: (context) {
                      return Container(
                          child: AlertDialog(
                        title: Text('Confirmar Baja ?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              baja = false;
                              Navigator.pop(context);
                              setState(() {});
                            },
                            child: Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              baja = true;
                              // descuento =
                              //   descuentoField.text='';
                              addDarDeBaja(
                                  globals.comandaLista,
                                  globals.nombreCliente,
                                  globals.numeroMesa,
                                  globals.numeroComanda,
                                  globals.sucursal,
                                  globals.countComandas,
                                  globals.totalConsumo,
                                  'Baja');

                              Navigator.pop(context);

                              setState(() {});
                            },
                            child: Text('Si'),
                          ),
                        ],
                      ));
                    });

                var user = jsonEncode(globals.comandaLista);
                String user1 = user;
                var ab = json.decode(user1).toList();

                /*         printDoc1(
                    globals.numeroComanda,
                    globals.nombreCliente,
                    globals.numeroMesa,
                    globals.sucursal,
                    ab,
                    globals.totalConsumo,
                    1);*/
                _totalConsumo = 0;
                if (baja) {
                  //     showAlert(QuickAlertType.success);
                }
              } else {
                showAlert(QuickAlertType.error, 'Debe armar la Comanda.');
              }
              globals.comandaLista = [];
              globals.nombreCliente = "";
              collectionSum();
              globals.bandera = 1;
              itemController.text = '';
              cantidadController.text = '';
              mesaController.text = '';
              nombreclienteController.text = '';
              numeroComandaController.text = '';
              pedido.clear();
              pedido = [];

              setState(() {
                productoo = null;
              });
            },
          ),
          FloatingActionButton(
            tooltip: 'Reposicion',
            child: Icon(Icons.send),
            onPressed: () async {
              if (globals.comandaLista.isNotEmpty) {
                collectionSum();
                await showDialog(
                    context: context,
                    builder: (context) {
                      return Container(
                          child: AlertDialog(
                        title: Text('Confirmar Reposicion ?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              reposicion = false;
                              Navigator.pop(context);
                              setState(() {});
                            },
                            child: Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              reposicion = true;
                              // descuento =rte
                              //   descuentoField.text='';
                              addReposicion(
                                  globals.comandaLista,
                                  globals.nombreCliente,
                                  3000,
                                  globals.numeroComanda,
                                  globals.sucursal,
                                  globals.countComandas,
                                  globals.totalConsumo,
                                  'Reposicion');
                              Navigator.pop(context);
                              //        showAlert(QuickAlertType.success);
                              setState(() {});
                            },
                            child: Text('Si'),
                          ),
                        ],
                      ));
                    });
                var user = jsonEncode(globals.comandaLista);
                String user1 = user;
                var ab = json.decode(user1).toList();

                /*         printDoc1(
                    globals.numeroComanda,
                    globals.nombreCliente,
                    globals.numeroMesa,
                    globals.sucursal,
                    ab,
                    globals.totalConsumo,
                    1);*/
                _totalConsumo = 0;
                if (reposicion) {
                  //        showAlert(QuickAlertType.success);
                }
              } else {
                showAlert(QuickAlertType.error, 'Debe armar la Comanda.');
              }
              globals.comandaLista = [];
              globals.nombreCliente = "";
              collectionSum();
              globals.bandera = 1;
              itemController.text = '';
              cantidadController.text = '';
              mesaController.text = '';
              nombreclienteController.text = '';
              numeroComandaController.text = '';
              pedido.clear();
              pedido = [];

              setState(() {
                productoo = null;
              });
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
            pedido[index].item[0],
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pedido[index].item,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            Text(
                style: TextStyle(fontSize: 10),
                'Cantidad: ${pedido[index].cantidad}  -->  Precio Unitario: ${pedido[index].precio} Bs.'),
            Text(
              'Total del Item: ${(int.parse(pedido[index].cantidad) * double.parse(pedido[index].precio)).toStringAsFixed(2)} Bs.',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        trailing: SizedBox(
          width: 90,
          child: Row(
            children: [
              /*             InkWell(
                  onTap: () {
                    itemController.text = pedido[index].item;
                    cantidadController.text = pedido[index].cantidad;
                  },
                  child: Icon(Icons.edit)),*/
              InkWell(
                  onTap: (() {
                    setState(() {
                      _totalConsumo = _totalConsumo -
                          int.parse(pedido[index].cantidad) *
                              double.parse(pedido[index].precio);
                      pedido.removeAt(index);
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
