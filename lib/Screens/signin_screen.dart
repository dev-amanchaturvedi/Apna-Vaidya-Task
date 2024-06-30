import 'package:apna_vaidya_task/Screens/home_screen.dart';
import 'package:apna_vaidya_task/Screens/reset_password.dart';
import 'package:apna_vaidya_task/Screens/signup_screen.dart';
import 'package:apna_vaidya_task/Screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ReusableWidgets/reusableTextField.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final FocusNode _emailFN = FocusNode();
  final TextEditingController _passwordcontroller = TextEditingController();
  final FocusNode _passwordFN = FocusNode();
  final FocusNode _loginFN = FocusNode();
  String _emailErrorMessage = '';
  String _passwordErrorMessage = '';
  bool isVisible = true;
  final authInstance = FirebaseAuth.instance;
  String? wrongCredentialsErrorMsg;

  Future<void> _login(String email, String password) async {
    try {
      await authInstance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then(
        (userCredentials) async {
          User? user = userCredentials.user;
          await user?.reload();
          if (user != null && user.emailVerified) {
            _emailcontroller.clear();
            _passwordcontroller.clear();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
            SharedPreferences sharedPref =
                await SharedPreferences.getInstance();
            sharedPref.setBool(SplashScreenState.LOGINKEY, true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login Successful'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            await authInstance.signOut();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Please verify your email to log in.',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.yellow,
              ),
            );
          }
        },
      ).onError(
        (error, stackTrace) {
          print('no user found $error');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid email or password.'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E2EB),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login',
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
                    textFieldController: _emailcontroller,
                    currentFN: _emailFN,
                    requestFN: _passwordFN,
                    errorMessage: _emailErrorMessage,
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.mail_outline,
                    wantSuffixIcon: false),
                const SizedBox(
                  height: 20.0,
                ),
                ReusableTextField(
                    textFieldController: _passwordcontroller,
                    currentFN: _passwordFN,
                    requestFN: _loginFN,
                    errorMessage: _passwordErrorMessage,
                    labelText: 'Password',
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: Icons.lock,
                    wantSuffixIcon: true,
                    suffixIcon: CupertinoIcons.eye),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ResetPassword())),
                      child: const Text(
                        "forgot password?",
                        style:
                            TextStyle(fontSize: 12.0, color: Color(0xFF7E57C2)),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: RawMaterialButton(
                    focusNode: _loginFN,
                    onPressed: () async {
                      String email = _emailcontroller.text.trim();
                      String password = _passwordcontroller.text.trim();
                      if (email.isEmpty ||
                          password.isEmpty ||
                          (!email.contains('@') || !email.contains('.'))) {
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
                        _login(email, password);
                      }
                      setState(() {});
                    },
                    fillColor: Colors.deepPurple.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Text(
                      'Login',
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
                      "Don't have an account?",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                      },
                      child: const Text(
                        "Sign Up",
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
