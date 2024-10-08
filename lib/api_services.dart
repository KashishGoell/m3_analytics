import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart'; // Ensure you import your LoginScreen

class ApiService {
  final String baseUrl = 'http://192.168.6.125/siteLogsAPIs';

  Future<List<dynamic>?> fetchOrganizations(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      _redirectToLogin(context);
      return null; // Return null if no token
    }

    final String apiUrl = '$baseUrl/fetchOrganisations.php';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success']) {
          return data['organisations']; // Return organizations
        } else {
          _showError(context, data['error'] ?? 'Failed to fetch organizations.');
        }
      } else if (response.statusCode == 401) {
        _handleUnauthorized(context);
      } else {
        _showError(context, 'Failed to fetch organizations. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showError(context, 'An error occurred: $e');
    }

    return null; // Return null if fetching failed
  }

  void _redirectToLogin(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void _handleUnauthorized(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _showError(context, 'Session expired. Please log in again.');
    _redirectToLogin(context);
  }

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
