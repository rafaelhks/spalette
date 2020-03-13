import 'package:flutter/material.dart';

class Palette {
  static Color baseColor = Colors.blue;

  static String rgbToHex(num r, num g, num b) {
    return argbToHex(null, r,g,b);
  }

  static String argbToHex(num a, num r, num g, num b) {
    String hr = r.toInt().toRadixString(16).padLeft(2,'0'),
           hg = g.toInt().toRadixString(16).padLeft(2,'0'),
           hb = b.toInt().toRadixString(16).padLeft(2,'0'),
           ha = '';
      
    if(a!=null && a.toInt()<255){
      ha = a.toInt().toRadixString(16).padLeft(2,'0');
    }
    return '#$ha$hr$hg$hb';
  }
}