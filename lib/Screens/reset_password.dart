import 'package:apna_vaidya_task/Screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../ReusableWidgets/reusableTextField.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFN = FocusNode();
  final FocusNode _resetFN = FocusNode();
  String _emailErrorMessage = "";
  final authInstance = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E2EB),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Reset Password',
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
                  textFieldController: _emailController,
                  currentFN: _emailFN,
                  requestFN: _resetFN,
                  errorMessage: _emailErrorMessage,
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.mail_outline,
                  wantSuffixIcon: false),
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 50,
                width: 200,
                child: RawMaterialButton(
                  focusNode: _resetFN,
                  onPressed: () {
                    print('button pressed');
                    String email = _emailController.text.trim();
                    if (email.isEmpty) {
                      print('-----------------> email is empty');
                      _emailErrorMessage = "Email can not be empty";
                    } else {
                      if (!email.contains('@') || !email.contains('.')) {
                        print('-----------------> does not contain @ and .');
                        _emailErrorMessage = "Email is badly formatted";
                      } else {
                        print('-------------------> perfect email');
                        _emailErrorMessage = '';
                        try {
                          authInstance.sendPasswordResetEmail(email: email);
                          _emailController.clear();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Password reset link sent'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } on FirebaseAuthException catch (e) {
                          print('reset failed!');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Password Reset Failed!.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
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
                    'Reset Password',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
