import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:m3_analytics/payment_screen.dart';
import 'package:m3_analytics/purchaseorder_screen.dart';
import 'package:m3_analytics/schedule_screem.dart';
import 'package:m3_analytics/user_screen.dart';
import 'package:m3_analytics/vendors_screen.dart';
import 'package:m3_analytics/man_power_screen.dart';
import 'package:m3_analytics/measurement_screen.dart';
import 'package:m3_analytics/dashboard_screen.dart';
import 'package:m3_analytics/expenses_screen.dart';
import 'package:m3_analytics/material_management_screen.dart';
import 'package:m3_analytics/api_services.dart';
import 'package:m3_analytics/auth_provider.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:m3_analytics/login_screen.dart'; // Adjust based on your project structure

class HomeScreen extends StatefulWidget {
  final String userName;

  HomeScreen({required this.userName});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<String> updates = [
    'New feature released: Advanced Analytics',
    'Maintenance scheduled for next week',
    'Check out our latest blog post!',
  ];

  final List<Map<String, dynamic>> weather = [
    {'location': 'New York', 'temp': '72°F', 'condition': 'Sunny'},
    {'location': 'London', 'temp': '15°C', 'condition': 'Cloudy'},
    {'location': 'Tokyo', 'temp': '25°C', 'condition': 'Rainy'},
    {'location': 'Sydney', 'temp': '22°C', 'condition': 'Partly Cloudy'},
    {'location': 'Moscow', 'temp': '10°C', 'condition': 'Snowy'},
    {'location': 'Dubai', 'temp': '35°C', 'condition': 'Hot'},
    {'location': 'Rio', 'temp': '28°C', 'condition': 'Humid'},
  ];

  final List<Map<String, dynamic>> features = [
    {'name': 'Users', 'icon': Icons.people, 'screen': UsersScreen()},
    {'name': 'Vendors', 'icon': Icons.store, 'screen': VendorsScreen()},
    {'name': 'Purchase Orders', 'icon': Icons.shopping_cart, 'screen': PurchaseOrdersScreen()},
    {'name': 'Payments', 'icon': Icons.payment, 'screen': PaymentsScreen()},
    {'name': 'Expenses', 'icon': Icons.money, 'screen': ExpensesScreen()},
    {'name': 'Schedule', 'icon': Icons.calendar_today, 'screen': ScheduleScreen()},
    {'name': 'Dashboard', 'icon': Icons.dashboard, 'screen': DashboardScreen()},
    {'name': 'Measurements', 'icon': Icons.straighten, 'screen': MeasurementsScreen()},
    {'name': 'Material Management', 'icon': Icons.inventory, 'screen': MaterialManagementScreen()},
    {'name': 'Man Power', 'icon': Icons.engineering, 'screen': ManPowerScreen()},
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightBlue[300]!, Colors.lightBlue[100]!],
            stops: [0.0, 0.7],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      WavingHandAnimation(),
                      SizedBox(width: 8),
                      Text(
                        'Hi, ${widget.userName}',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Welcome to M3 Analytics',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 100,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: updates.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.white.withOpacity(0.1),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                updates[index],
                                style: TextStyle(color: Colors.white, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      SunShineAnimation(),
                      SizedBox(width: 8),
                      Text(
                        'Weather',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: weather.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.white.withOpacity(0.1),
                          child: Container(
                            width: 150,
                            height: 150,
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                getWeatherAnimation(weather[index]['condition']),
                                SizedBox(height: 8),
                                Text(
                                  weather[index]['location'],
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  weather[index]['temp'],
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      ExclamationAnimation(),
                      SizedBox(width: 8),
                      Text(
                        'Quick Access',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Card(
                    color: Colors.white.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 1,
                        ),
                        itemCount: features.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => features[index]['screen']),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(features[index]['icon'], color: Colors.white, size: 24),
                                SizedBox(height: 4),
                                Text(
                                  features[index]['name'],
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Handle "Need Help?" button tap
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.help),
                        SizedBox(width: 8),
                        Text('Need Help?'),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.lightBlue,
                      backgroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Add a logout button here
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<AuthProvider>(context, listen: false).logout(); // Logout action
                      // Optionally, navigate to the login screen or any other action after logout
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen()), // Adjust according to your app
                      );
                    },
                    child: Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Change color as desired
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget getWeatherAnimation(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return SunnyAnimation();
      case 'cloudy':
        return CloudyAnimation();
      case 'rainy':
        return RainyAnimation();
      case 'partly cloudy':
        return PartlyCloudyAnimation();
      case 'snowy':
        return SnowyAnimation();
      case 'hot':
        return HotAnimation();
      case 'humid':
        return HumidAnimation();
      default:
        return Icon(Icons.error, color: Colors.white, size: 40);
    }
  }
}

// Existing animations (WavingHandAnimation and SunShineAnimation) remain unchanged

class SunnyAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.wb_sunny, color: Colors.yellow, size: 40);
  }
}

class CloudyAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.cloud, color: Colors.white, size: 40);
  }
}

class RainyAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.grain, color: Colors.lightBlue, size: 40);
  }
}

class PartlyCloudyAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.cloud_queue, color: Colors.white, size: 40);
  }
}

class SnowyAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.ac_unit, color: Colors.white, size: 40);
  }
}

class HotAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.whatshot, color: Colors.orange, size: 40);
  }
}

class HumidAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.water_drop, color: Colors.lightBlue, size: 40);
  }
}

class ExclamationAnimation extends StatefulWidget {
  @override
  _ExclamationAnimationState createState() => _ExclamationAnimationState();
}

class _ExclamationAnimationState extends State<ExclamationAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Icon(Icons.error, color: Colors.red, size: 32),
        );
      },
    );
  }
}
class WavingHandAnimation extends StatefulWidget {
  @override
  _WavingHandAnimationState createState() => _WavingHandAnimationState();
}

class _WavingHandAnimationState extends State<WavingHandAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: -0.1, end: 0.1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value,
          child: Icon(Icons.waving_hand, color: Colors.yellow, size: 32),
        );
      },
    );
  }
}

class SunShineAnimation extends StatefulWidget {
  @override
  _SunShineAnimationState createState() => _SunShineAnimationState();
}

class _SunShineAnimationState extends State<SunShineAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )
      ..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value * 2 * 3.14159,
          child: Icon(Icons.wb_sunny, color: Colors.yellow, size: 32),
        );
      },
    );
  }
}
