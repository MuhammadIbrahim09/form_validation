import 'dart:async';

// ignore: depend_on_referenced_packages

//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required String title});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(title: 'Login')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Uniwheel",
              style: TextStyle(
                color: Colors.green,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
