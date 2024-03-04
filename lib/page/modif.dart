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
  String datoAdicional;
  Pedido(
      {required this.item,
      required this.cantidad,
      required this.precio,
      required this.datoAdicional});
  Map<String, dynamic> toJson() => {
        "item": item,
        "cantidad": cantidad,
        "precio": precio,
        "datoAdicional": datoAdicional
      };
}

class Agencia {
  String agencia;
  Agencia({required this.agencia});
  Map<String, dynamic> toJson() => {"agencia": agencia};
}

class Modif extends StatefulWidget {
  @override
  _ModifState createState() => _ModifState();
}

class _ModifState extends State<Modif> {
  bool merienda = false;
  bool baja = false;
  bool reposicion = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController itemController = TextEditingController();
  TextEditingController cantidadController = TextEditingController();
  TextEditingController datoAdicionalController = TextEditingController();
  TextEditingController precioController = TextEditingController();
  TextEditingController agenciaController = TextEditingController();
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
  bool typing = false;
  bool _isPressed = false;

  void _myCallback() {
    setState(() {
      _isPressed = true;
    });
  }

  @override
  void initState() {
    super.initState();
    globals.numeroDeComanda = 0;
    globals.agenciaSeleccionada = '';
  }

  void showAlert(QuickAlertType quickAlertType) {
    QuickAlert.show(context: context, type: quickAlertType, width: 100);
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
            title: typing
                ? TextBox()
                : Text('Nro de Comanda - ' + globals.numeroDeComanda.toString(),
                    style: TextStyle(fontSize: 20)),
            leading: IconButton(
              icon: Icon(typing ? Icons.done : Icons.search),
              onPressed: () async {
                if (typing == false) {
                  _totalConsumo = 0;
                  globals.comandaLista = [];
                  cantidadController.text = '';
                  datoAdicionalController.text = '';
                  mesaController.text = '';
                  pedido.clear();
                  pedido = [];
                  globals.bandera = 1;
                  globals.numeroDeComanda = 0;
                  globals.agenciaSeleccionada = '';
                  productoo = null;
                }
                if (globals.numeroDeComanda != 0) {
                  List<dynamic> comanda =
                      await getAComandaFromNumero(globals.numeroDeComanda);
                  comanda.forEach((item) {
                    mesaController.text = item['mesa'].toString();
                    globals.agenciaSeleccionada = item['agencia'];
                    globals.nombreCliente = item['nombreCliente'];
                    globals.numeroMesa = int.parse(mesaController.text);
                    print('mesa');
                    print(globals.numeroMesa);
                    print(mesaController.text);
                    globals.numeroComanda = globals.numeroDeComanda;
                    globals.sucursal = item['agencia'];
                  });
                  _totalConsumo = 0;
                  List<dynamic> comanda1 =
                      await getAComandaFromNumero1(globals.numeroDeComanda);
                  comanda1.forEach((item) {
                    pedido.add(Pedido(
                        item: item['item'],
                        cantidad: item['cantidad'].toString(),
                        precio: item['precio'].toString(),
                        datoAdicional: item['datoAdicional']));
                    //        globals.ListaParaBorrar.add(item['id']);
                    _totalConsumo =
                        _totalConsumo + (item['precio'] * item['cantidad']);
                    globals.totalConsumo = _totalConsumo;
                  });

                  globals.comandaLista = [];

                  globals.comandaLista = pedido;
                  List<dynamic> productoss =
                      await getProductos(globals.agenciaSeleccionada) as List;
                  globals.newList = [];
                  globals.newListPrecio = [];
                  productoss.forEach((item) {
                    globals.newList.add(item['item']);
                    globals.newListPrecio.add(item['precio']);
                  });
                  newList = globals.newList;
                  newListPrecio = globals.newListPrecio;
                }
                //  mesaController.text = comanda[0];
                setState(() {
                  typing = !typing;
                });
              },
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              globals.agenciaSeleccionada != ''
                  ? TextField(
                      style: TextStyle(fontSize: 15.0, height: 2.5),
                      controller: mesaController,
                      decoration: InputDecoration(
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(8),
                          hintText: "Numero de Mesa",
                          hintStyle: TextStyle(fontSize: 15),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    )
                  : Center(),
              globals.agenciaSeleccionada != ''
                  ? DropdownButtonFormField(
                      decoration: InputDecoration(
                        isDense: true, // Added this
                        contentPadding: EdgeInsets.all(8),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(width: 3, color: Colors.grey),
                        ),
                      ),
                      hint: Text(
                        'Seleccione un Producto',
                        //  style: TextStyle(color: Colors.black, fontSize: 10),
                      ),
                      isExpanded: true,
                      menuMaxHeight: 350,
                      iconSize: 36,
                      value: productoo,
                      style: TextStyle(color: Colors.black, fontSize: 15),
                      items: globals.newList
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  //  style: TextStyle(fontSize: 10)
                                ),
                              ))
                          .toList(),
                      onChanged: /*disableDropdown
                      ? null
                      :*/
                          (item) {
                        setState(() {
                          _selectedVal = item as String?;
                        });
                      })
                  : Center(),
              //    },
              //  ),
              //    SizedBox(height: 10),
              globals.agenciaSeleccionada != ''
                  ? TextField(
                      style: TextStyle(fontSize: 15.0, height: 2.5),
                      controller: cantidadController,
                      decoration: InputDecoration(
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(8),
                          hintText: "Inserte Cantidad",
                          hintStyle: TextStyle(fontSize: 15),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    )
                  : Center(),
              //    SizedBox(height: 10),
              globals.agenciaSeleccionada != ''
                  ? TextField(
                      style: TextStyle(fontSize: 15.0, height: 2.5),
                      controller: datoAdicionalController,
                      decoration: InputDecoration(
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(8),
                          hintText: "Inserte Dato adicional del producto",
                          hintStyle: TextStyle(fontSize: 15),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      /* keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],*/
                    )
                  : Center(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  globals.agenciaSeleccionada != ''
                      ? Center(
                          child: ElevatedButton(
                              onPressed: () async {
                                if (cantidadController.text.isNotEmpty) {
                                  int totalComandas =
                                      await collectionSumValue();

                                  numeroComandaContr = totalComandas.toString();
                                  String mensajeAControlador =
                                      numeroComandaContr;
                                  numeroComandaController.text =
                                      mensajeAControlador;

                                  String cantidad = cantidadController.text;
                                  String datoAdicional1 =
                                      datoAdicionalController.text;
                                  String item = _selectedVal ?? "";
                                  final precio = await getPrecioOfAProductos(
                                      globals.agenciaSeleccionada, item);
                                  _totalConsumo = _totalConsumo +
                                      (precio[0]['precio'] *
                                          int.parse(cantidad));
                                  globals.totalConsumo = _totalConsumo;
                                  globals.bandera = 1;
                                  if (item.isNotEmpty &&
                                      cantidad.isNotEmpty &&
                                      globals.bandera == 1) {
                                    setState(() {
                                      itemController.text = '';
                                      cantidadController.text = '';
                                      datoAdicionalController.text = '';
                                      precioController.text = '';
                                      globals.comandaLista = [];
                                      pedido.add(Pedido(
                                          item: item,
                                          cantidad: cantidad,
                                          precio: globals.precioo.toString(),
                                          datoAdicional: datoAdicional1));
                                      globals.comandaLista = pedido;
                                      globals.sucursal =
                                          globals.agenciaSeleccionada;
                                      if (mesaController.text.isEmpty) {
                                        mesaController.text = '0';
                                      }
                                      globals.numeroMesa =
                                          int.parse(mesaController.text);
                                      if (nombreclienteController
                                          .text.isEmpty) {
                                        nombreclienteController.text =
                                            "coffeina";
                                      }
                                      globals.nombreCliente =
                                          nombreclienteController.text;
                                      if (numeroComandaController
                                          .text.isEmpty) {
                                        numeroComandaController.text = '0';
                                      }
                                      globals.numeroComanda = int.parse(
                                          numeroComandaController.text);
                                      collectionSum();
                                    });
                                  }
                                } else {
                                  showAlert(QuickAlertType.error);
                                }
                              },
                              child: Text('Armar la Comanda',
                                  style: TextStyle(fontSize: 15))),
                        )
                      : Center()
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
          globals.agenciaSeleccionada != ''
              ? FloatingActionButton(
                  child: Icon(Icons.add),
                  tooltip: 'Grabar Comanda',
                  onPressed: () async {
                    _isPressed == false ? _myCallback : null;
                    if (globals.comandaLista.isNotEmpty) {
                      await deleteComanda(globals.numeroDeComanda);
                      collectionSum();
                      print('mesa1');
                      print(globals.numeroMesa);
                      print(mesaController.text);
                      globals.totalConsumo = _totalConsumo;
                      await aupdateComanda(
                          globals.comandaLista,
                          globals.nombreCliente,
                          int.parse(mesaController.text), //globals.numeroMesa,
                          globals.numeroDeComanda,
                          globals.sucursal,
                          globals.countComandas,
                          globals.totalConsumo,
                          'No Cobrado');

                      var user = jsonEncode(globals.comandaLista);
                      String user1 = user;
                      var ab = json.decode(user1).toList();
                      /* */ globals.totalConsumo = _totalConsumo;
                      printDoc1(
                          globals.numeroDeComanda,
                          globals.nombreCliente,
                          int.parse(mesaController.text),
                          globals.sucursal,
                          ab,
                          globals.totalConsumo,
                          1);
                      _totalConsumo = 0;

                      //    showAlert(QuickAlertType.success);
                    } else {
                      showAlert(QuickAlertType.error);
                    }
                    globals.comandaLista = [];
                    globals.nombreCliente = "";
                    collectionSum();
                    globals.bandera = 1;
                    itemController.text = '';
                    cantidadController.text = '';
                    datoAdicionalController.text = '';
                    mesaController.text = '';
                    nombreclienteController.text = '';
                    numeroComandaController.text = '';
                    pedido.clear();
                    pedido = [];
                    globals.numeroDeComanda = 0;
                    globals.agenciaSeleccionada = '';
                    setState(() {
                      productoo = null;
                    });
                    /*   Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));*/
                  },
                )
              : Center(),
          globals.agenciaSeleccionada != ''
              ? FloatingActionButton(
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
                                  collectionSum();
                                  globals.bandera = 1;
                                  itemController.text = '';
                                  cantidadController.text = '';
                                  datoAdicionalController.text = '';
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
/*




                    globals.comandaLista = [];
                    collectionSum();
                    globals.bandera = 1;
                    itemController.text = '';
                    cantidadController.text = '';

                    pedido.clear();
                    pedido = [];
                    _totalConsumo = 0;
                    setState(() {
                      productoo = null;
                    });*/
                    /*   Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));*/
                  },
                )
              : Center(),
          globals.agenciaSeleccionada != ''
              ? FloatingActionButton(
                  tooltip: 'Borrar Comanda',
                  child: Icon(Icons.not_interested),
                  onPressed: () {
                    if (globals.password == 'patitoalejo') {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Container(
                                child: AlertDialog(
                              title: Text('Confirmar Eliminacion de Comanda ?'),
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
                                    if (globals.comandaLista.isNotEmpty) {
                                      await deleteComandaParaEliminar(
                                          globals.numeroDeComanda);
                                      collectionSum();
                                      /*     print('mesa1');
                                      print(globals.numeroMesa);
                                      print(mesaController.text);*/
                                      globals.totalConsumo = _totalConsumo;
                                      await aupdateComandaparaEliminar(
                                          globals.comandaLista,
                                          globals.nombreCliente,
                                          int.parse(mesaController
                                              .text), //globals.numeroMesa,
                                          globals.numeroDeComanda,
                                          globals.sucursal,
                                          globals.countComandas,
                                          0,
                                          'Eliminado');

                                      /* var user =
                                          jsonEncode(globals.comandaLista);
                                      String user1 = user;
                                      var ab = json.decode(user1).toList();
                                       globals.totalConsumo =
                                          _totalConsumo;
                                      printDoc1(
                                          globals.numeroDeComanda,
                                          globals.nombreCliente,
                                          int.parse(mesaController.text),
                                          globals.sucursal,
                                          ab,
                                          globals.totalConsumo,
                                          1);*/
                                      _totalConsumo = 0;

                                      //    showAlert(QuickAlertType.success);
                                    } else {
                                      showAlert(QuickAlertType.error);
                                    }
                                    globals.comandaLista = [];
                                    globals.nombreCliente = "";
                                    collectionSum();
                                    globals.bandera = 1;
                                    itemController.text = '';
                                    cantidadController.text = '';
                                    datoAdicionalController.text = '';
                                    mesaController.text = '';
                                    nombreclienteController.text = '';
                                    numeroComandaController.text = '';
                                    pedido.clear();
                                    pedido = [];
                                    globals.numeroDeComanda = 0;
                                    globals.agenciaSeleccionada = '';
                                    Navigator.pop(context);
                                    setState(() {
                                      productoo = null;
                                    });
                                    /*   Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));*/
                                  },
                                  child: Text('Si'),
                                ),
                              ],
                            ));
                          });
/*




                    globals.comandaLista = [];
                    collectionSum();
                    globals.bandera = 1;
                    itemController.text = '';
                    cantidadController.text = '';

                    pedido.clear();
                    pedido = [];
                    _totalConsumo = 0;
                    setState(() {
                      productoo = null;
                    });*/
                      /*   Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));*/
                    } else {
                      showAlert(QuickAlertType.warning);
                    }
                  },
                )
              : Center()
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
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pedido[index].item,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
                style: TextStyle(fontSize: 15),
                'Cantidad: ${pedido[index].cantidad}  -->  Precio Unitario: ${pedido[index].precio} Bs.'),
            Text(
              'Total del Item: ${(int.parse(pedido[index].cantidad) * double.parse(pedido[index].precio)).toStringAsFixed(2)} Bs.',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
              globals.agenciaSeleccionada != ''
                  ? InkWell(
                      onTap: (() {
                        setState(() {
                          _totalConsumo = _totalConsumo -
                              int.parse(pedido[index].cantidad) *
                                  double.parse(pedido[index].precio);
                          pedido.removeAt(index);
                        });
                      }),
                      child: Icon(Icons.delete))
                  : Center()
            ],
          ),
        ),
      ),
    );
  }
}

class TextBox extends StatelessWidget {
  TextEditingController comandaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.white,
      child: TextField(
        controller: comandaController,
        decoration: InputDecoration(
            isDense: true, // Added this
            contentPadding: EdgeInsets.all(8),
            border: InputBorder.none,
            hintText: 'Buscar Comanda'),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) {
          globals.numeroDeComanda = int.parse(value);
        },
      ),
    );
  }
}
