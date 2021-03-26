import 'dart:io';
import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'dart:convert' as convert;
// import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class MyHttpClient  {
  // HttpClient client = new HttpClient();
  var dio = Dio();
  Future<Map<String, dynamic>> saveQuestions(
      question, {
                  type: 'question',
                  answered: false,
                }) async{
    return await makeJsonPost({
      "question"   : question,
      "type"       : type,
      "deleted"    : false,
      "answered"   : answered,
      "device_id"  : 'test',
//      "date_added" : DateTime.now().toString()
    });
  }

  Future<Map<String, dynamic>> updateQuestion(documentId, dataParam) async {
    var response = await _makeJsonPut(dataParam, url: documentId);
    if(response['status'] == "SUCCESS")
      return response['data'];
    else{
      return {};
    }
//    return await _makeJsonGet(url: dataParam);
  }

  Future<Map<String, dynamic>> _makeJsonPut(dataParam, {url: ""}) async{
    // var response = await http.put(
    //     Uri.parse(apiUrl() + url),
    //     headers: {"Content-Type": "application/json"},
    //     body: jsonEncode({"data": dataParam}));
    // return _httpJsonResponse(response);
  }

  Future<Map<String, dynamic>> makeJsonGet({dataParam: "", url: ""}) async{
    // String queryString = Uri(queryParameters: dataParam).query;
    var parsedUrl = apiUrl() + url;
    var response = await dio.get( parsedUrl );
    return _httpJsonResponse(response.data);
  }

  Future<Map<String, dynamic>> makeJsonPost(dataParam, {url: ""}) async{
    var response = await dio.post(apiUrl() + url, data: jsonEncode(dataParam));
    return _httpJsonResponse(response.data);
  }

  Map<String, dynamic> _httpJsonResponse(response){
    var jsonResponse = response;
    if(jsonResponse['status'] == 'success'){
      print('SUCCESS--------- HTTP API SUCCESS MESSAGE  --------------- START');
      // print(response.body != null ? response.body : 'NO DATA RETURNED');
      // print('SUCCESS--------- HTTP API SUCCESS MESSAGE  --------------- END');
    }else{
      print('ERROR--------- HTTP API ERROR MESSAGE  --------------- START');
      // print(response.body != null ? response.body : 'NO DATA RETURNED');
      // print('ERROR--------- HTTP API ERROR MESSAGE  --------------- END');
    }
    return jsonResponse;
  }

  String apiUrl(){
    // if(kReleaseMode){
      // App Release Mode
      // return 'http://localhost:3000/';
    // }
    return 'http://18.135.31.158/';
  }
}
