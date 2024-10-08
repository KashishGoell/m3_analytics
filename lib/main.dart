import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:m3_analytics/auth_provider.dart'; // Ensure you have this provider implemented
import 'package:m3_analytics/home_screen.dart'; // Replace with your actual HomeScreen import
import 'package:m3_analytics/login_screen.dart'; // Replace with your actual LoginScreen import
import 'package:m3_analytics/welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Little Drop App',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.isAuthenticated ? HomeScreen(userName: '',) : LoginScreen(), // Conditional navigation
        ),
      ),
    );
  }
}
