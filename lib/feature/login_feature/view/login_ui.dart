//flutter library
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//pubdev library
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

//locla library
import 'package:wheatmap/feature/login_feature/components/validator.dart';
import 'package:wheatmap/feature/login_feature/components/my_textfield.dart';
import 'package:wheatmap/feature/login_feature/components/open_sanckbar.dart';
import 'package:wheatmap/feature/login_feature/controller/login_logic.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final RoundedLoadingButtonController signInController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController twitterController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController phoneController =
      RoundedLoadingButtonController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroudColor =
        Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black54;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: backgroudColor,
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.only(
                        left: 40, right: 40, top: 90, bottom: 30),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.string(
                            '<svg xmlns="http://www.w3.org/2000/svg" width="128" height="128" viewBox="0 0 64 64"><path fill="#75a843" d="M10.7 27.5c-.6 3-.9 6.1-.8 9.1c.1 3 .7 6 1.6 8.8c1 2.8 2.3 5.5 4 8.1c.8 1.3 1.7 2.5 2.7 3.7c1 1.2 2 2.3 3.1 3.4c-1.3-.8-2.5-1.8-3.6-2.9c-1.1-1.1-2.2-2.3-3.1-3.5c-1.9-2.5-3.4-5.3-4.4-8.3c-1-3-1.5-6.2-1.4-9.3c.1-3.2.7-6.3 1.9-9.1m40.6.5c-3.2 1.8-6.3 3.8-9.2 6c-2.9 2.2-5.6 4.7-8 7.4c-2.4 2.7-4.6 5.6-6.4 8.7c-.9 1.6-1.8 3.2-2.5 4.8c-.8 1.7-1.4 3.4-2 5.1c.2-1.8.7-3.6 1.3-5.4c.6-1.8 1.3-3.5 2.2-5.1c1.7-3.3 3.9-6.4 6.4-9.2c2.5-2.8 5.3-5.2 8.4-7.3c3.1-2 6.4-3.8 9.8-5"/><g fill="#f4bc58"><path d="M28.5 14.7c-1.5 1.8-4.1 1.2-4.1 1.2s-1-2.5.4-4.3c1.5-1.8 5-2.3 5-2.3s.1 3.7-1.3 5.4m-5.3.4c.4 1.8-1.2 3.2-1.2 3.2s-2.1-.6-2.6-2.4c-.4-1.8 1-4.4 1-4.4s2.3 1.8 2.8 3.6"/><path d="M26 20.1c-1.8.4-3.2-1.2-3.2-1.2s.6-2.1 2.4-2.6s4.4 1 4.4 1s-1.8 2.3-3.6 2.8m-5.8-.5c.6 1.7-.8 3.4-.8 3.4s-2.2-.3-2.8-2c-.6-1.7.4-4.5.4-4.5s2.6 1.4 3.2 3.1m3.4 4.6c-1.7.6-3.4-.8-3.4-.8s.3-2.2 2-2.8c1.7-.6 4.5.4 4.5.4s-1.4 2.6-3.1 3.2m-5.4.2c.9 1.7-.5 3.6-.5 3.6s-2.3-.1-3.2-1.8c-.9-1.7 0-4.7 0-4.7s2.9 1.1 3.7 2.9m4 4.4c-1.7.9-3.6-.5-3.6-.5s.1-2.3 1.8-3.2c1.7-.9 4.7 0 4.7 0s-1.1 2.8-2.9 3.7M16.4 30c1.2 1.7.1 4 .1 4s-2.5.4-3.7-1.4c-1.2-1.7-.9-5.1-.9-5.1s3.3.8 4.5 2.5m5.2 4.1c-1.7 1.2-4 .1-4 .1s-.4-2.5 1.4-3.7s5.1-.9 5.1-.9s-.8 3.2-2.5 4.5m-6.3 2.6c1.5 1.6.6 4.2.6 4.2s-2.6.7-4.1-.9s-1.6-5.2-1.6-5.2s3.6.2 5.1 1.9m5.9 3.5c-1.6 1.5-4.2.6-4.2.6s-.7-2.6.9-4.1s5.2-1.6 5.2-1.6s-.2 3.6-1.9 5.1"/><path d="M24.5 15.8c-2.5 3.1-4.3 6.7-5.4 10.4c-.5 1.9-1 3.8-1.3 5.7c-.3 1.9-.5 3.9-.6 5.9c-.1 2-.1 3.9-.1 5.9c0 2 .2 3.9.3 5.9c.2 2 .4 3.9.7 5.9c.3 2 .6 3.9 1 5.9c-.6-1.9-1.1-3.8-1.5-5.8c-.4-1.9-.8-3.9-1-5.9c-.3-2-.4-4-.5-6c-.1-2-.1-4 0-6s.3-4 .7-6c.4-2 .8-3.9 1.5-5.8c.6-1.9 1.5-3.7 2.5-5.5c1-1.6 2.2-3.2 3.7-4.6"/></g><g fill="#fc6"><path d="M51.7 8.7c-2.4 1.7-5.6.1-5.6.1s-.4-3.5 2-5.2c2.4-1.7 7.1-1.2 7.1-1.2S54.1 7 51.7 8.7M45 7.4c-.1 2.4-2.7 3.6-2.7 3.6s-2.5-1.4-2.4-3.8C40 4.8 42.6 2 42.6 2s2.5 3 2.4 5.4"/><path d="M46.8 14.5c-2.4-.1-3.6-2.7-3.6-2.7s1.4-2.5 3.8-2.4c2.4.1 5.2 2.7 5.2 2.7s-3 2.5-5.4 2.4M39.7 12c.2 2.4-2.2 3.9-2.2 3.9s-2.6-1.1-2.9-3.5c-.2-2.4 2-5.5 2-5.5s2.9 2.7 3.1 5.1m2.7 6.9c-2.4.2-3.9-2.2-3.9-2.2s1.1-2.6 3.5-2.9c2.4-.2 5.5 2 5.5 2s-2.7 2.9-5.1 3.1m-6.8-1.6c.5 2.5-1.9 4.3-1.9 4.3s-2.9-.9-3.3-3.3c-.5-2.5 1.5-5.9 1.5-5.9s3.2 2.4 3.7 4.9m3.5 6.9c-2.5.5-4.3-1.9-4.3-1.9s.9-2.9 3.3-3.3c2.5-.5 5.9 1.5 5.9 1.5s-2.4 3.2-4.9 3.7m-7.7-.4c1 2.6-1.2 5-1.2 5s-3.2-.4-4.2-3s.6-6.7.6-6.7s3.9 2.1 4.8 4.7m5.1 6.8c-2.6 1-5-1.2-5-1.2s.4-3.2 3-4.2s6.7.6 6.7.6s-2.1 3.8-4.7 4.8m-8.7 1.1c1.4 2.6-.6 5.4-.6 5.4s-3.5 0-4.8-2.6s-.2-7.1-.2-7.1s4.2 1.7 5.6 4.3m6.2 6.5c-2.6 1.4-5.4-.6-5.4-.6s0-3.5 2.6-4.8c2.6-1.4 7.1-.2 7.1-.2s-1.7 4.2-4.3 5.6"/><path d="M46.4 8.8c-4.2 3-7.6 6.9-10.3 11.2c-1.3 2.2-2.5 4.4-3.5 6.8c-1 2.3-1.9 4.7-2.7 7.1c-.8 2.4-1.5 4.9-2.1 7.4c-.6 2.5-1.1 5-1.6 7.5c-.4 2.5-.8 5.1-1.2 7.6c-.3 2.5-.6 5.1-.8 7.7c-.1-2.6-.1-5.2.1-7.7c.2-2.6.4-5.2.7-7.7c.3-2.6.8-5.1 1.4-7.6c.6-2.5 1.2-5 2-7.5s1.8-4.9 2.9-7.3c1.1-2.4 2.4-4.6 3.8-6.8c1.5-2.2 3.1-4.2 5-6c1.9-1.9 4-3.5 6.3-4.7"/></g><path fill="#83bf4f" d="M39.4 39.5c-2.5.5-4.9 1.2-7.1 2.2c-2.2 1-4.2 2.4-6 4.1c-1.7 1.7-3.1 3.7-4.3 5.9c-.6 1.1-1.1 2.2-1.5 3.4c-.4 1.2-.8 2.4-1.1 3.6c0-1.3.1-2.5.4-3.8c.3-1.2.6-2.5 1.1-3.7c1-2.4 2.4-4.6 4.3-6.4c1.9-1.8 4.1-3.2 6.6-4.1c2.5-.9 5.1-1.3 7.6-1.2"/></svg>',
                            width: 80,
                            height: 80,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text("Welcome to WheatMap",
                              style: TextStyle(
                                  fontSize: 25, fontFamily: 'Playpen')),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Helping farmers cope with climate change",
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 40),
                          Form(
                            key: _formKey,
                            child: Column(children: [
                              MyTextField(
                                controller: emailController,
                                obscureText: false,
                                labelText: 'Enter your email',
                                preIcon: Icons.person,
                                validator: Validator().email,
                                keyboardType: TextInputType.name,
                                hintText: '',
                              ),
                              const SizedBox(height: 20),

                              MyTextField(
                                controller: passwordController,
                                obscureText: true,
                                keyboardType: TextInputType.text,
                                labelText: 'Enter your password',
                                preIcon: Icons.password,
                                validator: Validator().password,
                                hintText: '',
                              ),
                              const SizedBox(height: 20),

                              // forgot password?
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      await FirebaseAuth.instance
                                          .sendPasswordResetEmail(
                                              email: emailController.text)
                                          .then((value) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Password reset link has been sent to your email')));
                                      });
                                    },
                                    child: const Text('Forgot password?',
                                        style: TextStyle(color: Colors.grey)),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              RoundedLoadingButton(
                                controller: signInController,
                                height: 50,
                                width: 200,
                                borderRadius: 25,
                                onPressed: () {
                                  final isValid =
                                      _formKey.currentState!.validate();

                                  if (!isValid) {
                                    signInController.reset();
                                    return;
                                  } else {
                                    final sp = context.read<SignInProvider>();
                                    sp.signInWithEmailAndPassword(
                                        emailController.text,
                                        passwordController.text,
                                        context);
                                    _formKey.currentState!.save();
                                  }
                                },
                                color: Colors.blueGrey,
                                successColor: Colors.blueAccent,
                                child: const Text('Sign In',
                                    style: TextStyle(color: Colors.black)),
                              ),
                            ]),
                          ),
                          const SizedBox(height: 40),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 0.5,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    'Or continue with',
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    thickness: 0.5,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RoundedLoadingButton(
                                    onPressed: () {
                                      handleGoogleSignIn();
                                    },
                                    controller: googleController,
                                    valueColor: Colors.blue,
                                    successColor: Colors.yellow,
                                    width: 80,
                                    height: 80,
                                    elevation: 0,
                                    borderRadius: 25,
                                    color: backgroudColor,
                                    child: Image.asset(
                                        'lib/asset/photo/Google.png',
                                        height: 50,
                                        width: 50)),

                                const SizedBox(
                                  width: 20,
                                ),

                                // twitter loading button
                                RoundedLoadingButton(
                                  onPressed: () {
                                    handleTwitterAuth();
                                  },
                                  controller: twitterController,
                                  successColor: Colors.lightBlue,
                                  width: 80,
                                  height: 80,
                                  elevation: 0,
                                  borderRadius: 25,
                                  color: backgroudColor,
                                  child: Image.asset(
                                      'lib/asset/photo/twitter.png',
                                      height: 50,
                                      width: 50),
                                ),

                                const SizedBox(
                                  width: 20,
                                ),

                                // phoneAuth loading button
                                RoundedLoadingButton(
                                  onPressed: () {
                                    context.go('/phone');
                                    phoneController.reset();
                                  },
                                  controller: phoneController,
                                  successColor: Colors.orange,
                                  width: 80,
                                  height: 80,
                                  elevation: 0,
                                  borderRadius: 25,
                                  color: backgroudColor,
                                  child: Image.asset(
                                      'lib/asset/photo/phone.png',
                                      height: 50,
                                      width: 50),
                                ),
                              ])
                        ])))));
  }

  Future handleGoogleSignIn() async {
    final sp = context.read<SignInProvider>();

    await sp.signInWithGoogle().then((value) {
      if (sp.hasError == true) {
        openSnackbar(context, sp.errorCode.toString(), Colors.red);
        googleController.reset();
      } else {
        // checking whether user exists or not
        sp.checkUserExists().then((value) async {
          if (value == true) {
            // user exists
            await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                .saveDataToSharedPreferences()
                .then((value) => sp.setSignIn().then((value) {
                      googleController.success();
                      handleAfterSignIn();
                    })));
          } else {
            // user does not exist
            sp.saveDataToFirestore().then((value) => sp
                .saveDataToSharedPreferences()
                .then((value) => sp.setSignIn().then((value) {
                      googleController.success();
                      handleAfterSignIn();
                    })));
          }
        });
      }
    });
  }

  // handling twitter auth
  Future handleTwitterAuth() async {
    final sp = context.read<SignInProvider>();

    await sp.signInWithTwitter().then((value) {
      if (sp.hasError == true) {
        openSnackbar(context, sp.errorCode.toString(), Colors.red);
        twitterController.reset();
      } else {
        // checking whether user exists or not
        sp.checkUserExists().then((value) async {
          if (value == true) {
            // user exists
            await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                .saveDataToSharedPreferences()
                .then((value) => sp.setSignIn().then((value) {
                      twitterController.success();
                      handleAfterSignIn();
                    })));
          } else {
            // user does not exist
            sp.saveDataToFirestore().then((value) => sp
                .saveDataToSharedPreferences()
                .then((value) => sp.setSignIn().then((value) {
                      twitterController.success();
                      handleAfterSignIn();
                    })));
          }
        });
      }
    });
  }

  // handle after signin
  handleAfterSignIn() {
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      context.go('/home');
    });
  }
}
