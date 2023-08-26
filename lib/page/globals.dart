library globals;

import 'package:flutter/material.dart';

List newList = [];
List newListPrecio = [];
List newListInventario = [];
List newListInventarioCanitdad = [];
List newListInventarioPrecio = [];
List newListUpdate = [];
List newAgenciaList = [];
List<dynamic> comandaLista = [];
List<dynamic> gastoLista = [];
String sucursal = '';
String nombreCliente = '';
double totalConsumo = 0;
int numeroMesa = 0;
int numeroComanda = 0;
int bandera = 0;
int countComandas = 0;
int countGasto = 0;
String agenciaSeleccionada = '';
String agenciaSeleccionadaParaVer = '';
String agenciaSeleccionadaParaVer1 = '';
List<List> listaDeComandas = [];
List listaDeComandas1 = [];
List ListaDeProductosItem = [];
List LsitaDeProductosAgencia = [];
List ListaDeProductosCantidad = [];
List ListaDeItemEnComanda = [];
List ListaDePrecioEnComanda = [];
List ListaDeCantidadEnComanda = [];
List ListaDeHoraEnComanda = [];
List ListaDeNumeroComandaEnComanda = [];
List ListaDeMesaEnComanda = [];
List<List> listaDeComandasDetalle = [];
List ListaDeTotalConsumido = [];
List l1 = [];
List l2 = [];

String productoAModificar = '';
String cantidadAModificar = '';

List inventarioNumeroComanda = [];
List inventarioNombreCliente = [];
List inventarioCreationDate = [];
List inventarioAgencia = [];
List inventarioNumeroMesa = [];
List inventarioHora = [];
List inventarioCodigoComanda = [];
List inventarioTotalConsumo = [];
List inventarioStatus = [];
List inventarioDescuento = [];
List inventarioUID = [];

List inventarioNumeroGasto = [];
List inventarioConceptoGasto = [];
List inventarioHoraGasto = [];
List inventarioTotalGasto = [];
List inventarioCreationDateGasto = [];
List inventarioCodigoGastp = [];

List listaItemDeUnaComanda = [];
List listaCantidadDeUnaComanda = [];
List listaPrecioDeUnaComanda = [];

String formattedDateGlobal = '';
String formattedDateGlobalListado = '';
DateTime formattedDateGlobalInicial =
    DateTime.now().add(const Duration(days: 1));
DateTime formattedDateGlobalFinal = DateTime.now().add(const Duration(days: 1));
DateTime formattedDateGlobalGasto = DateTime.now().add(const Duration(days: 1));
double precioo = 0;
List dayss = [];
List totalConsumoss = [];
List gastosItem = [];
List gastosItemCosto = [];
String password = '';
