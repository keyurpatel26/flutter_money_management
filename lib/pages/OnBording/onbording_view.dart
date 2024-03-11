import 'package:flutter/material.dart';
import 'package:money_management/pages/Auth/login_view.dart';
import 'package:money_management/pages/OnBording/onbording_data.dart';
import 'package:money_management/Utils/constant.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: appcolor,
      body: OnBordingView(),
    );
  }
}

class OnBordingView extends StatefulWidget {
  const OnBordingView({
    super.key,
  });

  @override
  State<OnBordingView> createState() => _OnBordingViewState();
}

class _OnBordingViewState extends State<OnBordingView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Image.asset(
            OnboardingData().items[currentIndex].image,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text(
                OnboardingData().items[currentIndex].title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                OnboardingData().items[currentIndex].description,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              3,
              (index) => AnimatedContainer(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: currentIndex == index ? Colors.white : Colors.grey,
                  ),
                  height: 7,
                  width: currentIndex == index ? 30 : 7,
                  duration: const Duration(milliseconds: 700))),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          width: MediaQuery.of(context).size.width * .9,
          height: 55,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
          child: TextButton(
            onPressed: () {
              if (currentIndex == 2) {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginView()), (route) => false);
              } else {
                setState(() {
                  currentIndex = currentIndex + 1;
                });
              }
            },
            child: Text(
              currentIndex == 0
                  ? "Get started"
                  : currentIndex == 1
                      ? "Amazing"
                      : "I'M READY",
              style: const TextStyle(color: appcolor),
            ),
          ),
        ),
        
      ],
    );
  }
}
