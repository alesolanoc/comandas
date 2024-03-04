import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_application_1/page/printable_data.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class SaveBtnBuilder extends StatelessWidget {
  const SaveBtnBuilder({Key? key}) : super(key: key);

  @override /*
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.indigo,
        primary: Colors.indigo,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onPressed: () => printDoc1(),
      child: const Text(
        'Grabar comp PDF',
        style: TextStyle(color: Colors.white, fontSize: 20.00),
      ),
    );
  }

  Future<void> printDoc1() async {
    final image = await imageFromAssetBundle(
      'coffeina.png',
    );
    final doc = pw.Document();
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return buildPrintableData(image);
        }));
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }
  */
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

Future<void> printDoc1(int numeroComanda, String nombreCliente, int numeroMesa,
    String sucursal, List comandaLista, double total, int opcion) async {
  /* final image = await imageFromAssetBundle(
    '',
  );*/
  final doc = pw.Document();
  doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4.copyWith(
          marginBottom: 0.0 * PdfPageFormat.cm,
          marginLeft: 0.0 * PdfPageFormat.cm,
          marginRight: 0.0 * PdfPageFormat.cm,
          marginTop: 0.0 * PdfPageFormat.cm),
      build: (pw.Context context) {
        return buildPrintableData(numeroComanda, nombreCliente, numeroMesa,
            sucursal, comandaLista, total, opcion);
      }));
  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save());
}

Future<void> printDoc2(
    int numeroComanda,
    String nombreCliente,
    int numeroMesa,
    String sucursal,
    List comandaLista,
    List comandaLista1,
    List comandaLista2,
    String hora,
    double consumo,
    String descuento,
    int opcion) async {
/*  final image = await imageFromAssetBundle(
    '',
  );*/
  final doc = pw.Document();
  doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return buildPrintableData1(
            //  image,
            numeroComanda,
            nombreCliente,
            numeroMesa,
            sucursal,
            comandaLista,
            comandaLista1,
            comandaLista2,
            consumo,
            descuento,
            opcion);
      }));
  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save());
}

Future<void> printDoc3(
    String fecha,
    List inventarioNumeroGasto,
    List inventarioTotalGasto,
    List inventarioCreationDateGasto,
    List inventarioConceptoGasto,
    double totalConsumo) async {
  /* final image = await imageFromAssetBundle(
    '',
  );*/
  final doc = pw.Document();
  doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return buildPrintableData3(fecha, inventarioTotalGasto,
            inventarioCreationDateGasto, inventarioConceptoGasto, totalConsumo);
      }));
  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save());
}

Future<void> printDoc4(
    String fecha,
    List inventarioNumeroComanda,
    List inventarioTotalConsumo,
    List inventarioCreationDate,
    List inventarioHora,
    List inventarioStatus,
    List inventarioDescuento,
    List inventarioAgencia) async {
  /*final image = await imageFromAssetBundle(
    '',
  );*/
  final doc = pw.Document();
  doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return buildPrintableData4(
            //  image,
            fecha,
            inventarioNumeroComanda,
            inventarioTotalConsumo,
            inventarioCreationDate,
            inventarioHora,
            inventarioStatus,
            inventarioDescuento,
            inventarioAgencia);
      }));
  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save());
}

Future<void> printDoc5(String agencia, DateTime fecha, List inventario,
    List cantidad, List precio, List lastUpdate) async {
  /* final image = await imageFromAssetBundle(
    '',
  );*/
  final doc = pw.Document();
  doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return buildPrintableData5(
            agencia, fecha, inventario, cantidad, precio, lastUpdate);
      }));
  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save());
}

Future<void> printDoc6(
    String agencia, DateTime fecha, List inventario, double total) async {
/*  final image = await imageFromAssetBundle(
    '',
  );*/
  final doc = pw.Document();
  doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return buildPrintableData6(agencia, fecha, inventario, total);
      }));
  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save());
}

Future<void> printDoc7(
    String fecha,
    List inventarioNumeroComanda,
    List inventarioTotalConsumo,
    List inventarioCreationDate,
    List inventarioHora,
    List inventarioStatus,
    List inventarioDescuento,
    List inventarioAgencia,
    List inventarioCodigoComanda,
    List<List> listaDeComandas) async {
/*  final image = await imageFromAssetBundle(
    '',
  );*/
  final doc = pw.Document();
  doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return buildPrintableData7(
            //  image,
            fecha,
            inventarioNumeroComanda,
            inventarioTotalConsumo,
            inventarioCreationDate,
            inventarioHora,
            inventarioStatus,
            inventarioDescuento,
            inventarioAgencia,
            inventarioCodigoComanda,
            listaDeComandas);
      }));
  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save());
}

Future<void> printDoc8(
    String fecha,
    List ListaDeProductosItem,
    List LsitaDeProductosAgencia,
    List ListaDeProductosCantidad,
    List<List> listaDeComandasDetalle,
    String cadena,
    List ListaDeTotalConsumido) async {
/*  final image = await imageFromAssetBundle(
    '',
  );*/
  final doc = pw.Document();
  doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return buildPrintableData8(
            //    image,
            fecha,
            ListaDeProductosItem,
            LsitaDeProductosAgencia,
            ListaDeProductosCantidad,
            listaDeComandasDetalle,
            cadena,
            ListaDeTotalConsumido);
      }));
  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save());
}

Future<void> printDoc9(
    String agencia, DateTime fecha, List inventario, double total) async {
/*  final image = await imageFromAssetBundle(
    '',
  );*/
  final doc = pw.Document();
  doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return buildPrintableData9(agencia, fecha, inventario, total);
      }));
  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save());
}
