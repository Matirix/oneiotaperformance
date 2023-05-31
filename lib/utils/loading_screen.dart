import 'dart:async';
import 'package:flutter/material.dart';
import 'package:one_iota_mobile_app/screens/sign_in.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const SignIn())));
    // _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    // Simulate a loading delay
    await Future.delayed(const Duration(seconds: 2));

    // Navigate to the home page
    // Navigator.pushReplacementNamed(context, '/screens/sign_in');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF82CA86),
            Color(0xFF22BFEC),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.14),
              child: Image.asset('assets/logo.png'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
