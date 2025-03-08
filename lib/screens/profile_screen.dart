// screens/profile_screen.dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Pengembang')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            SizedBox(height: 10),
            Text('Nama: Muhammad Syafwannabil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Email: syafwannabil@example.com'),
            Text('Github: github.com/syafwannabil'),
            SizedBox(height: 20),
            Text('Tentang Saya:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Saya adalah seorang pengembang aplikasi Flutter yang ingin membuat aplikasi Islami yang bermanfaat bagi umat.'),
          ],
        ),
      ),
    );
  }
}
