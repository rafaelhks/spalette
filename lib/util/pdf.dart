import 'dart:io';

import 'package:mediapp/database/database_helper.dart';
import 'package:mediapp/model/color.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class ColorPDF{
  final String fileName;
  List<PColor> colors = new List();
  DatabaseHelper db = new DatabaseHelper();
  Directory appDocDirectory;
  Document pdf = Document();

  ColorPDF({this.fileName}) {
    db.getAllPColor().then((c) {
      c.forEach((color) {
        colors.add(new PColor.fromMap(color));
      });
      createPDF();
      saveFile();
    });
  }

  childs(){
    List<Widget> widgets = [];
    for (var item in colors) {
      widgets.add(
        Container(
          margin: EdgeInsets.all(5),
          width: PdfPageFormat.a4.width,
          height: 100,
          child: GridView(
            crossAxisCount: 1,
            direction: Axis.horizontal,
            children: <Widget>[
              Text('Exemplo da cor', style: TextStyle(color: PdfColor.fromHex('#FFfff235'), fontWeight: FontWeight.bold)),
              Text(item.getARGB()),
            ]
          ),
        ));
    }
    return widgets;
  }

  createPDF(){
    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (Context context) {
        return [
          Center(
            child: Stack(
              children: childs()
            ),
          )
        ];
      }));
  }

  saveFile() async{
    this.appDocDirectory = await getExternalStorageDirectory();
    final file = File(this.appDocDirectory.path+'/'+fileName);
    await file.writeAsBytes(pdf.save());
  }
}