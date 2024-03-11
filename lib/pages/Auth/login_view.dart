// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_management/pages/Auth/sign_up_view.dart';
import 'package:money_management/Utils/constant.dart';
import 'package:money_management/Utils/utils.dart';
import 'package:money_management/widgets/bottom_navigation_widget.dart';
import 'package:money_management/widgets/custom_button_widget.dart';
import 'package:money_management/widgets/textfeild_widgets.dart';

import 'services/auth_services.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final UserAuth userAuth = UserAuth();
    Size screenSize = Utils().getScreenSize(context);
    var height = screenSize.height;
    var width = screenSize.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formkey,
              child: Center(
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: height * 0.12,
                        ),
                        Icon(
                          Icons.account_balance_wallet_rounded,
                          color: appcolor,
                          size: width * 0.2,
                        ),
                        Text(
                          "Sign In",
                          style: TextStyle(color: appcolor, fontSize: width * 0.15),
                        ),
                        SizedBox(
                          height: height * 0.12,
                        ),
                        TextFieldWidget(textCapitalization: TextCapitalization.none,
                          controller: emailController,
                          hintText: "abcd@gmail.com",
                          obscureText: false,
                          icon: const Icon(Icons.email),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "please enter E-mail address";
                            } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextFieldWidget(textCapitalization: TextCapitalization.none,
                          controller: passwordController,
                          hintText: "Enter password",
                          obscureText: true,
                          icon: const Icon(Icons.lock),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter Password";
                            } else if (value.length < 6) {
                              return "Please enter more than 6 characters";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        // SizedBox(
                        //   height: height * 0.055,
                        //   width: width * 0.6,
                        //   child: ElevatedButton(
                        //     style: ElevatedButton.styleFrom(backgroundColor: appcolor),
                        //     onPressed: () {
                        //       if (_formkey.currentState!.validate()) {
                        //         //   SharedPreferences prefs = await SharedPreferences.getInstance();
                        //         //   prefs.setBool(LoginKey, true);
                        //         Navigator.pushReplacement(
                        //           context,
                        //           MaterialPageRoute(
                        //             builder: (context) => const HomePage(),
                        //           ),
                        //         );
                        //       }
                        //     },
                        //     child: Text(
                        //       "Sign In",
                        //       style: TextStyle(color: Colors.white, fontSize: width * 0.05),
                        //     ),
                        //   ),
                        // ),
                        CustomMainButton(
                          color: appcolor,
                          isLoading: isLoading,
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            if (_formkey.currentState!.validate()) {
                              User? user = await userAuth.signInWithEmailAndPassword(emailController.text.toString().trim(), passwordController.text.toString().trim());
                              // await savedata(userAuth, user);
                              if (user != null) {
                                setState(() {
                                  isLoading = false;
                                });
                                // const snackbar = SnackBar( duration: Duration(microseconds: 1),
                                //   content: Center(child: Text("User is successfully Login")),
                                // );
                                // ScaffoldMessenger.of(context).showSnackBar(snackbar);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Bottom(),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                setState(() {
                                  isLoading = false;
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Center(child: Text("Some error happend")),
                                  ),
                                );
                              }
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          child: Text(
                            "Sign In",
                            style: TextStyle(color: Colors.white, ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpView()));
                          },
                          style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
                          child: const Text(
                            "You don't have accouunt?",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
