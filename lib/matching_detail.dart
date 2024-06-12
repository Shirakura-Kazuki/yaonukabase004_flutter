import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> originalIdea;
  final Map<String, dynamic> otherIdea;

  const DetailScreen({Key? key, required this.originalIdea, required this.otherIdea}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details of ${originalIdea['ideaid']} and ${otherIdea['ideaid']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Original Idea:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('ID: ${originalIdea['ideaid']}', style: TextStyle(fontSize: 16)),
            Text('Description: ${originalIdea['description']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('Other Idea:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('ID: ${otherIdea['ideaid']}', style: TextStyle(fontSize: 16)),
            Text('Description: ${otherIdea['description']}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
