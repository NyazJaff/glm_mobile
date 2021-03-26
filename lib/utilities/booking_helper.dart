import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';

import 'http_client.dart';
import 'package:glm_mobile/model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';


class BookingHelper {
  MyHttpClient httpClient = new MyHttpClient();

  Future<Map<String, dynamic>>
  getPrayerSlots() async {
    // var reportData = getLocalSavedReport(user.id + "saving_estimate");
    Map<String, dynamic> prayerSlots = {};
      await httpClient.makeJsonGet(url: 'api/v1/bookings').then((response) async {
        prayerSlots = response;
      });
      return prayerSlots;
  }

  Future<List<dynamic>>
  getUsersBookings() async {
    // var reportData = getLocalSavedReport(user.id + "saving_estimate");
    String deviceId = await getDeviceId();
    List<dynamic> userPrayers = [];
    await httpClient.makeJsonGet(url: '/requested_slots/user_slots/$deviceId').then((response) async {
     print(response['data'].length);
      userPrayers = response['data'];
    });
    return userPrayers;
  }

  Future<List<dynamic>>
  deleteUserPrayer(prayerId) async {
    // var reportData = getLocalSavedReport(user.id + "saving_estimate");
    List<dynamic> userPrayers = [];
    await httpClient.makeJsonGet(url: '/requested_slots/cancel/$prayerId').then((response) async {
    });
    return userPrayers;
  }


  Future<Map<String, dynamic>>
  bookSlotOnSystem(data) async {
    Map<String, dynamic> responseData = {"status": "error"};
    await httpClient.makeJsonPost({"booking": data}, url: 'api/v1/bookings').then((response) async {
      print(response);
      // if(response['status'] == 'success'){
        responseData = response;
      // }
      });
    return responseData;
  }

  Future<String> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  Future<void>
  setDeviceId(deviceId) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('deviceId', deviceId);
  }


  Future<void>
  setBookingEmail(email) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('booking_email', email);
  }

  Future<String>
  getBookingEmail() async{
    final prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('booking_email');
    if (email == null) {
      return null;
    }
    return email;
  }

  Future<Map<String,dynamic>>
  getUserInfoFromPreference() async{
    Map<String,dynamic> data = {};
    final prefs = await SharedPreferences.getInstance();
    String userInfo = prefs.getString('userInfo');
    if (userInfo == null) {
      return {};
    }
    data =  json.decode(userInfo);
    return data;
  }

  Future<void>
  setUserInfoInPreference(data) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userInfo', json.encode(data));
  }
}