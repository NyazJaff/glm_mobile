import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'http_client.dart';
import 'package:glm_mobile/model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenericSharedPreference {
/**/
  Future<void> clearLocalEvaluationData()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('current_evaluation_user');
    pref.remove('evaluation_values');
    pref.remove('current_calculation_result_id');
  }
}