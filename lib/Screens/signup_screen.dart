import 'package:apna_vaidya_task/Screens/signin_screen.dart';
import 'package:apna_vaidya_task/Screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ReusableWidgets/reusableTextField.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _addemailcontroller = TextEditingController();
  final FocusNode _emailFN = FocusNode();
  final TextEditingController _addpasswordcontroller = TextEditingController();
  final FocusNode _passwordFN = FocusNode();
  final TextEditingController _addusernamecontroller = TextEditingController();
  final FocusNode _usernameFN = FocusNode();
  final FocusNode _signupFn = FocusNode();
  String _emailErrorMessage = '';
  String _passwordErrorMessage = '';
  String _usernameErrorMessage = '';
  String lookingFor = "Nanny";

  final authInstance = FirebaseAuth.instance;

  void clearForm() {
    _addusernamecontroller.clear();
    _addpasswordcontroller.clear();
    _addemailcontroller.clear();
    _addpasswordcontroller.clear();
  }

  Future<void> _checkEmailVerification(User? user) async {
    user = authInstance.currentUser;
    await user?.reload();
    if (user?.emailVerified ?? false) {
      print('email verfication completed');
      clearForm();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    } else {
      Future.delayed(
          const Duration(seconds: 5), () => _checkEmailVerification(user));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E2EB),
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7E57C2),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ReusableTextField(
                  textFieldController: _addusernamecontroller,
                  currentFN: _usernameFN,
                  requestFN: _emailFN,
                  keyboardType: TextInputType.name,
                  errorMessage: _usernameErrorMessage,
                  labelText: 'Username',
                  prefixIcon: Icons.person_outline,
                  wantSuffixIcon: false,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ReusableTextField(
                  textFieldController: _addemailcontroller,
                  currentFN: _emailFN,
                  requestFN: _passwordFN,
                  errorMessage: _emailErrorMessage,
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.mail_outline,
                  wantSuffixIcon: false,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ReusableTextField(
                    textFieldController: _addpasswordcontroller,
                    currentFN: _passwordFN,
                    requestFN: _signupFn,
                    errorMessage: _passwordErrorMessage,
                    labelText: 'Password',
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: Icons.lock,
                    wantSuffixIcon: true,
                    suffixIcon: CupertinoIcons.eye),
                const SizedBox(
                  height: 25.0,
                ),
                SizedBox(
                  height: 50,
                  width: 200,
                  child: RawMaterialButton(
                    focusNode: _signupFn,
                    onPressed: () async {
                      final email = _addemailcontroller.text.trim();
                      final password = _addpasswordcontroller.text.trim();
                      final username = _addusernamecontroller.text.trim();
                      if (email.isEmpty ||
                          password.isEmpty ||
                          username.isEmpty ||
                          (!email.contains('@') || !email.contains('.'))) {
                        if (username.isEmpty) {
                          _usernameErrorMessage = "Username can not be empty";
                        } else {
                          _usernameErrorMessage = '';
                        }
                        if (email.isEmpty) {
                          _emailErrorMessage = "Email can not be empty";
                        } else {
                          if (!email.contains('@') || !email.contains('.')) {
                            _emailErrorMessage = "Email is badly formatted";
                          } else {
                            _emailErrorMessage = '';
                          }
                        }
                        if (password.isEmpty) {
                          _passwordErrorMessage = "Password can not be empty";
                        } else {
                          _passwordErrorMessage = '';
                        }
                      } else {
                        _emailErrorMessage = '';
                        _passwordErrorMessage = '';
                        _usernameErrorMessage = '';

                        try {
                          print('authentication started');
                          UserCredential userCredential =
                              await authInstance.createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );

                          User? user = userCredential.user;
                          print('verification started');
                          await user?.sendEmailVerification();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'A verification link has been sent to your email. Please verify.',
                                style: TextStyle(color: Colors.black),
                              ),
                              backgroundColor: Colors.yellow,
                            ),
                          );
                          _checkEmailVerification(user);
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Registration failed: $error'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                      setState(() {});
                    },
                    fillColor: Colors.deepPurple.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInScreen()));
                      },
                      child: const Text(
                        "Sign In",
                        style:
                            TextStyle(fontSize: 20.0, color: Color(0xFF7E57C2)),
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
