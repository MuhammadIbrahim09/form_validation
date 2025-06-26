import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: use_key_in_widget_constructors
class ProfileScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

    setState(() {
      name = doc['name'];
      email = doc['email'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(Icons.account_circle, size: 100),
              SizedBox(height: 20),
              Text("Name: $name", style: TextStyle(fontSize: 20)),
              Text("Email: $email", style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
