import 'package:flutter/material.dart';
import 'package:flutter_in_app_purchase/Views/HomeView.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter in-App-Purchase',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        secondaryHeaderColor: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
