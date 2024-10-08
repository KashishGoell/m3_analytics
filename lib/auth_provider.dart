import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _username;

  bool get isAuthenticated {
    return _token != null;
  }

  String? get token {
    return _token;
  }

  String? get username {
    return _username;
  }

  // Function to log in the user
  Future<void> loginUser(String username, String password) async {
    final url = Uri.parse('http://192.168.6.125/siteLogsAPIs/login.php');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // Specify content type
        },
        body: json.encode({'username': username, 'password': password}),
      );
      final responseData = json.decode(response.body);

      if (responseData['success'] && responseData['token'] != null) {
        _token = responseData['token'];
        _username = responseData['user_name'];
        notifyListeners();

        // Store token in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('username', _username!);
      } else {
        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Error: $error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      throw error;
    }
  }

  // Function to check if the user is logged in
  Future<void> loggedInCheck() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('token')) {
      _token = prefs.getString('token');
      _username = prefs.getString('username');

      // Verify token by calling getUser.php
      final url = Uri.parse('http://192.168.6.125/siteLogsAPIs/getUser.php');
      try {
        final response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer $_token', // Attach token
          },
        );

        final responseData = json.decode(response.body);
        if (responseData['success'] && responseData['userData'] != null) {
          setUserData(responseData['userData']);
        } else {
          // Clear local storage if token is invalid
          await logout();
        }
      } catch (error) {
        Fluttertoast.showToast(
          msg: 'Error verifying token: $error',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );
      }
    }
    notifyListeners();
  }

  // Function to set user data
  void setUserData(Map<String, dynamic> userData) {
    // You can store more user data if needed
    _username = userData['username'];
    notifyListeners();
  }

  // Function to try auto-login
  Future<void> tryAutoLogin() async {
    await loggedInCheck();
  }

  // Function to log out the user
  Future<void> logout() async {
    _token = null;
    _username = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Function to push notifications
  void pushNotify(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
    );
  }
}
