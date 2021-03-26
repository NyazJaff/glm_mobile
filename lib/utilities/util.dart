import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:glm_mobile/sidebar/custom_drawer.dart';
import 'package:glm_mobile/utilities/generic_shared_preference.dart';
import 'constants.dart';
import 'layout_helper.dart';
import 'package:intl/intl.dart';

double scrSize(BuildContext context){
  // print(MediaQuery.of(context).size.height / 100);
  return (MediaQuery.of(context).size.height / 100);
  // return MediaQuery.of(context).size.height;
}

navigateTo(BuildContext context, {path: '', cleanUp: true}){
  if(cleanUp == true){
    new GenericSharedPreference().clearLocalEvaluationData();
  }

  FocusScope.of(context).requestFocus(new FocusNode());
  Navigator.pop(context);
  if(path != ''){
    Navigator.pushNamed(context, path);
  }
}

bool isLargeScreen(BuildContext context){
  return scrSize(context) > 530;
}

bool utilIsAndroid(context){
  bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
  return isAndroid;
}

launchURL(url) async {

}

showToast(context, message){
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(message),
    duration: Duration(seconds: 2),
  ));
}

convertToCurrency(val){
  if(val == null || val == ''){
    return '';
  }
  return NumberFormat.simpleCurrency(name: '').format(val);
}

formatDate(date) {
  String formatter =
  DateFormat('EEEE, MMMM d, y').format(DateTime.parse(date));
  return formatter;
}

safeString(string){
  if(string == null){
    return '';
  }
  return string;
}