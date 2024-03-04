import 'dart:js_interop';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'globals.dart' as globals;
import 'firesbase_service.dart';

buildPrintableData(
        //    image,
        int numberoComanda,
        String nombreCliente,
        int numeroMesa,
        String sucursal,
        List comandaLista,
        double total,
        int opcion) =>
    pw.Padding(
      padding: const pw.EdgeInsets.all(25.00),
      child: pw.Column(children: [
        /*  pw.Text("vijaycreations",
            style:
                pw.TextStyle(fontSize: 25.00, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10.00),
        pw.Divider(),
        pw.Align(
          alignment: pw.Alignment.topLeft,
          child: pw.Image(
            image,
            width: 80,
            height: 80,
          ),
        ),*/
        pw.Column(
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Align(
                  alignment: pw.Alignment.topLeft,
                  /*   child: pw.Image(
                    image,
                    width: 50,
                    height: 50,
                  ),*/
                ),
                //  pw.SizedBox(width: 5),
                pw.Text(
                  "COFFEINA-",
                  style: pw.TextStyle(
                      fontSize: 30.00, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(width: 5),
                pw.Text(
                  "Comanda->" + numberoComanda.toString(),
                  style: pw.TextStyle(
                      fontSize: 30.00, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
            pw.SizedBox(height: 10.00),
            pw.Container(
              //  color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 20.00,
              //     child: pw.Center(
              child: pw.Text(
                "Numero de Mesa -> " + numeroMesa.toString(),
                style: pw.TextStyle(fontSize: 25),
                /* style: pw.TextStyle(
                    color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                    fontSize: 20.00,
                    fontWeight: pw.FontWeight.bold),*/
              ),
              //    ),
            ),
            /*       pw.SizedBox(height: 10.00),
            pw.Container(
              // color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 20.00,
              //    child: pw.Center(
              child: pw.Text(
                  "Nombre del Cliente -> " + nombreCliente.toString(),
                  style: pw.TextStyle(fontSize: 25)
                  /*  style: pw.TextStyle(
                    color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                    fontSize: 20.00,
                    fontWeight: pw.FontWeight.bold),*/
                  ),
              //    ),
            ),*/
            /*     pw.SizedBox(height: 10.00),
            pw.Container(
              // color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 20.00,
              //       child: pw.Center(
              child: pw.Text("Agencia -> " + sucursal.toString(),
                  style: pw.TextStyle(fontSize: 25)
                  /*       style: pw.TextStyle(
                    color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                    fontSize: 20.00,
                    fontWeight: pw.FontWeight.bold),*/
                  ),
              //    ),
            ),*/
            pw.SizedBox(height: 10.00),
            pw.Container(
              // color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 20.00,
              //        child: pw.Center(
              child: pw.Text("Fecha -> " + DateTime.now().toString(),
                  style: pw.TextStyle(fontSize: 25)
                  /*  style: pw.TextStyle(
                    color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                    fontSize: 20.00,
                    fontWeight: pw.FontWeight.bold),*/
                  ),
              //        ),
            ),
            pw.SizedBox(height: 10.00),
            //  pw.Container(
            // color: const PdfColor(0.5, 1, 0.5, 0.7),
            /*   width: double.infinity,
              height: 20.00,*/

            //child:

            pw.Container(
              // color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 20.00,
              //       child: pw.Center(
              child: pw.Text(
                "Item  --> Cantidad  Precio/U  Precio/T",
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                /*       style: pw.TextStyle(
                    color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                    fontSize: 20.00,
                    fontWeight: pw.FontWeight.bold),*/
              ),
              //    ),
            ),
            /*     pw.SizedBox(height: 10.00),
            pw.Container(
              // color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 20.00,
              //       child: pw.Center(
              child: pw.Text("         -->Cantidad  Precio/U  Precio/T",
                  style:
                      pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold)
                  /*       style: pw.TextStyle(
                    color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                    fontSize: 20.00,
                    fontWeight: pw.FontWeight.bold),*/
                  ),
              //    ),
            ),*/
            //     pw.SizedBox(height: 10.00),
            pw.Container(
              // color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 20.00,
              //       child: pw.Center(
              child: pw.Text(
                  "----------------------------------------------------",
                  style:
                      pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold)
                  /*       style: pw.TextStyle(
                    color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                    fontSize: 20.00,
                    fontWeight: pw.FontWeight.bold),*/
                  ),
              //    ),
            ),

            //     pw.Text('Item  ', style: pw.TextStyle(fontSize: 8)),
            // pw.Container(
            //child:
            /*      pw.Text('Cantidad  Precio/U  Precio/T',
                style: pw.TextStyle(fontSize: 8)
                /*  style: pw.TextStyle(
                    color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                    fontSize: 20.00,
                    fontWeight: pw.FontWeight.bold),*/
                ),*/
            //        ),
            //  ),
            for (var i = 0; i < comandaLista.length; i++)
              //  comandaLista.forEach((element) {

              pw.Table(
                  /*border: pw.TableBorder.all(),*/ /*columnWidths: {
                //  0: pw.FractionColumnWidth(0.05),
                0: pw.FractionColumnWidth(0.85),
                1: pw.FractionColumnWidth(0.05),
                2: pw.FractionColumnWidth(0.05),
                3: pw.FractionColumnWidth(0.05),}*/
                  /*   columnWidths: {
                    0: pw.FixedColumnWidth(5),
                  },*/
                  children: [
                    pw.TableRow(
                      children: [
                        /*    pw.Container(
                      child: pw.Text((i + 1).toString(),
                          style: pw.TextStyle(fontSize: 10)),
                    ),*/
                        pw.Container(
                          width: double.infinity,
                          height: 25.00,
                          child: pw.Text("* " + comandaLista[i]['item'],
                              /* +
                                  " " +
                                  comandaLista[i]['datoAdicional'],*/
                              style: pw.TextStyle(
                                  fontSize: 20,
                                  fontWeight: pw.FontWeight.bold)),
                        ),
                        /*       comandaLista[i]['datoAdicional'] == "//"
                            ? pw.Container(
                                width: double.infinity,
                                height: 25.00,
                                child: pw.Text(comandaLista[i]['datoAdicional'],
                                    style: pw.TextStyle(
                                        fontSize: 25,
                                        fontWeight: pw.FontWeight.bold)),
                              )
                            : pw.SizedBox(height: 00.00),*/
                      ],
                    ),
                    (comandaLista[i]['datoAdicional'] != "//")
                        ? pw.TableRow(
                            children: [
                              /*    pw.Container(
                      child: pw.Text((i + 1).toString(),
                          style: pw.TextStyle(fontSize: 10)),
                    ),*/
                              pw.Container(
                                width: double.infinity,
                                height: 25.00,
                                child: pw.Text(comandaLista[i]['datoAdicional'],
                                    /* +
                                  " " +
                                  comandaLista[i]['datoAdicional'],*/
                                    style: pw.TextStyle(
                                        fontSize: 20,
                                        fontWeight: pw.FontWeight.bold)),
                              ),
                            ],
                          )
                        : pw.TableRow(
                            children: [
                              /*    pw.Container(
                      child: pw.Text((i + 1).toString(),
                          style: pw.TextStyle(fontSize: 10)),
                    ),*/
                            ],
                          ),
                    pw.TableRow(
                      children: [
                        pw.Container(
                          width: double.infinity,
                          height: 25.00,
                          child: pw.Text(
                              "         -->   " +
                                  comandaLista[i]['cantidad'] +
                                  "             " +
                                  comandaLista[i]['precio'] +
                                  "             " +
                                  (double.parse(comandaLista[i]['precio']) *
                                          double.parse(
                                              comandaLista[i]['cantidad']))
                                      .toStringAsFixed(2),
                              style: pw.TextStyle(fontSize: 20)),
                        ),
                        //     pw.SizedBox(height: 10.00),
                        /*       pw.Container(
                          child: pw.Text(comandaLista[i]['precio'],
                              style: pw.TextStyle(fontSize: 8)),
                        ),
                        pw.Container(
                          child: pw.Text(
                              (double.parse(comandaLista[i]['precio']) *
                                      double.parse(comandaLista[i]['cantidad']))
                                  .toStringAsFixed(2),
                              style: pw.TextStyle(fontSize: 8)),
                        ),*/
                      ],
                    )
                  ]),

            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
              child: pw.Container(
                width: double.infinity,
                height: 15.00,
                child: pw.Row(
                  //       mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      "                 TOTAL Bs.      " +
                          total.toStringAsFixed(2),
                      style: pw.TextStyle(
                        fontSize: 25.00,
                        fontWeight: pw.FontWeight.bold,
                        //      color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            pw.SizedBox(height: 20.00),
            // pw.SizedBox(height: 20.00),
            pw.Container(
              // color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 10.00,
              //       child: pw.Center(
              child: pw.Text(
                "Nombre: ................................................",
                style: const pw.TextStyle(
                    color: PdfColor(0.5, 0.5, 0.5, 0.5), fontSize: 20.00),
                /*       style: pw.TextStyle(
                    color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                    fontSize: 20.00,
                    fontWeight: pw.FontWeight.bold),*/
              ),
              //    ),
            ),
            pw.SizedBox(height: 20.00),
            // pw.SizedBox(height: 20.00),
            pw.Container(
              // color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 10.00,
              //       child: pw.Center(
              child: pw.Text(
                "Nit/CI: ....................................................",
                style: const pw.TextStyle(
                    color: PdfColor(0.5, 0.5, 0.5, 0.5), fontSize: 20.00),
                /*       style: pw.TextStyle(
                    color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                    fontSize: 20.00,
                    fontWeight: pw.FontWeight.bold),*/
              ),
              //    ),
            ),

            /*     pw.SizedBox(height: 25.00),
            pw.SizedBox(height: 20.00),
            pw.Container(
              // color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 10.00,
              //       child: pw.Center(
              child: pw.Text(
                "       ** Gracias por preferirnos! **",
                style: const pw.TextStyle(
                    color: PdfColor(0.5, 0.5, 0.5, 0.5), fontSize: 25.00),
                /*       style: pw.TextStyle(
                    color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                    fontSize: 20.00,
                    fontWeight: pw.FontWeight.bold),*/
              ),
              //    ),
            ),*/

            /*          pw.Text(
              "Gracias por preferirnos!",
              style: const pw.TextStyle(
                  color: PdfColor(0.5, 0.5, 0.5, 0.5), fontSize: 8.00),
            ),
                pw.SizedBox(height: 5.00),
            pw.Text(
              'Contactos:  79396019  -> https://www.facebook.com/Coffeinacoffeeroasters',
              style: const pw.TextStyle(
                  color: PdfColor(0.5, 0.5, 0.5, 0.5), fontSize: 8.00),
            ),
            pw.SizedBox(height: 5.00),
            pw.Text(
              'Central: Calle Esteban Arce #0354, entre Jordan y sucre (lado hotel las Vegas) (atención de 9:00 a 22:00)',
              style: const pw.TextStyle(
                  color: PdfColor(0.5, 0.5, 0.5, 0.5), fontSize: 8),
            ),
            pw.Text(
              'Sucursal: Calle Nueva Granada #1533 entre Av. Perú y Diego de Almagro (atención de 11:00 a 20:00)',
              style: const pw.TextStyle(
                  color: PdfColor(0.5, 0.5, 0.5, 0.5), fontSize: 8),
            ),*/
          ],
        )
      ]),
    );

buildPrintableData1(
        //  image,
        int numberoComanda,
        String nombreCliente,
        int numeroMesa,
        String sucursal,
        List comandaLista,
        List comandaLista1,
        List comandaLista2,
        double total,
        String descuento,
        int opcion) =>
    pw.Padding(
      padding: const pw.EdgeInsets.all(25.00),
      child: pw.Column(children: [
        /*  pw.Text("vijaycreations",
            style:
                pw.TextStyle(fontSize: 25.00, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10.00),
        pw.Divider(),
        pw.Align(
          alignment: pw.Alignment.topLeft,
          child: pw.Image(
            image,
            width: 80,
            height: 80,
          ),
        ),*/
        pw.Column(
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Align(
                  alignment: pw.Alignment.topLeft,
                  /*  child: pw.Image(
                    image,
                    width: 50,
                    height: 50,
                  ),*/
                ),
                pw.Text(
                  "COFFEINA-",
                  style: pw.TextStyle(
                      fontSize: 30.00, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(width: 5),
                pw.Text(
                  "Comanda-->" + numberoComanda.toString(),
                  style: pw.TextStyle(
                      fontSize: 30.00, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
            pw.SizedBox(height: 15.00),
            pw.Container(
              //  color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 20.00,
              //     child: pw.Center(
              child: pw.Text(
                "Numero de Mesa -> " + numeroMesa.toString(),
                style: pw.TextStyle(fontSize: 25),
                /* style: pw.TextStyle(
                    color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                    fontSize: 20.00,
                    fontWeight: pw.FontWeight.bold),*/
              ),
              //    ),
            ),
            pw.SizedBox(height: 10.00),
            pw.Container(
              // color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 20.00,
              //    child: pw.Center(
              child: pw.Text(
                "Nombre del Cliente -> " + nombreCliente.toString(),
                style: pw.TextStyle(fontSize: 25),
                /*  style: pw.TextStyle(
                    color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                    fontSize: 20.00,
                    fontWeight: pw.FontWeight.bold),*/
              ),
              //    ),
            ),
            pw.SizedBox(height: 10.00),
            pw.Container(
              // color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 20.00,
              //       child: pw.Center(
              child: pw.Text(
                "Sucursal -> " + sucursal.toString(),
                style: pw.TextStyle(fontSize: 25),
                /*       style: pw.TextStyle(
                    color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                    fontSize: 20.00,
                    fontWeight: pw.FontWeight.bold),*/
              ),
              //    ),
            ),
            pw.SizedBox(height: 10.00),
            pw.Container(
              // color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 20.00,
              //        child: pw.Center(
              child: pw.Text(
                "Fecha -> " + DateTime.now().toString(),
                style: pw.TextStyle(fontSize: 25),
                /*  style: pw.TextStyle(
                    color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                    fontSize: 20.00,
                    fontWeight: pw.FontWeight.bold),*/
              ),
              //        ),
            ),
            pw.SizedBox(height: 15.00),
            pw.Container(
              // color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 20.00,
              //        child: pw.Center(
              child: pw.Text(
                'Item                                  Cantidad  Precio/U  Precio/T',
                style: pw.TextStyle(fontSize: 17),
                /*  style: pw.TextStyle(
                    color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                    fontSize: 20.00,
                    fontWeight: pw.FontWeight.bold),*/
              ),
              //        ),
            ),
            pw.SizedBox(height: 5.00),
            pw.Container(
              // color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 20.00,
              //       child: pw.Center(
              child: pw.Text(
                  "----------------------------------------------------",
                  style:
                      pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold)
                  /*       style: pw.TextStyle(
                    color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                    fontSize: 20.00,
                    fontWeight: pw.FontWeight.bold),*/
                  ),
              //    ),
            ),
            pw.SizedBox(height: 5.00),
            for (var i = 0; i < comandaLista.length; i++)
              //  comandaLista.forEach((element) {

              pw.Table(/*border: pw.TableBorder.all(),*/ columnWidths: {
                //     0: pw.FractionColumnWidth(0.05),
                0: pw.FractionColumnWidth(0.55),
                1: pw.FractionColumnWidth(0.15),
                2: pw.FractionColumnWidth(0.15),
                3: pw.FractionColumnWidth(0.15),
              }, children: [
                pw.TableRow(
                  children: [
                    /*   pw.Container(
                      child: pw.Text(
                        (i + 1).toString(),
                        style: pw.TextStyle(fontSize: 17),
                      ),
                    ),*/
                    pw.Container(
                      child: pw.Text(
                        comandaLista[i],
                        style: pw.TextStyle(fontSize: 17),
                      ),
                    ),
                    pw.Container(
                      child: pw.Text(
                        comandaLista1[i].toStringAsFixed(2),
                        style: pw.TextStyle(fontSize: 17),
                      ),
                    ),
                    pw.Container(
                      child: pw.Text(
                        comandaLista2[i].toStringAsFixed(2),
                        style: pw.TextStyle(fontSize: 17),
                      ),
                    ),
                    pw.Container(
                      child: pw.Text(
                        (comandaLista1[i] * (comandaLista2[i]))
                            .toStringAsFixed(2),
                        style: pw.TextStyle(fontSize: 17),
                      ),
                    ),
                  ],
                )
              ]),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
              child: pw.Container(
                width: double.infinity,
                height: 20.00,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      "\Descuento ->" + descuento,
                      style: pw.TextStyle(
                        fontSize: 20.00,
                        fontWeight: pw.FontWeight.bold,
                        //     color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
              child: pw.Container(
                width: double.infinity,
                height: 36.00,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      "Total Consumo Bs." +
                          (total - (double.parse(descuento)))
                              .toStringAsFixed(2),
                      style: pw.TextStyle(
                        fontSize: 22.00,
                        fontWeight: pw.FontWeight.bold,
                        //   color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            pw.SizedBox(height: 20.00),
            pw.Text(
              "Gracias por preferirnos!",
              style: const pw.TextStyle(
                  color: PdfColor(0.5, 0.5, 0.5, 0.5), fontSize: 15.00),
            ),
            /*          pw.SizedBox(height: 5.00),
            pw.Text(
              'Contactos:  79396019  -> https://www.facebook.com/Coffeinacoffeeroasters',
              style: const pw.TextStyle(
                  color: PdfColor(0.5, 0.5, 0.5, 0.5), fontSize: 8.00),
            ),
            pw.SizedBox(height: 15.00),
            pw.Text(
              'Central: Calle Esteban Arce #0354, entre Jordan y sucre (lado hotel las Vegas) (atención de 9:00 a 22:00)',
              style: const pw.TextStyle(
                  color: PdfColor(0.5, 0.5, 0.5, 0.5), fontSize: 8),
            ),
            pw.Text(
              'Sucursal: Calle Nueva Granada #1533 entre Av. Perú y Diego de Almagro (atención de 11:00 a 20:00)',
              style: const pw.TextStyle(
                  color: PdfColor(0.5, 0.5, 0.5, 0.5), fontSize: 8),
            ),*/
          ],
        )
      ]),
    );

TableRow buildRow(List<String> cells, {bool isHeader = false}) => TableRow(
      children: cells.map((cell) {
        final style = TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: 18,
        );
        return Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Text(cell, style: style),
            ));
      }).toList(),
    );

buildPrintableData3(
        //   image,
        String fecha,
        List inventarioTotalGasto,
        List inventarioCreationDateGasto,
        List inventarioConceptoGasto,
        double totalConsumo) =>
    pw.Padding(
      padding: const pw.EdgeInsets.all(25.00),
      child: pw.Column(children: [
        pw.Column(
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Align(
                  alignment: pw.Alignment.topLeft,
                  /*   child: pw.Image(
                    image,
                    width: 50,
                    height: 50,
                  ),*/
                ),
                pw.SizedBox(width: 10),
                pw.Text(
                  "Gastos-->" + fecha,
                  style: pw.TextStyle(
                      fontSize: 20.00, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
            pw.SizedBox(height: 10.00),
            pw.Container(
              // color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 10.00,
              //        child: pw.Center(
              child: pw.Text(
                'Nro.  Item                                                                                           Gasto',
              ),
            ),
            pw.SizedBox(height: 10.00),
            for (var i = 0; i < inventarioTotalGasto.length; i++)
              //  comandaLista.forEach((element) {

              pw.Table(/*border: pw.TableBorder.all(), */ columnWidths: {
                0: pw.FractionColumnWidth(0.05),
                1: pw.FractionColumnWidth(0.75),
                2: pw.FractionColumnWidth(0.20),
              }, children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      child: pw.Text((i + 1).toString()),
                    ),
                    pw.Container(
                      child: pw.Text(inventarioConceptoGasto[i]),
                    ),
                    pw.Container(
                      child:
                          pw.Text(inventarioTotalGasto[i].toStringAsFixed(2)),
                    ),
                  ],
                )
              ]),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
              child: pw.Container(
                width: double.infinity,
                height: 36.00,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      "\Bs." + totalConsumo.toStringAsFixed(2),
                      style: pw.TextStyle(
                        fontSize: 22.00,
                        fontWeight: pw.FontWeight.bold,
                        color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ]),
    );

buildPrintableData4(
        //     image,
        String fecha,
        List inventarioNumeroComanda,
        List inventarioTotalConsumo,
        List inventarioCreationDate,
        List inventarioHora,
        List inventarioStatus,
        List inventarioDescuento,
        List inventarioAgencia) =>
    pw.Padding(
      padding: const pw.EdgeInsets.all(25.00),
      child: pw.Column(children: [
        pw.Column(
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Align(
                  alignment: pw.Alignment.topLeft,
                  /*      child: pw.Image(
                    image,
                    width: 50,
                    height: 50,
                  ),*/
                ),
                pw.SizedBox(width: 10),
                pw.Text(
                  "Comandas - Fecha-->" + fecha,
                  style: pw.TextStyle(
                      fontSize: 20.00, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
            pw.SizedBox(height: 10.00),
            pw.Container(
              // color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 10.00,
              //        child: pw.Center(
              child: pw.Text(
                'Nro.Comanda   Status     Hora      Total/Consumo    Descuento      Agencia',
              ),
            ),
            pw.SizedBox(height: 20.00),
            for (var i = 0; i < inventarioNumeroComanda.length; i++)
              //  comandaLista.forEach((element) {

              pw.Table(/*border: pw.TableBorder.all(),*/ columnWidths: {
                0: pw.FractionColumnWidth(0.05),
                1: pw.FractionColumnWidth(0.16),
                2: pw.FractionColumnWidth(0.11),
                3: pw.FractionColumnWidth(0.14),
                4: pw.FractionColumnWidth(0.15),
                5: pw.FractionColumnWidth(0.15),
                6: pw.FractionColumnWidth(0.17),
              }, children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      child: pw.Text(inventarioNumeroComanda[i].toString()),
                    ),
                    pw.Container(
                      child: pw.Text(inventarioStatus[i].toString()),
                    ),
                    pw.Container(
                      child: pw.Text(inventarioHora[i].toString()),
                    ),
                    pw.Container(
                      child:
                          pw.Text(inventarioTotalConsumo[i].toStringAsFixed(2)),
                    ),
                    pw.Container(
                      child: pw.Text(inventarioDescuento[i].toStringAsFixed(2)),
                    ),
                    pw.Container(
                      child: pw.Text(inventarioAgencia[i].toString()),
                    ),
                  ],
                )
              ]),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
              child: pw.Container(
                width: double.infinity,
                height: 22.00,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      "\Descuentos --> Bs. " +
                          (inventarioDescuento.reduce((a, b) => a + b))
                              .toStringAsFixed(2),
                      style: pw.TextStyle(
                        fontSize: 20.00,
                        fontWeight: pw.FontWeight.bold,
                        color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
              child: pw.Container(
                width: double.infinity,
                height: 36.00,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      "\Consumo  -->  Bs. " +
                          (inventarioTotalConsumo.reduce((a, b) => a + b))
                              .toStringAsFixed(2),
                      style: pw.TextStyle(
                        fontSize: 22.00,
                        fontWeight: pw.FontWeight.bold,
                        color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ]),
    );

buildPrintableData5(String agencia, DateTime fecha, List inventario,
        List cantidad, List precio, List lastUpdate) =>
    pw.Padding(
      padding: const pw.EdgeInsets.all(25.00),
      child: pw.Column(children: [
        pw.Column(
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Align(
                  alignment: pw.Alignment.topLeft,
                  /*   child: pw.Image(
                    image,
                    width: 50,
                    height: 50,
                  ),*/
                ),
                pw.SizedBox(width: 8),
                pw.Text(
                  'Inventario --> ' + agencia,
                  style: pw.TextStyle(
                      fontSize: 20.00, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
            pw.SizedBox(height: 10.00),
            pw.Container(
              // color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 10.00,
              //        child: pw.Center(
              child: pw.Text(
                'Nro.   Producto                                         Cantidad   Precio     Ultima Actualizacion',
              ),
            ),
            pw.SizedBox(height: 10.00),
            for (var i = 0; i < inventario.length; i++)
              //  comandaLista.forEach((element) {

              pw.Table(border: pw.TableBorder.all(), columnWidths: {
                0: pw.FractionColumnWidth(0.05),
                1: pw.FractionColumnWidth(0.50),
                2: pw.FractionColumnWidth(0.13),
                3: pw.FractionColumnWidth(0.13),
                4: pw.FractionColumnWidth(0.19),
              }, children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      child: pw.Text((i + 1).toString()),
                    ),
                    pw.Container(
                      child: pw.Text(inventario[i].toString()),
                    ),
                    pw.Container(
                      child: pw.Text(cantidad[i].toString()),
                    ),
                    pw.Container(
                      child: pw.Text(precio[i].toString()),
                    ),
                    pw.Container(
                      child: pw.Text(lastUpdate[i].toString()),
                    ),
                  ],
                )
              ]),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
              child: pw.Container(
                width: double.infinity,
                height: 15.00,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      ' Fecha -->' + fecha.toString(),
                      style: pw.TextStyle(
                        fontSize: 22.00,
                        fontWeight: pw.FontWeight.bold,
                        color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ]),
    );

buildPrintableData6(
        String agencia, DateTime fecha, List inventario, double total) =>
    pw.Padding(
      padding: const pw.EdgeInsets.all(25.00),
      child: pw.Column(children: [
        pw.Column(
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Align(
                  alignment: pw.Alignment.topLeft,
                  /*    child: pw.Image(
                    image,
                    width: 50,
                    height: 50,
                  ),*/
                ),
                //  pw.SizedBox(width: 8),
                pw.Text(
                  'Ingresos-> ' + agencia,
                  style: pw.TextStyle(
                      fontSize: 20.00, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  ' Fecha-> ' + fecha.toString(),
                  style: pw.TextStyle(
                      fontSize: 20.00, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
            pw.SizedBox(height: 10.00),
            pw.Container(
              // color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 10.00,
              //        child: pw.Center(
              child: pw.Text(
                'Nro.         Fecha                                              Ingreso',
              ),
            ),
            pw.SizedBox(height: 10.00),
            for (var i = 0, j = 0; i < inventario.length; i = i + 2, j++)
              //  comandaLista.forEach((element) {

              pw.Table(border: pw.TableBorder.all(), columnWidths: {
                0: pw.FractionColumnWidth(0.05),
                1: pw.FractionColumnWidth(0.20),
                2: pw.FractionColumnWidth(0.20),
              }, children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      child: pw.Text((j + 1).toString()),
                    ),
                    pw.Container(
                      child: pw.Text(inventario[i].toString()),
                    ),
                    pw.Container(
                      child: pw.Text(inventario[i + 1].toStringAsFixed(2)),
                    ),
                  ],
                )
              ]),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
              child: pw.Container(
                width: double.infinity,
                height: 15.00,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      "\Total  -->  Bs. " + total.toStringAsFixed(2),
                      style: pw.TextStyle(
                        fontSize: 22.00,
                        fontWeight: pw.FontWeight.bold,
                        color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ]),
    );

buildPrintableData7(
        // image,
        String fecha,
        List inventarioNumeroComanda,
        List inventarioTotalConsumo,
        List inventarioCreationDate,
        List inventarioHora,
        List inventarioStatus,
        List inventarioDescuento,
        List inventarioAgencia,
        List inventarioCodigoComanda,
        List<List> listaDeComandas) =>
    pw.Padding(
      padding: const pw.EdgeInsets.all(25.00),
      child: pw.Column(children: [
        pw.Column(
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Align(
                  alignment: pw.Alignment.topLeft,
                  /*       child: pw.Image(
                    image,
                    width: 50,
                    height: 50,
                  ),*/
                ),
                pw.SizedBox(width: 10),
                pw.Text(
                  "Comandas - Fecha-->" + fecha,
                  style: pw.TextStyle(
                      fontSize: 20.00, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
            pw.SizedBox(height: 10.00),
            pw.Container(
              // color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 10.00,
              //        child: pw.Center(
              child: pw.Text(
                'Nro.     Status        Hora     Consum Descto  Agen       Item                 Cant  Pre/U',
              ),
            ),
            pw.SizedBox(height: 10.00),
            for (var i = 0; i < inventarioNumeroComanda.length; i++)
              //  comandaLista.forEach((element) {

              pw.Table(border: pw.TableBorder.all(), columnWidths: {
                0: pw.FractionColumnWidth(0.08),
                1: pw.FractionColumnWidth(0.14),
                2: pw.FractionColumnWidth(0.12),
                3: pw.FractionColumnWidth(0.10),
                4: pw.FractionColumnWidth(0.08),
                5: pw.FractionColumnWidth(0.14),
                6: pw.FractionColumnWidth(0.34),
              }, children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      child: pw.Text(inventarioNumeroComanda[i].toString()),
                    ),
                    pw.Container(
                      child: pw.Text(inventarioStatus[i].toString()),
                    ),
                    pw.Container(
                      child: pw.Text(inventarioHora[i].toString()),
                    ),
                    pw.Container(
                      child:
                          pw.Text(inventarioTotalConsumo[i].toStringAsFixed(2)),
                    ),
                    pw.Container(
                      child: pw.Text(inventarioDescuento[i].toStringAsFixed(2)),
                    ),
                    pw.Container(
                      child: pw.Text(inventarioAgencia[i].toString()),
                    ),
                    pw.Column(children: [
                      for (var j = 0; j < listaDeComandas[i].length; j++)
                        pw.Table(border: pw.TableBorder.all(), columnWidths: {
                          0: pw.FractionColumnWidth(0.60),
                          1: pw.FractionColumnWidth(0.19),
                          2: pw.FractionColumnWidth(0.21),
                        }, children: [
                          pw.TableRow(
                            children: [
                              pw.Container(
                                child: pw.Text(
                                    listaDeComandas[i][j]['item'].toString()),
                              ),
                              pw.Container(
                                child: pw.Text(listaDeComandas[i][j]['cantidad']
                                    .toString()),
                              ),
                              pw.Container(
                                child: pw.Text(listaDeComandas[i][j]['precio']
                                    .toStringAsFixed(2)),
                              ),
                            ],
                          )
                        ])
                    ])
                  ],
                )
              ]),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
              child: pw.Container(
                width: double.infinity,
                height: 22.00,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      "\Descuentos --> Bs. " +
                          (inventarioDescuento.reduce((a, b) => a + b))
                              .toStringAsFixed(2),
                      style: pw.TextStyle(
                        fontSize: 15.00,
                        fontWeight: pw.FontWeight.bold,
                        color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
              child: pw.Container(
                width: double.infinity,
                height: 36.00,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      "\Consumo  -->  Bs. " +
                          (inventarioTotalConsumo.reduce((a, b) => a + b))
                              .toStringAsFixed(2),
                      style: pw.TextStyle(
                        fontSize: 22.00,
                        fontWeight: pw.FontWeight.bold,
                        color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ]),
    );

buildPrintableData8(
        //     image,
        String fecha,
        List ListaDeProductosItem,
        List LsitaDeProductosAgencia,
        List ListaDeProductosCantidad,
        List<List> listaDeComandasDetalle,
        String cadena,
        List ListaDeTotalConsumido) =>
    pw.Padding(
      padding: const pw.EdgeInsets.all(25.00),
      child: pw.Column(children: [
        pw.Column(
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Align(
                  alignment: pw.Alignment.topLeft,
                  /* child: pw.Image(
                    image,
                    width: 50,
                    height: 50,
                  ),*/
                ),
                pw.SizedBox(width: 10),
                pw.Text(
                  "Items - Fecha-->" + fecha,
                  style: pw.TextStyle(
                      fontSize: 20.00, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
            pw.SizedBox(height: 10.00),
            pw.Container(
              // color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 10.00,
              //        child: pw.Center(
              child: pw.Text(
                'Nro.     Item        Hora     Consum Descto',
              ),
            ),
            pw.SizedBox(height: 10.00),
            for (var i = 0; i < ListaDeProductosItem.length; i++)
              //  comandaLista.forEach((element) {

              pw.Table(border: pw.TableBorder.all(), columnWidths: {
                0: pw.FractionColumnWidth(0.08),
                1: pw.FractionColumnWidth(0.14),
                2: pw.FractionColumnWidth(0.12),
                3: pw.FractionColumnWidth(0.10),
              }, children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      child: pw.Text(ListaDeProductosItem[i].toString()),
                    ),
                    pw.Container(
                      child: pw.Text(LsitaDeProductosAgencia[i].toString()),
                    ),
                    pw.Container(
                      child: pw.Text(ListaDeProductosCantidad[i].toString()),
                    ),
                    pw.Container(
                      child: pw.Text(cadena),
                    ),
                    listaDeComandasDetalle.toString() == ''
                        ? pw.Container(
                            child: pw.Text('0'),
                          )
                        : pw.Container(
                            child: pw.Text('1'),
                          ),
                    ListaDeTotalConsumido[i] == '0'
                        ? pw.Container(
                            child: pw.Text('0'),
                          )
                        : pw.Container(
                            child: pw.Text(ListaDeTotalConsumido[i].toString()),
                          ),

                    /*   pw.Column(children: [
                      for (var j = 0; j < listaDeComandasDetalle[i].length; j++)
                        pw.Table(border: pw.TableBorder.all(), columnWidths: {
                          0: pw.FractionColumnWidth(0.60),
                          1: pw.FractionColumnWidth(0.19),
                          2: pw.FractionColumnWidth(0.21),
                        }, children: [
                          pw.TableRow(
                            children: [
                              pw.Container(
                                child: pw.Text(listaDeComandasDetalle[i][j]
                                        ['item']
                                    .toString()),
                              ),
                              pw.Container(
                                child: pw.Text(listaDeComandasDetalle[i][j]
                                        ['mesa']
                                    .toString()),
                              ),
                              pw.Container(
                                child: pw.Text(listaDeComandasDetalle[i][j]
                                        ['numeroComanda']
                                    .toStringAsFixed(2)),
                              ),
                            ],
                          )
                        ])
                    ])*/
                  ],
                )
              ]),
            /*     pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
              child: pw.Container(
                width: double.infinity,
                height: 22.00,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      "\Descuentos --> Bs. " +
                          (inventarioDescuento.reduce((a, b) => a + b))
                              .toStringAsFixed(2),
                      style: pw.TextStyle(
                        fontSize: 15.00,
                        fontWeight: pw.FontWeight.bold,
                        color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
              child: pw.Container(
                width: double.infinity,
                height: 36.00,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      "\Consumo  -->  Bs. " +
                          (inventarioTotalConsumo.reduce((a, b) => a + b))
                              .toStringAsFixed(2),
                      style: pw.TextStyle(
                        fontSize: 22.00,
                        fontWeight: pw.FontWeight.bold,
                        color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),*/
          ],
        )
      ]),
    );

buildPrintableData9(
        String agencia, DateTime fecha, List inventario, double total) =>
    pw.Padding(
      padding: const pw.EdgeInsets.all(25.00),
      child: pw.Column(children: [
        pw.Column(
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Align(
                  alignment: pw.Alignment.topLeft,
                  /*    child: pw.Image(
                    image,
                    width: 50,
                    height: 50,
                  ),*/
                ),
                //  pw.SizedBox(width: 8),
                pw.Text(
                  'Ingreso No Cobrado->' + agencia,
                  style: pw.TextStyle(
                      fontSize: 20.00, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  '->' + fecha.toString(),
                  style: pw.TextStyle(
                      fontSize: 20.00, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
            pw.SizedBox(height: 10.00),
            pw.Container(
              // color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 10.00,
              //        child: pw.Center(
              child: pw.Text(
                'Nro.         Fecha                                              Ingreso',
              ),
            ),
            pw.SizedBox(height: 10.00),
            for (var i = 0, j = 0; i < inventario.length; i = i + 2, j++)
              //  comandaLista.forEach((element) {

              pw.Table(border: pw.TableBorder.all(), columnWidths: {
                0: pw.FractionColumnWidth(0.05),
                1: pw.FractionColumnWidth(0.20),
                2: pw.FractionColumnWidth(0.20),
              }, children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      child: pw.Text((j + 1).toString()),
                    ),
                    pw.Container(
                      child: pw.Text(inventario[i].toString()),
                    ),
                    pw.Container(
                      child: pw.Text(inventario[i + 1].toStringAsFixed(2)),
                    ),
                  ],
                )
              ]),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
              child: pw.Container(
                width: double.infinity,
                height: 15.00,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      "\Total No Cobrado -->  Bs. " + total.toStringAsFixed(2),
                      style: pw.TextStyle(
                        fontSize: 22.00,
                        fontWeight: pw.FontWeight.bold,
                        color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ]),
    );
