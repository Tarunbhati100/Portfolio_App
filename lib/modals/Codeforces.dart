import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Codeforces {
  final String handle;
  final String imgurl;
  final int maxrating;
  final int currrating;
  final String maxrank;
  final String rank;
  Color currcolor;
  Color maxcolor;
  Codeforces(
      {this.handle,
      this.currrating,
      this.imgurl,
      this.maxrank,
      this.maxrating,
      this.rank}) {
    if (currrating < 1200) {
      currcolor = Colors.blueGrey;
    } else if (currrating >= 1200 && currrating < 1400) {
      currcolor = Colors.green;
    } else if (currrating >= 1400 && currrating < 1600) {
      currcolor = Colors.blue;
    } else if (currrating >= 1600 && currrating < 1900) {
      currcolor = Colors.purple;
    } else if (currrating >= 1900 && currrating < 2100) {
      currcolor = Colors.pink;
    } else if (currrating >= 2100 && currrating < 2300) {
      currcolor = Colors.yellowAccent;
    } else if (currrating >= 2300 && currrating < 2400) {
      currcolor = Colors.yellow;
    } else {
      currcolor = Colors.red;
    }
        if (maxrating < 1200) {
      maxcolor = Colors.blueGrey;
    } else if (maxrating >= 1200 && maxrating < 1400) {
      maxcolor = Colors.green;
    } else if (maxrating >= 1400 && maxrating < 1600) {
      maxcolor = Colors.blue;
    } else if (maxrating >= 1600 && maxrating < 1900) {
      maxcolor = Colors.purple;
    } else if (maxrating >= 1900 && maxrating < 2100) {
      maxcolor = Colors.pink;
    } else if (maxrating >= 2100 && maxrating < 2300) {
      maxcolor = Colors.yellowAccent;
    } else if (maxrating >= 2300 && maxrating < 2400) {
      maxcolor = Colors.yellow;
    } else {
      maxcolor = Colors.red;
    }
  }
}
