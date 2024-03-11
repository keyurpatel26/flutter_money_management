import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_management/pages/OnBording/onbording_view.dart';
import 'package:money_management/widgets/bottom_navigation_widget.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          } else if (snapshot.hasData) {
            return const Bottom();
          } else {
            return const OnboardingPage();
          }
        },
      ),
    );
  }
}