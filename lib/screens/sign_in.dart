import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../api/auth.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //TODO: display this error messsage somewhere
  //String? _errorMessage = '';

  Future<void> signInWithEmailAndPassword() async {
    try {
      // await Auth().signInWithEmailAndPassword(
      //     email: _emailController.text, password: _passwordController.text);
      //TODO:Remove afterr test
      await Auth().signInWithEmailAndPassword(
          email: "ryanstolys+test@gmail.com", password: "1ioPerform");
    } on FirebaseAuthException {
      setState(() {
        //_errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'LOG IN',
                        style: TextStyle(
                          color: Color(0xFF155B94),
                          fontSize: 35,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Welcome back to one iota',
                        style: TextStyle(
                          color: const Color(0xFF155B94).withOpacity(0.8),
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              const Image(
                image: AssetImage('assets/logo.png'),
                height: 100,
                width: 400,
              ),
              const SizedBox(
                height: 60,
              ),
              const Text('Username:',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF155B94),
                  )),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: const Color(0xFFF2F2F2),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: const EdgeInsets.only(
                    top: -15,
                    left: 10,
                    right: 10,
                  ),
                  labelText: 'Username',
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Set border radius
                    borderSide: const BorderSide(
                      color: Color(0xfff1f1f1), // Customize border color
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Set border radius
                    borderSide: const BorderSide(
                      color:
                          Color(0xfff1f1f1), // Customize focused border color
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text('Password:',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF155B94),
                  )),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor: const Color(0xFFF2F2F2),
                  contentPadding: const EdgeInsets.only(
                    top: -15,
                    left: 10,
                    right: 10,
                  ),
                  labelText: 'Password',
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Set border radius
                    borderSide: const BorderSide(
                      color: Color(0xfff1f1f1), // Customize border color
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Set border radius
                    borderSide: const BorderSide(
                      color:
                          Color(0xfff1f1f1), // Customize focused border color
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 55.0,
              ),
              Column(
                children: [
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: const Color(0xFF155B94),
                      ),
                      onPressed: () {
                        signInWithEmailAndPassword();
                      },
                      child: const Text(
                        'LOG IN',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                          color: Color(0xFF155B94),
                          width: 3,
                        ),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      const url =
                          "https://app.oneiotaperformance.com/auth/create";
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WebviewScaffold(
                            url: url,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Don\'t have an account? SIGN UP',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF155B94),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
