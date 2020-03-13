import 'package:flutter/material.dart';
import 'package:mediapp/database/database_helper.dart';
import 'package:mediapp/model/color.dart';
import 'package:mediapp/screens/home.dart';
import 'package:mediapp/util/dialog.dart';

class ListColorPage extends StatefulWidget {
  ListColorPage({Key key}) : super(key: key);
  @override
  _ListColorPageState createState() => _ListColorPageState();
}

class _ListColorPageState extends State<ListColorPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<PColor> colors = new List();
  DatabaseHelper db = new DatabaseHelper();
  bool searchVisible = false;

  @override
  void initState() {
    super.initState();
    colors.clear();
    db.getAllPColor().then((c) {
      setState(() {
        c.forEach((color) {
          colors.add(new PColor.fromMap(color));
        });
      });
    });
  }

  search(String text){
    colors.clear();
    db.getPColorsByTag(text).then((c) {
      setState(() {
        c.forEach((color) {
          colors.add(new PColor.fromMap(color));
        });
      });
    });
  }

  remove(int pos) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Remover'),
          content: Text('Deseja mesmo remover ${colors.elementAt(pos).getTag()} de sua paleta?'),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text('Sim'),
              onPressed: () {
                db.deletePColor(colors.elementAt(pos).getId()).then((c) {
                  setState(() {
                    if(c>0){
                      colors.removeAt(pos); 
                      DialogUtils.snackBarWithKey(_scaffoldKey, 'Cor removida com sucesso!', 3);
                    }else{
                      DialogUtils.snackBarWithKey(_scaffoldKey, 'Erro ao remover cor!', 3);
                    }
                    Navigator.of(context).pop();
                  });
                });
              },
            ),
          ],
        );
      }
    );
    
  }

  void openColor(int pos){
    Navigator.push(context, MaterialPageRoute(builder: (context) => new HomePage.color(color: colors.elementAt(pos))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: searchVisible ? 
          TextField(
            style: TextStyle(color: Colors.white, fontSize: 20),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              hintText: 'Tag da Cor',
              hintStyle: TextStyle(color: Colors.white70),
              border: null
            ),
            autofocus: true,
            onSubmitted: (queryText) {
              search(queryText);
            },
          ) : Text('Sua paleta de cores'),
        actions: <Widget>[
          IconButton(
            icon: searchVisible ? Icon(Icons.cancel) : Icon(Icons.search),
            onPressed: () {
              setState(() {
                searchVisible = !searchVisible; 
                if(!searchVisible){
                  search('');
                }
              });
            },
          )
        ],
      ),
      body: Center(
        child: (colors!=null && colors.length>0) ? new ListView.builder(
          itemCount: colors.length,
          itemBuilder: (context, index){
            return GestureDetector(
              onTap: () { openColor(index); },
              child: Container(
                margin: EdgeInsets.only(top: 5),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width*0.35,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(colors[index].getAlpha(), colors[index].getRed(), colors[index].getGreen(), colors[index].getBlue()),  
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(15), topRight: Radius.circular(15))
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(5),
                          child: Text('${colors[index].getTag()}', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.5),),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          width: MediaQuery.of(context).size.width*0.45,
                          child: Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('ARGB: ${colors[index].getARGB()}'),
                                  Text('HEX: ${colors[index].getHex()}'),
                                ],
                              ),
                            ],
                          )
                        )
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () { remove(index); },
                      color: Colors.black,
                    )
                  ], 
                )
              )
            );
          }
        ) : Text('Oops, você não tem cores adicionadas à sua paleta.'),
      ),
    );
  }
}
