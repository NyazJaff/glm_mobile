import 'package:flutter/material.dart';

class RadioModel {
  bool isSelected;
  String key;
  String label;
  String display;
  IconData icon;
  RadioModel(this.isSelected, this.key, this.label, this.icon, {this.display = 'icon'});
}