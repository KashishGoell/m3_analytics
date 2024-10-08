import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ManPowerScreen extends StatefulWidget {
  @override
  _ManPowerScreenState createState() => _ManPowerScreenState();
}

class _ManPowerScreenState extends State<ManPowerScreen> {
  int _currentIndex = 0;
  DateTime selectedDate = DateTime.now();
  List<dynamic> attendanceData = [];
  List<dynamic> markedAttendance = [];
  bool isLoading = false;

  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> markAttendance(int workerId, String shift, String description, int orgId, int siteId) async {
    setState(() => isLoading = true);
    try {
      final url = 'http://172.19.118.100/siteLogsAPIs/markAttendance.php';
      String? token = await _getToken();
      if (token == null) {
        _showMessage('No token found. Please log in again.', isError: true);
        return;
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };

      final body = jsonEncode({
        'id': workerId,
        'date': DateFormat('yyyy-MM-dd').format(selectedDate),
        'orgId': orgId,
        'site_id': siteId,
        'selectedShiftNames': [shift],
        'description': description,
        'taskGiven': 'Sample Task',
        'wages': 200.0,
        'selectedShiftValues': [1.0]
      });

      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        fetchMarkedAttendance();
        _showMessage('Attendance marked successfully');
      } else {
        _showMessage('Error marking attendance: ${response.body}', isError: true);
      }
    } catch (e) {
      _showMessage('Error: $e', isError: true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchAttendanceData() async {
    setState(() => isLoading = true);
    try {
      final url = Uri.parse('http://172.19.118.100/siteLogsAPIs/fetchAttendance.php').replace(
        queryParameters: {
          'orgId': '1',
          'date': DateFormat('yyyy-MM-dd').format(selectedDate),
          'site_id': '1',
        },
      );

      String? token = await _getToken();
      if (token == null) {
        _showMessage('No token found. Please log in again.', isError: true);
        return;
      }

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['success']) {
        setState(() {
          attendanceData = responseData['data'];
        });
      } else {
        _showMessage(responseData['message'], isError: true);
      }
    } catch (error) {
      _showMessage('Error fetching attendance data', isError: true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchMarkedAttendance() async {
    try {
      final url = 'http://192.168.6.125/siteLogsAPIs/fetchAttendance.php';
      String? token = await _getToken();
      if (token == null) {
        _showMessage('No token found. Please log in again.', isError: true);
        return;
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };

      final body = jsonEncode({
        'dateFetch': DateFormat('yyyy-MM-dd').format(selectedDate),
        'orgId': 1,
        'site_id': 1
      });

      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body)['attendance'] ?? [];
        setState(() {
          markedAttendance = decodedData;
        });
      } else {
        _showMessage('Error fetching marked attendance', isError: true);
      }
    } catch (error) {
      _showMessage('Error: $error', isError: true);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: isError ? Colors.red : Colors.green,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  void showAddWorkerForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String workerId = '';
        String shift = '';
        String description = '';
        String orgId = '';
        String siteId = '';

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Add Worker Attendance",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: _inputDecoration("Worker ID"),
                  onChanged: (value) => workerId = value,
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: _inputDecoration("Shift"),
                  onChanged: (value) => shift = value,
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: _inputDecoration("Description"),
                  onChanged: (value) => description = value,
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: _inputDecoration("Org ID"),
                  onChanged: (value) => orgId = value,
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: _inputDecoration("Site ID"),
                  onChanged: (value) => siteId = value,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Cancel"),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (workerId.isNotEmpty && orgId.isNotEmpty && siteId.isNotEmpty) {
                          markAttendance(
                            int.parse(workerId),
                            shift,
                            description,
                            int.parse(orgId),
                            int.parse(siteId),
                          );
                          Navigator.of(context).pop();
                        } else {
                          _showMessage('Please fill in all required fields', isError: true);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                      ),
                      child: Text("Submit"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      fetchAttendanceData();
      fetchMarkedAttendance();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAttendanceData();
    fetchMarkedAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[300]!,
              Colors.blue[100]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Man Power Management',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: Icon(Icons.calendar_today),
                          label: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                          onPressed: () => _selectDate(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue[700],
                          ),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton.icon(
                          icon: Icon(Icons.person_add),
                          label: Text('Add Worker'),
                          onPressed: showAddWorkerForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator(color: Colors.white))
                    : ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    _buildCard(
                      'Mark Attendance',
                      DataTable(
                        columns: [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Role')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: attendanceData.map<DataRow>((worker) {
                          return DataRow(cells: [
                            DataCell(Text(worker['id'].toString())),
                            DataCell(Text(worker['name'] ?? '')),
                            DataCell(Text(worker['role'] ?? '')),
                            DataCell(
                              ElevatedButton(
                                onPressed: () => markAttendance(
                                  worker['id'],
                                  'Day Shift',
                                  '',
                                  1,
                                  1,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[700],
                                  foregroundColor: Colors.white,
                                ),
                                child: Text('Mark'),
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildCard(
                      'Marked Attendance',
                      DataTable(
                        columns: [
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Shift')),
                          DataColumn(label: Text('Status')),
                        ],
                        rows: markedAttendance.map<DataRow>((attendance) {
                          return DataRow(cells: [
                            DataCell(Text(attendance['name'] ?? '')),
                            DataCell(Text(attendance['shift'] ?? '')),
                            DataCell(Text(attendance['status'] ?? '')),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

  Widget _buildCard(String title, Widget content) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: content,
          ),
        ],
      ),
    );
  }
}