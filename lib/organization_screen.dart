import 'package:flutter/material.dart';

class OrganizationsScreen extends StatelessWidget {
  final List<String> organizations = ['Organization A', 'Organization B', 'Organization C'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Organizations', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: organizations.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(organizations[index]),
                    onTap: () {
                      // Navigate to organization details
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            child: Text('Add Organization'),
            onPressed: () {
              // Show dialog or navigate to add organization screen
            },
          ),
        ],
      ),
    );
  }
}