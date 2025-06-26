import 'package:flutter/material.dart';

import 'package:form_validation/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, required String title});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  bool _obscuredPassword = true;
  bool _obscuredConfirmPassword = true;

  final TextEditingController namecontroller = TextEditingController();

  final TextEditingController registrationcontroller = TextEditingController();

  final TextEditingController emailcontroller = TextEditingController();

  final TextEditingController passwordcontroller = TextEditingController();

  final TextEditingController confirmpasswordcontroller =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //Storing Data into Database(FireBase) Code
  // add this at the top

  Future<void> signUp() async {
    if (passwordcontroller.text != confirmpasswordcontroller.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Passwords do not match")));
      return;
    }

    try {
      // Sign up with email and password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: emailcontroller.text.trim(),
            password: passwordcontroller.text.trim(),
          );

      User? user = userCredential.user;

      // Save user details in Firestore
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'name': namecontroller.text.trim(),
        'email': emailcontroller.text.trim(),
        'registration': registrationcontroller.text.trim(),
        'uid': user.uid,
      });

      // Send verification email
      await user.sendEmailVerification();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Verification email sent. Please check your inbox."),
        ),
      );

      // Navigate to login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(title: "Login")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50, width: 100),
                Center(
                  child: Text(
                    "UniWheel",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.green,
                    ),
                  ),
                ),
                SizedBox(height: 30, width: 100),

                // Name Field
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  width: 300,
                  child: TextFormField(
                    controller: namecontroller,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person, color: Colors.green),
                      labelStyle: TextStyle(color: Colors.green),

                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your full name';
                      }
                      return null;
                    },
                  ),
                ),

                // Registration Number
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  width: 300,
                  child: TextFormField(
                    controller: registrationcontroller,
                    decoration: InputDecoration(
                      labelText: 'Registration Number',
                      prefixIcon: Icon(
                        Icons.app_registration,
                        color: Colors.green,
                      ),
                      labelStyle: TextStyle(color: Colors.green),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your registration number';
                      }
                      return null;
                    },
                  ),
                ),

                // Email
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  width: 300,
                  child: TextFormField(
                    controller: emailcontroller,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email, color: Colors.green),
                      labelStyle: TextStyle(color: Colors.green),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),

                // Password
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  width: 300,
                  child: TextFormField(
                    controller: passwordcontroller,
                    obscureText: _obscuredPassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: Colors.green),
                      labelStyle: TextStyle(color: Colors.green),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscuredPassword = !_obscuredPassword;
                          });
                        },
                        icon: Icon(
                          _obscuredPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.green,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                ),

                // Confirm Password
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                  width: 300,
                  child: TextFormField(
                    controller: confirmpasswordcontroller,
                    obscureText: _obscuredConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Re-Password',
                      prefixIcon: Icon(Icons.lock, color: Colors.green),
                      labelStyle: TextStyle(color: Colors.green),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscuredConfirmPassword =
                                !_obscuredConfirmPassword;
                          });
                        },
                        icon: Icon(
                          _obscuredConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.green,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value != passwordcontroller.text) {
                        return 'Passwords do not match';
                      }
                      if (value == null || value.isEmpty) {
                        return 'Enter a re-password';
                      }
                      return null;
                    },
                  ),
                ),

                // Sign Up Button
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        signUp(); // Only runs if form is valid
                      }
                    },
                    child: Text(
                      'SignUp',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                // Already have an account
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(title: 'Login'),
                      ),
                    );
                  },
                  child: Text("Already have an Account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
