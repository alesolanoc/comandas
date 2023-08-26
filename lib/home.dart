import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/page/ListadoDetallado.dart';
import 'package:flutter_application_1/page/config.dart';
import 'package:flutter_application_1/page/configuracion.dart';
import 'package:flutter_application_1/page/gastosListados.dart';
import 'package:flutter_application_1/page/inventario.dart';
import 'package:flutter_application_1/page/firesbase_service.dart';
import 'package:flutter_application_1/page/listAll.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'page/dashboard.dart';
import 'page/ListadoDeComandas.dart';
import 'page/chat.dart';
import 'page/gastos.dart';
import 'page/globals.dart' as globals;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 0;
  final List<Widget> screens = [Dashboard()];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Dashboard();

  void showAlert(QuickAlertType quickAlertType) {
    QuickAlert.show(context: context, type: quickAlertType);
  }

  @override
  Widget build(BuildContext cocntext) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        //       shape.CircularNotchedRectagle(),
        notchMargin: 5,
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
                          'Coman',
                          style: TextStyle(
                              color:
                                  currentTab == 0 ? Colors.blue : Colors.grey),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = ListadoDeComandas();
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.list,
                          color: currentTab == 1 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Lista',
                          style: TextStyle(
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
                        if (globals.password == 'patitoalejo') {
                          currentScreen = Inventario();
                          currentTab = 2;
                        } else {
                          showAlert(QuickAlertType.warning);
                        }
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat,
                          color: currentTab == 2 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Invent',
                          style: TextStyle(
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
                          currentScreen = Configuracion();
                          currentTab = 3;
                        } else {
                          showAlert(QuickAlertType.warning);
                        }
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.dangerous,
                          color: currentTab == 3 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Ingreso',
                          style: TextStyle(
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
                          currentScreen = Gastos();
                          currentTab = 4;
                        } else {
                          showAlert(QuickAlertType.warning);
                        }
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.attach_money,
                          color: currentTab == 4 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Gasto',
                          style: TextStyle(
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
                        if (globals.password == 'patitoalejo') {
                          currentScreen = GastosListados();
                          currentTab = 5;
                        } else {
                          showAlert(QuickAlertType.warning);
                        }
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: currentTab == 5 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'ListGa',
                          style: TextStyle(
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
                          currentScreen = ListadoDetallado();
                          currentTab = 6;
                        } else {
                          showAlert(QuickAlertType.warning);
                        }
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.playlist_add_check,
                          color: currentTab == 6 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'ListDet',
                          style: TextStyle(
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
                          currentScreen = ListadoAll();
                          currentTab = 7;
                        } else {
                          showAlert(QuickAlertType.warning);
                        }
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.list_alt,
                          color: currentTab == 7 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'ListIte',
                          style: TextStyle(
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
                        currentScreen = Config();
                        currentTab = 8;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.password,
                          color: currentTab == 8 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Conf',
                          style: TextStyle(
                              color:
                                  currentTab == 8 ? Colors.blue : Colors.grey),
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
