import 'package:flutter/material.dart';
import 'package:mediapp/screens/list_colors.dart';
import 'package:mediapp/util/palette.dart';
import 'package:mediapp/util/pdf.dart';

class CustomDrawer extends StatelessWidget {

  CustomDrawer({this.context});

  final BuildContext context;

  Widget listTilePage(String text, IconData icon, StatefulWidget page){
    return ListTile(
            leading: Icon(icon),
            title: Text(text, style: TextStyle(color: Colors.black, fontSize: 15),),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => page));
            },
          );
  }

  Widget listTile(String text, IconData icon, void Function() onTap){
    return ListTile(
            leading: Icon(icon),
            title: Text(text, style: TextStyle(color: Colors.black, fontSize: 15),),
            onTap: onTap,
          );
  }

  gerarPDF(){
    ColorPDF(fileName: 'testecores.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('SPALETTE', 
                        style: TextStyle(color: Colors.black, 
                                         fontWeight: FontWeight.bold, 
                                         shadows: [Shadow(color: Colors.black38, offset: Offset.fromDirection(1))]), 
                        textAlign: TextAlign.right,),
            decoration: BoxDecoration(
                color: Palette.baseColor,
                image: DecorationImage(
                  image: AssetImage("lib/assets/palette.png"),
                     fit: BoxFit.cover),
            ),
          ),
          listTilePage('Paleta de cores', Icons.list, new ListColorPage()),
          //listTile('PDF', Icons.list, () { gerarPDF(); }),
        ],
      ),
    );
  }
  
}