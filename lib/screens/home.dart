import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mediapp/database/database_helper.dart';
import 'package:mediapp/model/color.dart';
import 'package:mediapp/util/dialog.dart';
import 'package:mediapp/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  HomePage.color({Key key, PColor color}) {
    this.color = color;
  }
  final String title = 'SPALLETE';
  PColor color;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PColor color;
  DatabaseHelper db = new DatabaseHelper();
  bool menuOpen = false;
  TextEditingController controlHEX = new TextEditingController();
  TextEditingController controlRGB = new TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.color!=null) {
      color = widget.color;
    }else{
      color = new PColor.argb(255, 77, 77, 77);
    }
    controlHEX.text = color.getHex();
    controlRGB.text = color.getARGB();
  }

  parseColor(String text, int type){
      if(text!=null && text.length>0){
        try {
          setState(() {
            color = type==0 ? new PColor.hex(text) : new PColor.fromARGB(text);
            if(type==0){
              controlRGB.text = color.getARGB();
            }else if (type==1){
              controlHEX.text = color.getHex();
            } 
          });
        } catch (e) {
          print(e);
        }
      }
  }

  toggleOptions(){
    setState(() {
      menuOpen = !menuOpen;
    });
  }

  refresh(){
    setState(() {
        color = new PColor.argb(255, 77, 77, 77);
        colorChanged();
    });
  }

  generateRandom(){
    Random rnd = new Random();
    setState(() {
      color.setRed(rnd.nextInt(255));
      color.setGreen(rnd.nextInt(255));
      color.setBlue(rnd.nextInt(255)); 
      colorChanged();
    });
  }

  colorChanged(){
    controlHEX.text = color.getHex();
    controlRGB.text = color.getARGB();
  }

  colorChangedFromSlider(){
    controlHEX.text = color.getHex();
    controlRGB.text = color.getARGB();
  }

  savePColor(){
    showDialog(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: new Text(color.getId()!=null? 'Salvar alterações na cor' : 'Salvar nova cor'),
              contentPadding: EdgeInsets.only(left: 15, right: 15, top: 10),
              content: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 30,
                    margin: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(color.getAlpha(), color.getRed(), color.getGreen(), color.getBlue()),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    
                   ),
                  // Text('ARGB: ${color.getARGB()}'),
                  // Text('HEX:${color.getHex()}'),   
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'TAG',
                      contentPadding: EdgeInsets.all(3)
                    ),
                    onChanged: (text) {
                      color.setTag(text);
                    },
                  ),             
                ],
              ),
              
              actions: <Widget>[
                new FlatButton(
                  child: new Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text('Salvar'),
                  onPressed: () {
                    db.saveOrUpdatePColor(color);
                    Navigator.pop(context);
                    if(color.getId()!=null) {
                      DialogUtils.snackBarWithKey(_scaffoldKey, 'Cor ${color.getTag()} atualizada com sucesso!', 3);
                      color = new PColor.fromColor(color);
                    } else {
                      DialogUtils.snackBarWithKey(_scaffoldKey, 'Cor salva com sucesso!', 3);
                    }
                  },
                )
              ],
            );
          }
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: new CustomDrawer(context: context),
      appBar: AppBar(
        title: Text(color.getTag()!=null ? color.getTag() : 'Nova cor'),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                padding: EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width,
                decoration: new BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: new BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
                ),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: controlHEX,
                      style: TextStyle(color: Colors.white),
                      onChanged: (text) {
                        parseColor(text, 0);
                      },
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        prefixText: 'HEX: ',
                        prefixStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextField(
                      controller: controlRGB,
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                      onChanged: (text) {
                        parseColor(text, 1);
                      },
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        prefixText: controlRGB.text.split(",").length==4 ? 'ARGB: ' : 'RGB: ',
                        prefixStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                decoration: new BoxDecoration(
                  color: Color.fromARGB(color.getAlpha(), color.getRed(), color.getGreen(), color.getBlue()),
                  borderRadius: new BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.black45)]
                ),
              ),
              Slider(
                activeColor: Colors.red,
                min: 0,
                max: 255,
                onChanged: (value) {
                  setState(() => color.setRed(value));
                  colorChangedFromSlider();
                },
                value: color.getRed().toDouble(),
              ),
              Slider(
                activeColor: Colors.green,
                min: 0,
                max: 255,
                onChanged: (value) {
                  setState(() => color.setGreen(value));
                  colorChangedFromSlider();
                },
                value: color.getGreen().toDouble(),
              ),
              Slider(
                activeColor: Colors.blue,
                min: 0,
                max: 255,
                onChanged: (value) {
                  setState(() => color.setBlue(value));
                  colorChangedFromSlider();
                },
                value: color.getBlue().toDouble(),
              ),
              Slider(
                activeColor: Colors.grey,
                min: 0,
                max: 255,
                onChanged: (value) {
                  setState(() => color.setAlpha(value));
                  colorChangedFromSlider();
                },
                value: color.getAlpha().toDouble(),
              ),
              // Container(
              //   padding: EdgeInsets.all(15),
              //   child: Row(
              //     children: <Widget>[
              //       DropdownButton<String>(
              //         value: dropType,
              //         icon: Icon(Icons.arrow_drop_down),
              //         onChanged: (String newValue) {
              //           setState(() {
              //             dropType = newValue;
              //           });
              //         },
              //         items: <String>['Hex', 'RGB']
              //           .map<DropdownMenuItem<String>>((String value) {
              //             return DropdownMenuItem<String>(
              //               value: value,
              //               child: Text(value),
              //             );
              //           }).toList(),
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
      
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          menuOpen? Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: FloatingActionButton(
                  mini: true,
                  heroTag: 'btGen',
                  onPressed: generateRandom,
                  tooltip: 'Gerar',
                  child: Icon(Icons.shuffle),
                  backgroundColor: Colors.blue[800],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 7),
                child: FloatingActionButton(
                  mini: true,
                  heroTag: 'btRefresh',
                  onPressed: refresh,
                  tooltip: 'Reset',
                  child: Icon(Icons.refresh),
                  backgroundColor: Colors.blue[700],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 7),
                child: FloatingActionButton(
                  mini: true,
                  heroTag: 'btSave',
                  onPressed: savePColor,
                  tooltip: 'Salvar',
                  child: Icon(Icons.save),
                  backgroundColor: Colors.blue[600],
                ),
              ),
            ],
          ) : Column(),
          FloatingActionButton(
            onPressed: toggleOptions,
            tooltip: 'Opções',
            child: Icon(menuOpen ? Icons.close : Icons.tune),
          ),
        ],
      ),
      // bottomSheet: Container(
      //   alignment: Alignment.bottomCenter,
      //   height: 10,
      //   margin: EdgeInsets.only(bottom: 5),
      //   child: Text('Copyright © 2019 Rafael F. Ferreira', textScaleFactor: 0.6,),
      // ),
    );
  }
}
