import 'package:archery_clock_remote/pages/home_page.dart';
import 'package:archery_clock_remote/models/connection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(    ChangeNotifierProvider(
  // Initialize the model in the builder. That way, Provider
  // can own Counter's lifecycle, making sure to call `dispose`s
  // when not needed anymore.
  create: (_) => new Connection(),
  child: MyApp(),
),
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Archery Timer Remote',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomePage(),
    );
  }
}