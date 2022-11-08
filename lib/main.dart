import 'package:flutter/material.dart';
import 'package:arishti_task/screens/Authentication.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Arishti",
      theme: ThemeData(primarySwatch: Colors.teal),
      home: Authenticate(),
    );
  }
}
