import 'package:flutter/material.dart';

class PrayerRadioModel {
  bool isSelected;
  String key;
  String label;
  String gender;
  String group;
  String prayerTime;
  String date;
  int    availableSpaces;

  PrayerRadioModel(
      this.isSelected,
      this.key,
      this.label,
      this.prayerTime,
      this.availableSpaces
      );


  PrayerRadioModel.fromJson(Map<String, dynamic> json)
      : isSelected = false,
        key = json['prayer'],
        label = json['label'],
        prayerTime = '',
        // date = json['date'],
        availableSpaces = json['available_slots'] // ,
        // gender = json['gender'] ,
        // group = json['group']
  ;

}