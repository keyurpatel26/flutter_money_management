// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_management/Utils/constant.dart';
import 'package:money_management/Utils/utils.dart';
import 'package:money_management/pages/Auth/services/auth_services.dart';
import 'package:money_management/widgets/bottom_navigation_widget.dart';
import 'package:money_management/widgets/custom_button_widget.dart';
import 'package:money_management/widgets/textfeild_widgets.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpassController = TextEditingController();
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
            child: Center(
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * 0.08,
                    ),
                    Icon(
                      Icons.account_balance_wallet_rounded,
                      color: appcolor,
                      size: width * 0.2,
                    ),
                    Text(
                      "Sign Up",
                      style: TextStyle(color: appcolor, fontSize: width * 0.15),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    TextFieldWidget(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      hintText: "Enter your name",
                      obscureText: false,
                      icon: const Icon(Icons.person),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "please enter name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFieldWidget(
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
                      textCapitalization: TextCapitalization.none,
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
                      height: 25,
                    ),
                    TextFieldWidget(textCapitalization: TextCapitalization.none,
                      controller: confirmpassController,
                      hintText: "Enter password",
                      obscureText: true,
                      icon: const Icon(Icons.lock),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Password";
                        } else if (value != passwordController.text) {
                          return "Please enter same Password";
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
                    //     onPressed: () async {
                    //       if (_formkey.currentState!.validate()) {
                    //         User? user = await userAuth.signUpWithEmailAndPassword(emailController.text.toString().trim(), confirmpassController.text.toString().trim());
                    //         await savedata(userAuth, user);
                    //         if (user != null) {
                    //           const SnackBar(content: Text("User is successfully created"));
                    //           Navigator.pushAndRemoveUntil(
                    //             context,
                    //             MaterialPageRoute(
                    //               builder: (context) => const HomePage(),
                    //             ),
                    //             (route) => false,
                    //           );
                    //         } else {
                    //           const SnackBar(content: Text("Some error happend"));
                    //         }
                    //       }
                    //     },
                    //     child: Text(
                    //       "Sign Up",
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
                          User? user = await userAuth.signUpWithEmailAndPassword(emailController.text.toString().trim(), confirmpassController.text.toString().trim());
                          await savedata(userAuth, user);
                          if (user != null) {
                            setState(() {
                              isLoading = false;
                            });
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(
                            //     content: Center(child: Text("User is successfully created")),
                            //   ),
                            // );
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
                        "Sign Up",
                        style: TextStyle(color: Colors.white, fontSize: width * 0.05),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
                      child: const Text(
                        "You have accouunt?",
                      ),
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

  savedata(auth, user) {
    var time = DateTime.now();
    auth.SaveUserDataToFireStore(
      name: nameController.text.toString().trim(),
      email: emailController.text.toString().trim(),
      password: confirmpassController.text.toString().trim(),
      createdAt: time.toString(),
      uid: user!.uid,
      totalincome: 0.0,
      totalexpense: 0.0,
      totaleamount: 0.0,
      profilepic: "",
    );
  }
}
