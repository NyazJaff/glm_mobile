import 'dart:async';
import 'dart:convert';
import 'http_client.dart';
import 'package:glm_mobile/model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<UserModel> getCurrentUser();

  // Future<void> sendEmailVerification();

  Future<void> logout();

}

class Auth implements BaseAuth {
  MyHttpClient httpClient = new MyHttpClient();

  Future<String> signIn(String email, String password) async {
    String status = 'error';
    try{
     await httpClient.makeJsonPost({
        "email": email,
        "password": password,
      }, url: 'user/login').then((response) async {
        if(response['status'] == 'success'){
          UserModel user = UserModel.fromJson(response['user']);
          await setCurrentUser(user);
          status = 'success';
        }else{
          status = response['message'] != null ? response['message'] : 'Failed to login';
        }
        // await logout();
        // user = await getCurrentUser();
      });
     return status;
    }catch (e){
      print(e);
      return 'error';
    }
  }

  Future<UserModel> setCurrentUser(user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('current_user', json.encode(user));
    return user;
  }

  Future<UserModel> getCurrentUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userString = pref.getString('current_user');
    if (userString == null) {
      return null;
    }
      return UserModel.fromJson(jsonDecode(userString));
   }

  Future<void> logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('current_user');
  }

  Future<Map<String, dynamic>> createNewUser(user) async {
    Map<String, dynamic> data = {"status": "error"};
    var userJson = user.toJson();
    userJson.remove('id');
    try{
      await httpClient.makeJsonPost(userJson, url: 'user').then((response) async {
        if(response['status'] == 'success'){
          data = response;
        }
      });
      return data;
    }catch (e){
      return data;
    }
  }

  Future<List<UserModel>> getUsersByName(name) async {
    List<UserModel> users = [];
    UserModel currentUser = await getCurrentUser();
    try{
      await httpClient.makeJsonGet(dataParam: {
        "name":    name != null ? name : '',
        "user_id": currentUser != null ? currentUser.id.toString() : "0",
      }, url: 'user').then((response) {
        if(response['status'] == 'success'){
          response['data'].forEach((user) {
            users.add(UserModel.fromJson(user));
          });
          // UserModel user = UserModel.fromJson(response['user']);
          // await setCurrentUser(user);
        }
      });
      return users;
    }catch (e){
      return [];
    }
  }
}