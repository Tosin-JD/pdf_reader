import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutDeveloperScreen extends StatelessWidget {
  const AboutDeveloperScreen({super.key});

  static const String _coffeeUrl = 'https://buymeacoffee.com/tosin789';

  Future<void> _launchCoffeeLink() async {
    final uri = Uri.parse(_coffeeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $_coffeeUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About the Developer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Oluwatosin Durodola",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Oluwatosin is a passionate and versatile software developer focused on building useful, elegant, and offline-friendly apps for daily life. "
              "He specializes in Flutter, Javascript, Python, and full-stack development with a strong emphasis on clean architecture and user experience.\n\n"
              "He loves open-source, mobile innovation, and helping others learn to build scalable apps using good software engineering practices.\n\n"
              "When not coding, Oluwatosin is likely exploring tech trends, reading, or working on his personal projects.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.local_cafe),
                label: const Text(
                  'Buy me a coffee',
                  style: TextStyle(color: Colors.amber),
                ),
                onPressed: _launchCoffeeLink,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[400],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
