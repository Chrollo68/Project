import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(CiviDeskApp());
}

class CiviDeskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CiviDesk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: LoginPage(),
    );
  }
}
