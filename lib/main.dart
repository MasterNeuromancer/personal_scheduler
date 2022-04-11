import 'package:flutter/material.dart';
import 'package:personal_scheduler/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Scheduler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Personal Scheduler'),
      debugShowCheckedModeBanner: false,
    );
  }
}
