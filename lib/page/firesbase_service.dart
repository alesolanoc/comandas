import 'dart:convert';
import 'globals.dart' as globals;
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
//int countComandas = 0;

Future<List> getComandasForADay(
    String agencia, String fecha, String status) async {
  List comandas = [];
  double total = 0;
  int i = 0;
  CollectionReference collectionReferenceComanda =
      db.collection('comandaCabecera');
  QuerySnapshot querycomandas = await collectionReferenceComanda
      .where('agencia', isEqualTo: agencia)
      .where('creacionDate', isEqualTo: fecha)
      .where('status', isEqualTo: status)
      .get();
  querycomandas.docs.forEach((documento) {
    //   print(documento.data());
    comandas.add(documento.data());
    var user = jsonEncode(comandas);
    String user1 = user;
    var ab = json.decode(user1).toList();
    total = ab[i]['totalConsumo'];
    i = i + 1;
  });
/*  comandas.forEach((element) {
    total = total +double.parse(comandas['totalConsumo']);
  })*/

  return comandas;
}

/*

List getComandasForADay1(
    String agencia, String fecha, String status)  {
  List comandas = [];
  double total = 0;
  int i = 0;
 void readData(){
  databaseReference.once().then((DataSnapshot snapshot) {
    print('Data : ${snapshot.value}');
  });
}
  querycomandas.docs.forEach((documento) {
    //   print(documento.data());
    comandas.add(documento.data());
    var user = jsonEncode(comandas);
    String user1 = user;
    var ab = json.decode(user1).toList();
    total = ab[i]['totalConsumo'];
    i = i + 1;
  });
/*  comandas.forEach((element) {
    total = total +double.parse(comandas['totalConsumo']);
  })*/

  return comandas;
}
*/
Future<List> getAllProducts(String agencia, int opcion, bool check3) async {
  List productos = [];
  CollectionReference collectionReferenceproductos = db.collection('productos');
  if ((opcion == 1) || (opcion == 2) || (opcion == 3)) {
    if (agencia != 'Todo') {
      QuerySnapshot queryproductos = await collectionReferenceproductos
          .where('agencia', isEqualTo: agencia)
          .get();
      queryproductos.docs.forEach((documento) {
        //     print(documento.data());
        productos.add(documento.data());
      });
    } /*else {
      // CollectionReference collectionReferenceComanda =
      //   db.collection('comandaCabecera');
      //  if (check3 == true) {
      QuerySnapshot queryproductos = await collectionReferenceproductos.get();
      queryproductos.docs.forEach((documento) {
        //print(documento.data());
        productos.add(documento.data());
      });
      //    }
    }*/
  }
  productos.sortBy(['item']);
  return productos;
}

Future<List> getProductos(String agencia) async {
  List productos = [];
  CollectionReference collectionReferenceComanda = db.collection('productos');
  QuerySnapshot queryProductos = await collectionReferenceComanda
      .where('agencia', isEqualTo: agencia)
      .orderBy('item')
      .get();
  queryProductos.docs.forEach((documento) {
    //print(documento.data());
    productos.add(documento.data());
  });
  return productos;
}

Future<List> getPrecioOfAProductos(String agencia, String producto) async {
  List productos = [];
  double precio = 0;
  int i = 0;
  CollectionReference collectionReferenceComanda = db.collection('productos');
  QuerySnapshot queryProductos = await collectionReferenceComanda
      .where('agencia', isEqualTo: agencia)
      .where('item', isEqualTo: producto)
      .get();
  queryProductos.docs.forEach((documento) {
    productos.add(documento.data());
    var user = jsonEncode(productos);
    String user1 = user;
    var ab = json.decode(user1).toList();
    precio = ab[i]['precio'];
    i = i + 1;
  });
  globals.precioo = precio;
  return productos;
}

extension SortBy on List {
  sortBy(List<String> keys) {
    this.sort((a, b) {
      for (int k = 0; k < keys.length; k++) {
        String key = keys[k];
        int comparison = Comparable.compare((a[key] ?? ""), (b[key] ?? ""));
        if (comparison != 0) {
          return comparison;
        }
      }
      return 0;
    });
  }
}

Future<List> getComandas(
    String agencia, String fecha, int opcion, bool check3) async {
  List comandas = [];
  CollectionReference collectionReferenceComanda =
      db.collection('comandaCabecera');
  if ((opcion == 1) || (opcion == 2) || (opcion == 3)) {
    if (agencia != 'Todo') {
      //   CollectionReference collectionReferenceComanda =
      //     db.collection('comandaCabecera');
      if (check3 == true) {
        QuerySnapshot querycomandas = await collectionReferenceComanda
            .where('agencia', isEqualTo: agencia)
            .where('creacionDate', isEqualTo: fecha)
            .where('status', isEqualTo: 'Cobrado')
            .get();
        querycomandas.docs.forEach((documento) {
          //     print(documento.data());
          comandas.add(documento.data());
        });
      } else {
        QuerySnapshot querycomandas = await collectionReferenceComanda
            .where('agencia', isEqualTo: agencia)
            .where('creacionDate', isEqualTo: fecha)
            .where('status', isEqualTo: 'No Cobrado')
            .get();
        querycomandas.docs.forEach((documento) {
          //      print(documento.data());
          comandas.add(documento.data());
        });
      }
    } else {
      // CollectionReference collectionReferenceComanda =
      //   db.collection('comandaCabecera');
      if (check3 == true) {
        QuerySnapshot querycomandas = await collectionReferenceComanda
            .where('creacionDate', isEqualTo: fecha)
            .where('status', isEqualTo: 'Cobrado')
            .get();
        querycomandas.docs.forEach((documento) {
          //print(documento.data());
          comandas.add(documento.data());
        });
      } else {
        QuerySnapshot querycomandas = await collectionReferenceComanda
            .where('creacionDate', isEqualTo: fecha)
            .where('status', isEqualTo: 'No Cobrado')
            .get();
        querycomandas.docs.forEach((documento) {
          //print(documento.data());
          comandas.add(documento.data());
        });
      }
    }
  } else {
    if (opcion == 4) {
      QuerySnapshot querycomandas = await collectionReferenceComanda
          .where('creacionDate', isEqualTo: fecha)
          .where('status', isEqualTo: 'Baja')
          .get();
      querycomandas.docs.forEach((documento) {
        //print(documento.data());
        comandas.add(documento.data());
      });
    }
    if (opcion == 5) {
      QuerySnapshot querycomandas = await collectionReferenceComanda
          .where('creacionDate', isEqualTo: fecha)
          .where('status', isEqualTo: 'Merendar')
          .get();
      querycomandas.docs.forEach((documento) {
        //print(documento.data());
        comandas.add(documento.data());
      });
    }
    if (opcion == 6) {
      QuerySnapshot querycomandas = await collectionReferenceComanda
          .where('creacionDate', isEqualTo: fecha)
          .where('status', isEqualTo: 'Reposicion')
          .get();
      querycomandas.docs.forEach((documento) {
        //print(documento.data());
        comandas.add(documento.data());
      });
    }
  }
  comandas.sortBy(['numeroComanda']);
  //comandas.sort((a, b) => a.numeroComanda.compareTo(b.numeroComanda));
  // print(comandas);
  /* querycomandas.docs.forEach((documento) {
    //print(documento.data());
    comandas.add(documento.data());
  });*/
  return comandas;
}

Future<int> collectionSumValue() async {
  var myRef = FirebaseFirestore.instance.collection('comandaCabecera');
  var snapshot = await myRef.count().get();
  globals.countComandas = snapshot.count;
  return globals.countComandas;
}

Future<List> getAComandaFromNumero(int codigoComanda) async {
  List comanda = [];
  CollectionReference collectionReferenceComanda =
      db.collection('comandaCabecera');
  QuerySnapshot querycomandas = await collectionReferenceComanda
      .where('numeroComanda', isEqualTo: codigoComanda)
      .where('status', isEqualTo: 'No Cobrado')
      .get();
  querycomandas.docs.forEach((documento) {
    comanda.add(documento.data());
  });
  //print('comanda');
  //print(comanda);
  //print(comanda);
  return comanda;
}

Future<List> getAComandaFromNumero1(int codigoComanda) async {
  List comanda = [];
  CollectionReference collectionReferenceComanda = db.collection('comanda');
  QuerySnapshot querycomandas = await collectionReferenceComanda
      .where('numeroComanda', isEqualTo: codigoComanda)
      .get();
  querycomandas.docs.forEach((documento) {
    comanda.add(documento.data());
  });
  //print('comanda');
  //print(comanda);
  //print(comanda);
  return comanda;
}

Future<List> getAComanda(String codigoComanda) async {
  List comanda = [];
  CollectionReference collectionReferenceComanda = db.collection('comanda');
  QuerySnapshot querycomandas = await collectionReferenceComanda
      .where('codigoComanda', isEqualTo: codigoComanda)
      .get();
  querycomandas.docs.forEach((documento) {
    comanda.add(documento.data());
  });
  // print('comanda');
  // print(comanda);
  //print(comanda);
  return comanda;
}

Future<List> getAComandaFromProductNameToPDF(
    String fecha, String agencia, String item) async {
  List comanda = [];

  CollectionReference collectionReferenceComanda = db.collection('comanda');
  QuerySnapshot querycomandas = await collectionReferenceComanda
      .where('item', isEqualTo: item)
      .where('agencia', isEqualTo: agencia)
      .where('creacionDate', isEqualTo: fecha)
      .get();
  querycomandas.docs.forEach((documento) {
    comanda.add(documento.data());
  });
  return comanda;
}

Future<List> getAComandaFromProductName(
    String fecha, String agencia, String item) async {
  List comanda = [];

  CollectionReference collectionReferenceComanda = db.collection('comanda');
  QuerySnapshot querycomandas = await collectionReferenceComanda
      .where('item', isEqualTo: item)
      .where('agencia', isEqualTo: agencia)
      .where('creacionDate', isEqualTo: fecha)
      .get();
  querycomandas.docs.forEach((documento) {
    comanda.add(documento.data());
  });
  return comanda;
}

Future<List> getAgencias() async {
  List agencias = [];
  CollectionReference collectionReferenceAgencia = db.collection('agencia');
  QuerySnapshot queryAgencias = await collectionReferenceAgencia.get();
  queryAgencias.docs.forEach((documento) {
    agencias.add(documento.data());
  });
  return agencias;
}

collectionSum() async {
  var myRef = FirebaseFirestore.instance.collection('comandaCabecera');
  var snapshot = await myRef.count().get();
  globals.countComandas = snapshot.count;
}

getLastComanda() async {
  List comanda = [];
  CollectionReference collectionReferenceComanda =
      db.collection('comandaCabecera');
  QuerySnapshot queryProductos = await collectionReferenceComanda
      .orderBy("codigoComanda", descending: true)
      .limit(1)
      .orderBy("creacionTime", descending: true)
      .get();
  queryProductos.docs.forEach((documento) {
    comanda.add(documento.data());
    // print(comanda);
  });
}

Future<void> addComanda(
    List<dynamic> comandaListaAGrabar,
    String nombreCliente,
    int mesa,
    int numeroComanda,
    String agencia,
    int countcomanda,
    double totalConsumo,
    String status) async {
  List<dynamic> data = comandaListaAGrabar;
  var user = jsonEncode(data);
  String user1 = user;
  // getLastComanda();
  DateTime current_date = DateTime.now();
  String dateStr = current_date.toString();
  var ab = json.decode(user1).toList();
  int i = 0;
  int elementCantidad = 0;

  String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String tdata = DateFormat("HH:mm:ss").format(DateTime.now());
  getLastComanda();
  collectionSum();
  db.collection("comandaCabecera").add({
    'agencia': agencia,
    'nombreCliente': nombreCliente,
    'mesa': mesa,
    'numeroComanda': globals.countComandas, //numeroComanda,
    'codigoComanda': dateStr,
    'creacionDate': cdate,
    'creacionTime': tdata,
    'totalConsumo': totalConsumo,
    'status': status,
    'descuento': 0
  });
  ab?.forEach((item) {
    elementCantidad = int.parse(ab[i]['cantidad']);
    db.collection("comanda").add({
      'agencia': agencia,
      'nombreCliente': nombreCliente,
      'mesa': mesa,
      'numeroComanda': globals.countComandas, //numeroComanda,
      'item': ab[i]['item'],
      'cantidad': elementCantidad,
      'precio': double.parse(ab[i]['precio']),
      'codigoComanda': dateStr,
      'creacionDate': cdate,
      'creacionTime': tdata
    });
    updateProduct(
        agencia, ab[i]['item'], elementCantidad, double.parse(ab[i]['precio']));
    i = i + 1;
  });
}

Future<void> aupdateComanda(
    List<dynamic> comandaListaAGrabar,
    String nombreCliente,
    int mesa,
    int numeroComanda,
    String agencia,
    int countcomanda,
    double totalConsumo,
    String status) async {
  List<dynamic> data = comandaListaAGrabar;
  String codigoComanda = '';
  String creacionDate = '';
  String creacionTime = '';
  var user = jsonEncode(data);
  String user1 = user;
  // getLastComanda();
  DateTime current_date = DateTime.now();
  String dateStr = current_date.toString();
  var ab = json.decode(user1).toList();
  int i = 0;
  int elementCantidad = 0;

  String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String tdata = DateFormat("HH:mm:ss").format(DateTime.now());

  List productos = [];
  int ii = 0;
  CollectionReference collectionReferenceProductos =
      db.collection('comandaCabecera');
  QuerySnapshot queryProductos = await collectionReferenceProductos
      .where('numeroComanda', isEqualTo: numeroComanda)
      .get();
  queryProductos.docs.forEach((documento) async {
    String iD = documento.id;
    productos.add(documento.data());
    var user = jsonEncode(productos);
    String user1 = user;
    var ab = json.decode(user1).toList();
    String agencia = ab[ii]['agencia'];
    codigoComanda = ab[ii]['codigoComanda'];
    creacionDate = ab[ii]['creacionDate'];
    creacionTime = ab[ii]['creacionTime'];
    //int mesa = ab[i]['mesa'];
    String nombreCliente = ab[ii]['nombreCliente'];
    int numeroComanda = ab[ii]['numeroComanda'];
    //double totalConsumo = ab[ii]['totalConsumo'];
    String status = ab[ii]['status'];
    ;
    double descuento = ab[ii]['descuento'];
    ;
    ii = ii + 1;
    await db.collection('comandaCabecera').doc(iD).set({
      'agencia': agencia,
      'codigoComanda': codigoComanda,
      'creacionDate': creacionDate,
      'creacionTime': creacionTime,
      'mesa': mesa,
      'nombreCliente': nombreCliente,
      'numeroComanda': numeroComanda,
      'totalConsumo': totalConsumo,
      'status': status,
      'descuento': descuento
    });
  });

  /* getLastComanda();
  collectionSum();
  db.collection("comandaCabecera").add({
    'agencia': agencia,
    'nombreCliente': nombreCliente,
    'mesa': mesa,
    'numeroComanda': globals.countComandas, //numeroComanda,
    'codigoComanda': dateStr,
    'creacionDate': cdate,
    'creacionTime': tdata,
    'totalConsumo': totalConsumo,
    'status': status,
    'descuento': 0
  });*/
  print('numeroDEDEComanda');
  print(numeroComanda);
  print('abababab');
  print(ab);
  ab.forEach((item) {
    elementCantidad = int.parse(ab[i]['cantidad']);
    print('ab[i][');
    print(ab[i]['item']);
    print(agencia);
    print(nombreCliente);
    db.collection("comanda").add({
      'agencia': agencia,
      'nombreCliente': nombreCliente,
      'mesa': mesa,
      'numeroComanda': numeroComanda, //numeroComanda,
      'item': ab[i]['item'],
      'cantidad': elementCantidad,
      'precio': double.parse(ab[i]['precio']),
      'codigoComanda': codigoComanda,
      'creacionDate': creacionDate,
      'creacionTime': creacionTime
    });
    updateProduct(
        agencia, ab[i]['item'], elementCantidad, double.parse(ab[i]['precio']));
    i = i + 1;
  });
}

Future<void> updateProduct(
    String agencia, String producto, int newCantidad, double precio) async {
  List productos = [];
  int i = 0;
  DateTime current_date = DateTime.now();
  String dateStr = current_date.toString();
  CollectionReference collectionReferenceProductos = db.collection('productos');
  QuerySnapshot queryProductos = await collectionReferenceProductos
      .where('agencia', isEqualTo: agencia)
      .where('item', isEqualTo: producto)
      .get();
  queryProductos.docs.forEach((documento) async {
    String iD = documento.id;
    productos.add(documento.data());
    var user = jsonEncode(productos);
    String user1 = user;
    var ab = json.decode(user1).toList();
    int cantidad = ab[i]['cantidad'];
    String item = ab[i]['item'];
    String agencia = ab[i]['agencia'];
    double preciop = ab[i]['precio'];
    String codigoProducto = ab[i]['codigoProducto'];
    String creacionDate = ab[i]['creacionDate'];
    String creacionTime = ab[i]['creacionTime'];
    cantidad = cantidad - newCantidad;
    i = i + 1;
    await db.collection('productos').doc(iD).set({
      'agencia': agencia,
      'item': item,
      'cantidad': cantidad,
      'precio': preciop,
      'codigoProducto': codigoProducto,
      'creacionDate': creacionDate,
      'creacionTime': creacionTime,
      'lastUpdate': dateStr
    });
  });

  // await db.collection('productos').doc(uid).set();
}

Future<void> updateProductMasCantidad(
    String agencia, String producto, int newCantidad, double precio) async {
  List productos = [];
  int i = 0;
  DateTime current_date = DateTime.now();
  String dateStr = current_date.toString();
  CollectionReference collectionReferenceProductos = db.collection('productos');
  QuerySnapshot queryProductos = await collectionReferenceProductos
      .where('agencia', isEqualTo: agencia)
      .where('item', isEqualTo: producto)
      .get();
  queryProductos.docs.forEach((documento) async {
    String iD = documento.id;
    productos.add(documento.data());
    var user = jsonEncode(productos);
    String user1 = user;
    var ab = json.decode(user1).toList();
    int cantidad = ab[i]['cantidad'];
    String item = ab[i]['item'];
    String agencia = ab[i]['agencia'];
    double preciop = ab[i]['precio'];
    String codigoProducto = ab[i]['codigoProducto'];
    String creacionDate = ab[i]['creacionDate'];
    String creacionTime = ab[i]['creacionTime'];
    cantidad = cantidad + newCantidad;
    i = i + 1;
    await db.collection('productos').doc(iD).set({
      'agencia': agencia,
      'item': item,
      'cantidad': cantidad,
      'precio': preciop,
      'codigoProducto': codigoProducto,
      'creacionDate': creacionDate,
      'creacionTime': creacionTime,
      'lastUpdate': dateStr
    });
  });

  // await db.collection('productos').doc(uid).set();
}

Future<void> updateProductReposicion(String agencia, String producto,
    int newCantidad, double precio, String agenciaReposicion) async {
  List productos = [];
  int i = 0;
  DateTime current_date = DateTime.now();
  String dateStr = current_date.toString();
  CollectionReference collectionReferenceProductos = db.collection('productos');
  QuerySnapshot queryProductos = await collectionReferenceProductos
      .where('agencia', isEqualTo: agencia)
      .where('item', isEqualTo: producto)
      .get();
  queryProductos.docs.forEach((documento) async {
    String iD = documento.id;
    productos.add(documento.data());
    var user = jsonEncode(productos);
    String user1 = user;
    var ab = json.decode(user1).toList();
    int cantidad = ab[i]['cantidad'];
    String item = ab[i]['item'];
    String agencia = ab[i]['agencia'];
    double preciop = ab[i]['precio'];
    String codigoProducto = ab[i]['codigoProducto'];
    String creacionDate = ab[i]['creacionDate'];
    String creacionTime = ab[i]['creacionTime'];
    cantidad = cantidad - newCantidad;
    i = i + 1;
    await db.collection('productos').doc(iD).set({
      'agencia': agencia,
      'item': item,
      'cantidad': cantidad,
      'precio': preciop,
      'codigoProducto': codigoProducto,
      'creacionDate': creacionDate,
      'creacionTime': creacionTime,
      'lastUpdate': dateStr
    });
  });
  CollectionReference collectionReferenceProductos1 =
      db.collection('productos');
  QuerySnapshot queryProductos1 = await collectionReferenceProductos1
      .where('agencia', isEqualTo: agenciaReposicion)
      .where('item', isEqualTo: producto)
      .get();
  queryProductos1.docs.forEach((documento) async {
    String iD = documento.id;
    productos.add(documento.data());
    var user = jsonEncode(productos);
    String user1 = user;
    var ab = json.decode(user1).toList();
    int cantidad = ab[i]['cantidad'];
    String item = ab[i]['item'];
    String agencia = ab[i]['agencia'];
    double preciop = ab[i]['precio'];
    String codigoProducto = ab[i]['codigoProducto'];
    String creacionDate = ab[i]['creacionDate'];
    String creacionTime = ab[i]['creacionTime'];
    cantidad = cantidad + newCantidad;
    i = i + 1;
    await db.collection('productos').doc(iD).set({
      'agencia': agenciaReposicion,
      'item': item,
      'cantidad': cantidad,
      'precio': preciop,
      'codigoProducto': codigoProducto,
      'creacionDate': creacionDate,
      'creacionTime': creacionTime,
      'lastUpdate': dateStr
    });
  });
  // await db.collection('productos').doc(uid).set();
}

Future<void> updateProductInventario(String agencia, String producto,
    int antiguaCantidad, String newCantidad, double precio) async {
  List productos = [];
  int i = 0;
  CollectionReference collectionReferenceProductos = db.collection('productos');
  QuerySnapshot queryProductos = await collectionReferenceProductos
      .where('agencia', isEqualTo: agencia)
      .where('item', isEqualTo: producto)
      .get();
  queryProductos.docs.forEach((documento) async {
    String iD = documento.id;
    productos.add(documento.data());
    var user = jsonEncode(productos);
    String user1 = user;
    var ab = json.decode(user1).toList();
    DateTime current_date = DateTime.now();
    String dateStr = current_date.toString();
    // print(ab[i]['cantidad']);
    int cantidad = ab[i]['cantidad'];
    String item = ab[i]['item'];
    String agencia = ab[i]['agencia'];
    String codigoProducto = ab[i]['codigoProducto'];
    String creacionDate = ab[i]['creacionDate'];
    String creacionTime = ab[i]['creacionTime'];
    int newCantidadTemp = 0;
    newCantidadTemp = int.parse(newCantidad);
    cantidad = antiguaCantidad + newCantidadTemp;
    i = i + 1;
    await db.collection('productos').doc(iD).set({
      'agencia': agencia,
      'item': item,
      'cantidad': cantidad,
      'precio': precio,
      'codigoProducto': codigoProducto,
      'creacionDate': creacionDate,
      'creacionTime': creacionTime,
      'lastUpdate': dateStr
    });
  });

  // await db.collection('productos').doc(uid).set();
}

Future<void> updateProductPrecio(
    String agencia, String producto, double precio) async {
  List productos = [];
  int i = 0;
  CollectionReference collectionReferenceProductos = db.collection('productos');
  QuerySnapshot queryProductos = await collectionReferenceProductos
      .where('agencia', isEqualTo: agencia)
      .where('item', isEqualTo: producto)
      .get();
  queryProductos.docs.forEach((documento) async {
    String iD = documento.id;
    productos.add(documento.data());
    var user = jsonEncode(productos);
    String user1 = user;
    var ab = json.decode(user1).toList();
    // print(ab[i]['cantidad']);
    int cantidad = ab[i]['cantidad'];
    String item = ab[i]['item'];
    String agencia = ab[i]['agencia'];
    String codigoProducto = ab[i]['codigoProducto'];
    String creacionDate = ab[i]['creacionDate'];
    String creacionTime = ab[i]['creacionTime'];
    DateTime current_date = DateTime.now();
    String dateStr = current_date.toString();
    i = i + 1;
    await db.collection('productos').doc(iD).set({
      'agencia': agencia,
      'item': item,
      'cantidad': cantidad,
      'precio': precio,
      'codigoProducto': codigoProducto,
      'creacionDate': creacionDate,
      'creacionTime': creacionTime,
      'lastUpdate': dateStr
    });
  });

  // await db.collection('productos').doc(uid).set();
}

Future<void> addProducto(
    String producto, int cantidad, String agencia, double precio) async {
  DateTime current_date = DateTime.now();
  String dateStr = current_date.toString();
  String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String tdata = DateFormat("HH:mm:ss").format(DateTime.now());
  db.collection("productos").add({
    'agencia': agencia,
    'item': producto,
    'cantidad': cantidad,
    'precio': precio,
    'codigoProducto': dateStr,
    'creacionDate': tdata,
    'creacionTime': cdate,
    'lastUpdate': dateStr
  });
}

Future<void> addProductos(String producto, int cantidad, String agencia,
    double precio, int value) async {
  DateTime current_date = DateTime.now();
  String dateStr = current_date.toString();
  String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String tdata = DateFormat("HH:mm:ss").format(DateTime.now());
  db.collection("productos").add({
    'agencia': agencia,
    'item': producto,
    'cantidad': cantidad,
    'precio': precio,
    'codigoProducto': dateStr + value.toString(),
    'creacionDate': tdata,
    'creacionTime': cdate,
    'lastUpdate': dateStr
  });
}

Future<void> updateStatusCommanda(
    String codigoComanda, String statuss, double descuentoo) async {
  List productos = [];
  int i = 0;
  CollectionReference collectionReferenceProductos =
      db.collection('comandaCabecera');
  QuerySnapshot queryProductos = await collectionReferenceProductos
      .where('codigoComanda', isEqualTo: codigoComanda)
      .get();
  queryProductos.docs.forEach((documento) async {
    String iD = documento.id;
    productos.add(documento.data());
    var user = jsonEncode(productos);
    String user1 = user;
    var ab = json.decode(user1).toList();
    String agencia = ab[i]['agencia'];
    String codigoComanda = ab[i]['codigoComanda'];
    String creacionDate = ab[i]['creacionDate'];
    String creacionTime = ab[i]['creacionTime'];
    int mesa = ab[i]['mesa'];
    String nombreCliente = ab[i]['nombreCliente'];
    int numeroComanda = ab[i]['numeroComanda'];
    double totalConsumo = ab[i]['totalConsumo'];
    String status = statuss;
    double descuento = descuentoo;
    i = i + 1;
    await db.collection('comandaCabecera').doc(iD).set({
      'agencia': agencia,
      'codigoComanda': codigoComanda,
      'creacionDate': creacionDate,
      'creacionTime': creacionTime,
      'mesa': mesa,
      'nombreCliente': nombreCliente,
      'numeroComanda': numeroComanda,
      'totalConsumo': totalConsumo,
      'status': status,
      'descuento': descuento
    });
  });

  // await db.collection('productos').doc(uid).set();
}

collectionSumGasto() async {
  var myRef = FirebaseFirestore.instance.collection('gastoCabecera');
  var snapshot = await myRef.count().get();
  globals.countGasto = snapshot.count;
}

getLastGasto() async {
  List gasto = [];
  CollectionReference collectionReferenceComanda =
      db.collection('gastoCabecera');
  QuerySnapshot queryProductos = await collectionReferenceComanda
      .orderBy("codigoGasto", descending: true)
      .limit(1)
      .orderBy("creacionTime", descending: true)
      .get();
  queryProductos.docs.forEach((documento) {
    gasto.add(documento.data());
    // print(comanda);
  });
}

Future<void> addGasto(List<dynamic> GastoListaAGrabar, double totalGastos,
    String fecha, String status) async {
  List<dynamic> data = GastoListaAGrabar;
  var user = jsonEncode(data);
  String user1 = user;
  // getLastComanda();
  DateTime current_date = DateTime.now();
  String dateStr = current_date.toString();
  var ab = json.decode(user1).toList();
  int i = 0;
  int elementCantidad = 0;

  String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String tdata = DateFormat("HH:mm:ss").format(DateTime.now());
  getLastGasto();
  collectionSumGasto();
  db.collection("gastoCabecera").add({
    'numeroGasto': globals.countGasto, //numeroComanda,
    'codigoGasto': dateStr,
    'creacionDate': cdate,
    'creacionTime': tdata,
    'status': status,
    'fechaGasto': fecha,
    'totalGastos': totalGastos,
    'activo': 'si'
  });
  int j = 1;
  ab?.forEach((item) {
    String cdate1 = DateFormat("yyyy-MM-dd").format(DateTime.now());
    String dateStr1 = current_date.toString();
    db.collection("gastos").add({
      'numeroGasto': globals.countGasto, //numeroComanda,
      'item': ab[i]['item'],
      'precio': double.parse(ab[i]['gasto']),
      'codigoGastp': dateStr1 + j.toString(),
      'creacionDate': cdate1,
      'creacionTime': tdata,
      'fechaGasto': fecha,
      'activo': 'si'
    });
    j = j + 1;
    i = i + 1;
  });
}

Future<List> getGastos(String fecha) async {
  List gastos = [];
  CollectionReference collectionReferenceComanda = db.collection('gastos');
  QuerySnapshot querycomandas = await collectionReferenceComanda
      .where('fechaGasto', isEqualTo: fecha)
      .where('activo', isEqualTo: 'si')
      .get();
  querycomandas.docs.forEach((documento) {
    gastos.add(documento.data());
  });
  gastos.sortBy(['numeroGasto']);
  return gastos;
}

Future<double> getGastosTotal(String fecha) async {
  List gastos = [];
  double total = 0;
  int i = 0;
  CollectionReference collectionReferenceComanda = db.collection('gastos');
  QuerySnapshot querycomandas = await collectionReferenceComanda
      .where('fechaGasto', isEqualTo: fecha)
      .where('activo', isEqualTo: 'si')
      .get();
  querycomandas.docs.forEach((documento) {
    gastos.add(documento.data());
    var user = jsonEncode(gastos);
    String user1 = user;
    var ab = json.decode(user1).toList();
    total = total + ab[i]['precio'];
    i = i + 1;
  });
  gastos.sortBy(['numeroGasto']);
  return total;
}

Future<void> deleteGasto(String uid) async {
  // CollectionReference collectionReferenceComanda = db.collection('gastos');

  await db.collection('gastos').doc(uid).delete();
}

Future<void> deleteComanda(int numeroDeComanda) async {
  CollectionReference collectionReferenceProductos = db.collection('comanda');
  QuerySnapshot queryProductos = await collectionReferenceProductos
      .where('numeroComanda', isEqualTo: numeroDeComanda)
      .get();
  queryProductos.docs.forEach((documento) {
    updateProductMasCantidad(documento['agencia'], documento['item'],
        documento['cantidad'], documento['precio']);
    //  agencia, ab[i]['item'], elementCantidad, double.parse(ab[i]['precio']));
    documento.reference.delete();
  });
}

Future<void> updateStatusGasto(String codigoGasto) async {
  List productos = [];
  int i = 0;
  CollectionReference collectionReferenceProductos = db.collection('gastos');
  QuerySnapshot queryProductos = await collectionReferenceProductos
      .where('codigoGastp', isEqualTo: codigoGasto)
      .get();
  queryProductos.docs.forEach((documento) async {
    String iD = documento.id;
    productos.add(documento.data());
    var user = jsonEncode(productos);
    String user1 = user;
    var ab = json.decode(user1).toList();
    String codigoGastp = ab[i]['codigoGastp'];
    String creacionDate = ab[i]['creacionDate'];
    String creacionTime = ab[i]['creacionTime'];
    String fechaGasto = ab[i]['fechaGasto'];
    String item = ab[i]['item'];
    int numeroGasto = ab[i]['numeroGasto'];
    double precio = ab[i]['precio'];

    i = i + 1;
    await db.collection('gastos').doc(iD).set({
      'codigoGastp': codigoGastp,
      'creacionDate': creacionDate,
      'creacionTime': creacionTime,
      'creacionTime': creacionTime,
      'fechaGasto': fechaGasto,
      'item': item,
      'numeroGasto': numeroGasto,
      'precio': precio,
      'activo': 'no'
    });
  });
}

Future<void> addMerendar(
    List<dynamic> comandaListaAGrabar,
    String nombreCliente,
    int mesa,
    int numeroComanda,
    String agencia,
    int countcomanda,
    double totalConsumo,
    String status) async {
  List<dynamic> data = comandaListaAGrabar;
  var user = jsonEncode(data);
  String user1 = user;
  // getLastComanda();
  DateTime current_date = DateTime.now();
  String dateStr = current_date.toString();
  var ab = json.decode(user1).toList();
  int i = 0;
  int elementCantidad = 0;
  String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String tdata = DateFormat("HH:mm:ss").format(DateTime.now());
  getLastComanda();
  collectionSum();
  db.collection("comandaCabecera").add({
    'agencia': agencia,
    'nombreCliente': nombreCliente,
    'mesa': 1000,
    'numeroComanda': globals.countComandas, //numeroComanda,
    'codigoComanda': dateStr,
    'creacionDate': cdate,
    'creacionTime': tdata,
    'totalConsumo': totalConsumo,
    'status': status,
    'descuento': 0
  });
  ab?.forEach((item) {
    elementCantidad = int.parse(ab[i]['cantidad']);
    db.collection("comanda").add({
      'agencia': agencia,
      'nombreCliente': nombreCliente,
      'mesa': 1000,
      'numeroComanda': globals.countComandas, //numeroComanda,
      'item': ab[i]['item'],
      'cantidad': elementCantidad,
      'precio': double.parse(ab[i]['precio']),
      'codigoComanda': dateStr,
      'creacionDate': cdate,
      'creacionTime': tdata
    });
    updateProduct(
        agencia, ab[i]['item'], elementCantidad, double.parse(ab[i]['precio']));
    i = i + 1;
  });
}

Future<void> addDarDeBaja(
    List<dynamic> comandaListaAGrabar,
    String nombreCliente,
    int mesa,
    int numeroComanda,
    String agencia,
    int countcomanda,
    double totalConsumo,
    String status) async {
  List<dynamic> data = comandaListaAGrabar;
  var user = jsonEncode(data);
  String user1 = user;
  // getLastComanda();
  DateTime current_date = DateTime.now();
  String dateStr = current_date.toString();
  var ab = json.decode(user1).toList();
  int i = 0;
  int elementCantidad = 0;

  String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String tdata = DateFormat("HH:mm:ss").format(DateTime.now());
  getLastComanda();
  collectionSum();
  db.collection("comandaCabecera").add({
    'agencia': agencia,
    'nombreCliente': nombreCliente,
    'mesa': 2000,
    'numeroComanda': globals.countComandas, //numeroComanda,
    'codigoComanda': dateStr,
    'creacionDate': cdate,
    'creacionTime': tdata,
    'totalConsumo': totalConsumo,
    'status': status,
    'descuento': 0
  });
  ab?.forEach((item) {
    elementCantidad = int.parse(ab[i]['cantidad']);
    db.collection("comanda").add({
      'agencia': agencia,
      'nombreCliente': nombreCliente,
      'mesa': 2000,
      'numeroComanda': globals.countComandas, //numeroComanda,
      'item': ab[i]['item'],
      'cantidad': elementCantidad,
      'precio': double.parse(ab[i]['precio']),
      'codigoComanda': dateStr,
      'creacionDate': cdate,
      'creacionTime': tdata
    });
    updateProduct(
        agencia, ab[i]['item'], elementCantidad, double.parse(ab[i]['precio']));
    i = i + 1;
  });
}

Future<void> addReposicion(
    List<dynamic> comandaListaAGrabar,
    String nombreCliente,
    int mesa,
    int numeroComanda,
    String agencia,
    int countcomanda,
    double totalConsumo,
    String status) async {
  List<dynamic> data = comandaListaAGrabar;
  var user = jsonEncode(data);
  String user1 = user;
  // getLastComanda();
  DateTime current_date = DateTime.now();
  String dateStr = current_date.toString();
  var ab = json.decode(user1).toList();
  int i = 0;
  int elementCantidad = 0;
  String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String tdata = DateFormat("HH:mm:ss").format(DateTime.now());
  getLastComanda();
  collectionSum();
  db.collection("comandaCabecera").add({
    'agencia': agencia,
    'nombreCliente': nombreCliente,
    'mesa': 3000,
    'numeroComanda': globals.countComandas, //numeroComanda,
    'codigoComanda': dateStr,
    'creacionDate': cdate,
    'creacionTime': tdata,
    'totalConsumo': totalConsumo,
    'status': status,
    'descuento': 0
  });
  ab?.forEach((item) {
    elementCantidad = int.parse(ab[i]['cantidad']);
    db.collection("comanda").add({
      'agencia': agencia,
      'nombreCliente': nombreCliente,
      'mesa': 3000,
      'numeroComanda': globals.countComandas, //numeroComanda,
      'item': ab[i]['item'],
      'cantidad': elementCantidad,
      'precio': double.parse(ab[i]['precio']),
      'codigoComanda': dateStr,
      'creacionDate': cdate,
      'creacionTime': tdata
    });
    String agenciaReposicion = '';
    if (agencia == 'central') {
      agenciaReposicion = 'sucursal 1';
    } else {
      if (agencia == 'sucursal 1') {
        agenciaReposicion = 'central';
      }
    }
    updateProductReposicion(agencia, ab[i]['item'], elementCantidad,
        double.parse(ab[i]['precio']), agenciaReposicion);
    i = i + 1;
  });
}
