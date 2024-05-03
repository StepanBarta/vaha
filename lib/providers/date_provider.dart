import 'package:flutter/material.dart';

class Date with ChangeNotifier {
  String _date = '';

  String get date => _date;

  void setDate(d) {
    _date = d;
  }
}
