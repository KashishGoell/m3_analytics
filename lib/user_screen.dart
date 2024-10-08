import 'package:flutter/material.dart';
import 'package:m3_analytics/home_screen.dart';
import 'package:m3_analytics/Man_power_screen.dart';
import 'package:m3_analytics/dashboard_screen.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  int _currentIndex = 1; // Set to 1 for Users screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: Center(child: Text('Users management screen')),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              switch (index) {
                case 0:
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen(userName: 'User')), // Replace 'User' with actual username
                  );
                  break;
                case 1:
                // Already on UsersScreen
                  break;
                case 2:
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ManPowerScreen()),
                  );
                  break;
                case 3:
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                  break;
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.engineering),
                label: 'Man Power',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
            ],
            selectedItemColor: Colors.blue[700],
            unselectedItemColor: Colors.grey[600],
            showUnselectedLabels: true,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
          ),
        ),
      ),
    );
  }
}