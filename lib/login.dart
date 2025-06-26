import 'package:flutter/material.dart';
import 'package:form_validation/choosescreen.dart';
import 'package:form_validation/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required String title});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isObscured = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Code for login into the app
  Future<void> login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (!userCredential.user!.emailVerified) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Email is not verified yet")));
        return;
      }
      if (!mounted) return;
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              content: Text("Welcome to the uniWheel"),
              title: Text(
                "Login Successfully",
                style: TextStyle(color: Colors.green),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            ),
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error is:$e")));
    }
  }

  // Code for Google Sign-In
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult = await _auth.signInWithCredential(
          credential,
        );
        final User? user = authResult.user;

        if (user != null) {
          if (!mounted) return;
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  content: Text("Welcome to the uniWheel"),
                  title: Text(
                    "Login Successfully with Google",
                    style: TextStyle(color: Colors.green),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
          );
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to sign in with Google: $e")),
      );
    }
  }

  // Code for Password Reset
  Future<void> resetpassword() async {
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Enter email to reset password")));
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Password reset email sent")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error occured:$e")));
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

                // Email Field with Validation
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  width: 300,
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      labelStyle: TextStyle(color: Colors.green),
                      prefixIcon: Icon(Icons.email, color: Colors.green),
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
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),

                // Password Field with Validation
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  width: 300,
                  child: TextFormField(
                    obscureText: _isObscured,
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.green),
                      prefixIcon: Icon(Icons.lock, color: Colors.green),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                        icon: Icon(
                          _isObscured ? Icons.visibility_off : Icons.visibility,
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
                        return 'Enter your password';
                      }
                      return null;
                    },
                  ),
                ),

                // Forgot Password
                Container(
                  padding: EdgeInsets.fromLTRB(180, 0, 0, 30),
                  child: InkWell(
                    onTap: resetpassword,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),

                // Login Button with Validation Check
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
                        login();
                      }
                    },
                    child: Text('Login', style: TextStyle(color: Colors.white)),
                  ),
                ),

                // Google Sign-In Button
                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: 300,
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.facebook),

                    label: Text(
                      'Sign in with Google',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(color: Colors.grey),
                    ),
                    onPressed: signInWithGoogle,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 200),
                    Text(
                      "Didn't register? ",
                      style: TextStyle(color: Colors.black),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupPage(title: 'Signup'),
                          ),
                        );
                      },
                      child: Text(
                        "SignUp",
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
