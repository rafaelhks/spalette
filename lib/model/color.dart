class PColor{
  static final String table = 'pcolor', colId = 'pcolor_id', 
                      colRed='pcolor_red', colGreen='pcolor_green',
                      colBlue='pcolor_blue', colAlpha='pcolor_alpha',
                      colTag='pcolor_tag';

  int _id;
  num _red, _green, _blue, _alpha;
  String _tag;

  PColor.argb(num a, num r, num g, num b) {
    _red = r;
    _green = g;
    _blue = b;
    _alpha = a;
  }

  PColor.rgb(num r, num g, num b) {
    _red = r;
    _green = g;
    _blue = b;
  }

  PColor.fromARGB(String argb) {
    List<String> lst = argb.split(",");
      
    if(lst.length==3){
      _red =  num.parse(lst.elementAt(0));
      _green =  num.parse(lst.elementAt(1));
      _blue =  num.parse(lst.elementAt(2));
    } else if(lst.length==4){
      _alpha = num.parse(lst.elementAt(0));
      _red =  num.parse(lst.elementAt(1));
      _green =  num.parse(lst.elementAt(2));
      _blue =  num.parse(lst.elementAt(3));
    }else{
      defaultValues();
    }
  }

  PColor.hex(String hex){
    if(hex.startsWith('#') && hex.length>=7){
      if(hex.length==7){
        _alpha = 255;
        _red = int.parse(hex[1]+hex[2], radix: 16);
        _green = int.parse(hex[3]+hex[4], radix: 16);
        _blue = int.parse(hex[5]+hex[6], radix: 16);
      } else if(hex.length==9){
        _alpha = int.parse(hex[1]+hex[2], radix: 16);
        _red = int.parse(hex[3]+hex[4], radix: 16);
        _green = int.parse(hex[5]+hex[6], radix: 16);
        _blue = int.parse(hex[7]+hex[8], radix: 16);
      }else{
        defaultValues();
      }
    }else{
        defaultValues();
      }
  }

  PColor.fromColor(PColor c){
    _red = c.getRed();
    _green = c.getGreen();
    _blue = c.getBlue();
    _alpha = c.getAlpha();
  }

  int getId() {
    return _id;
  }

  int getAlpha(){
    return _alpha!=null ? _alpha.toInt() : 255;
  }

  int getRed(){
    return _red.toInt();
  }

  int getGreen(){
    return _green.toInt();
  }

  int getBlue(){
    return _blue.toInt();
  }

  setAlpha(num alpha){
    _alpha = alpha;
  }

  setRed(num red){
    _red = red;
  }

  setGreen(num green) {
    _green = green;
  }

  setBlue(num blue){
    _blue = blue;
  }

  String getTag(){
    if(_tag==null &&_id!=null){
      return 'Cor ($_id)';
    }
    return _tag;
  }

  setTag(String tag){
    _tag = tag;
  }

  defaultValues(){
    _alpha = 255;
    _red = 77;
    _blue = 77;
    _green = 77;
  }

  String getARGB(){
    String alpha = '';
    if(_alpha!=null && _alpha<255){
      alpha = '${_alpha.toInt()}, ';
    }
    return '$alpha${_red.toInt()}, ${_green.toInt()}, ${_blue.toInt()}';
  }
  
  String getHex(){
    String hr = _red.toInt().toRadixString(16).padLeft(2,'0'),
           hg = _green.toInt().toRadixString(16).padLeft(2,'0'),
           hb = _blue.toInt().toRadixString(16).padLeft(2,'0'),
           ha = '';
    if(_alpha!=null && _alpha.toInt()<255){
      ha = _alpha.toInt().toRadixString(16).padLeft(2,'0');
    }
    return '#$ha$hr$hg$hb';
  }

  Map<String , dynamic> toMap(){
      var map = new Map<String , dynamic>();
      map[colRed] = _red;
      map[colGreen]= _green;
      map[colBlue] = _blue;
      map[colAlpha] = _alpha;
      map[colTag] = _tag;
      if(_id != null){
        map[colId] = _id;
      }
      return map;
  }

  PColor.fromMap(Map<String , dynamic>map){
    this._id = map[colId];
    this._red = map[colRed];
    this._green = map[colGreen];
    this._blue = map[colBlue];
    this._alpha = map[colAlpha];
    this._tag = map[colTag];
  }

  teste(){
    
  }
}