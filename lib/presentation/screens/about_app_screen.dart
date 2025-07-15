import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About PDF Reader")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "PDF Reader",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Version 1.0.0"),
            SizedBox(height: 16),
            Text(
              "This app allows you to open, read, bookmark, and search within PDF documents. "
              "Built with Flutter using Clean Architecture for scalability and maintainability.",
            ),
            SizedBox(height: 16),
            Text("© 2025 Oluwatosin Joseph Durodola"),
          ],
        ),
      ),
    );
  }
}
