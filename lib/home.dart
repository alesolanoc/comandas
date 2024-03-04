import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/page/ListadoDetallado.dart';
import 'package:flutter_application_1/page/config.dart';
import 'package:flutter_application_1/page/configuracion.dart';
import 'package:flutter_application_1/page/gastosListados.dart';
import 'package:flutter_application_1/page/inventario.dart';
import 'package:flutter_application_1/page/firesbase_service.dart';
import 'package:flutter_application_1/page/listAll.dart';
import 'package:flutter_application_1/page/modif.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'page/Configuracion_ingresos_nocobrados.dart';
import 'page/dashboard.dart';
import 'page/ListadoDeComandas.dart';
import 'page/chat.dart';
import 'page/gastos.dart';
import 'page/globals.dart' as globals;
import 'page/listAll1.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 0;
  final List<Widget> screens = [Dashboard()];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Dashboard();

  void showAlert(QuickAlertType quickAlertType, String mensaje) {
    QuickAlert.show(
        context: context, type: quickAlertType, text: mensaje, width: 50);
  }

  @override
  Widget build(BuildContext cocntext) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      //   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        //       shape.CircularNotchedRectagle(),
        notchMargin: 10,
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 35,
                    onPressed: () {
                      setState(() {
                        currentScreen = Dashboard();
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.dashboard,
                          color: currentTab == 0 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Crea',
                          style: TextStyle(
                              fontSize: 8,
                              color:
                                  currentTab == 0 ? Colors.blue : Colors.grey),
                        ),
                        Text(
                          'Comanda',
                          style: TextStyle(
                              fontSize: 8,
                              color:
                                  currentTab == 0 ? Colors.blue : Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 35,
                    onPressed: () {
                      setState(() {
                        currentScreen = Modif();
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.update,
                          color: currentTab == 1 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Modifica',
                          style: TextStyle(
                              fontSize: 8,
                              color:
                                  currentTab == 1 ? Colors.blue : Colors.grey),
                        ),
                        Text(
                          'Comanda',
                          style: TextStyle(
                              fontSize: 8,
                              color:
                                  currentTab == 1 ? Colors.blue : Colors.grey),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = ListadoDeComandas();
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.list,
                          color: currentTab == 2 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Listado',
                          style: TextStyle(
                              fontSize: 8,
                              color:
                                  currentTab == 2 ? Colors.blue : Colors.grey),
                        ),
                        Text(
                          'Comandas',
                          style: TextStyle(
                              fontSize: 8,
                              color:
                                  currentTab == 2 ? Colors.blue : Colors.grey),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        if (globals.password == 'patitoalejo') {
                          currentScreen = Inventario();
                          currentTab = 3;
                        } else {
                          showAlert(
                              QuickAlertType.warning, 'No tiene autorizacion');
                        }
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat,
                          color: currentTab == 3 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Inventario',
                          style: TextStyle(
                              fontSize: 8,
                              color:
                                  currentTab == 3 ? Colors.blue : Colors.grey),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        if (globals.password == 'patitoalejo') {
                          currentScreen = Configuracion();
                          currentTab = 4;
                        } else {
                          showAlert(
                              QuickAlertType.warning, 'No tiene autorizacion');
                        }
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.dangerous,
                          color: currentTab == 4 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Listado',
                          style: TextStyle(
                              fontSize: 8,
                              color:
                                  currentTab == 4 ? Colors.blue : Colors.grey),
                        ),
                        Text(
                          'Ingresos',
                          style: TextStyle(
                              fontSize: 8,
                              color:
                                  currentTab == 4 ? Colors.blue : Colors.grey),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        //        if (globals.password == 'patitoalejo') {
                        currentScreen = Gastos();
                        currentTab = 5;
                        /*          } else {
                          showAlert(
                              QuickAlertType.warning, 'No tiene autorizacion');
                        }*/
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.attach_money,
                          color: currentTab == 5 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Ingresar',
                          style: TextStyle(
                              fontSize: 8,
                              color:
                                  currentTab == 5 ? Colors.blue : Colors.grey),
                        ),
                        Text(
                          'Gastos',
                          style: TextStyle(
                              fontSize: 8,
                              color:
                                  currentTab == 5 ? Colors.blue : Colors.grey),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        if (globals.password == 'patitoalejo') {
                          currentScreen = GastosListados();
                          currentTab = 6;
                        } else {
                          showAlert(
                              QuickAlertType.warning, 'No tiene autorizacion');
                        }
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: currentTab == 6 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Listado',
                          style: TextStyle(
                              fontSize: 8,
                              color:
                                  currentTab == 6 ? Colors.blue : Colors.grey),
                        ),
                        Text(
                          'Gastos',
                          style: TextStyle(
                              fontSize: 8,
                              color:
                                  currentTab == 6 ? Colors.blue : Colors.grey),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        if (globals.password == 'patitoalejo') {
                          currentScreen = ListadoDetallado();
                          currentTab = 7;
                        } else {
                          showAlert(
                              QuickAlertType.warning, 'No tiene autorizacion');
                        }
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.playlist_add_check,
                          color: currentTab == 7 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Listado',
                          style: TextStyle(
                              fontSize: 8,
                              color:
                                  currentTab == 7 ? Colors.blue : Colors.grey),
                        ),
                        Text(
                          'Detalle',
                          style: TextStyle(
                              fontSize: 8,
                              color:
                                  currentTab == 7 ? Colors.blue : Colors.grey),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        if (globals.password == 'patitoalejo') {
                          currentScreen = ListadoAll();
                          currentTab = 8;
                        } else {
                          showAlert(
                              QuickAlertType.warning, 'No tiene autorizacion');
                        }
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.list_alt,
                          color: currentTab == 8 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Listado',
                          style: TextStyle(
                              fontSize: 8,
                              color:
                                  currentTab == 8 ? Colors.blue : Colors.grey),
                        ),
                        Text(
                          'Items',
                          style: TextStyle(
                              fontSize: 8,
                              color:
                                  currentTab == 8 ? Colors.blue : Colors.grey),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        if (globals.password == 'patitoalejo') {
                          currentScreen = Configuracion1();
                          currentTab = 9;
                        } else {
                          showAlert(
                              QuickAlertType.warning, 'No tiene autorizacion');
                        }
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.date_range,
                          color: currentTab == 9 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Listado',
                          style: TextStyle(
                              fontSize: 8,
                              color:
                                  currentTab == 9 ? Colors.blue : Colors.grey),
                        ),
                        Text(
                          'No Cobrados',
                          style: TextStyle(
                              fontSize: 8,
                              color:
                                  currentTab == 9 ? Colors.blue : Colors.grey),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        if (globals.password == 'patitoalejo') {
                          currentScreen = ListadoAll1();
                          currentTab = 10;
                        } else {
                          showAlert(
                              QuickAlertType.warning, 'No tiene autorizacion');
                        }
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.line_style_rounded,
                          color: currentTab == 10 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Faltante',
                          style: TextStyle(
                              fontSize: 8,
                              color:
                                  currentTab == 10 ? Colors.blue : Colors.grey),
                        ),
                        Text(
                          'Items',
                          style: TextStyle(
                              fontSize: 8,
                              color:
                                  currentTab == 10 ? Colors.blue : Colors.grey),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = Config();
                        currentTab = 11;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.password,
                          color: currentTab == 11 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Config.',
                          style: TextStyle(
                              fontSize: 8,
                              color:
                                  currentTab == 11 ? Colors.blue : Colors.grey),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
