import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Codechef {
  final String handle;
  final int rating;
  final int maxrating;
  final String imageurl;
  Color color;
  int stars;
  Codechef({this.handle, this.rating, this.imageurl,this.maxrating}) {
    if (rating < 1400) {
      stars = 1;
      color = Colors.grey;
    } else if (rating >= 1400 && rating < 1600) {
      stars = 2;
      color = Colors.green;
    } else if (rating >= 1600 && rating < 1800) {
      stars = 3;
      color = Colors.blue;
    } else if (rating >= 1800 && rating < 2000) {
      stars = 4;
      color = Colors.purple;
    } else if (rating >= 2000 && rating < 2200) {
      stars = 5;
      color = Colors.yellow;
    } else if (rating >= 2200 && rating < 2500) {
      stars = 6;
      color = Colors.orange;
    } else if (rating >= 2500) {
      stars = 7;
      color = Colors.red;
    }
  }
}
