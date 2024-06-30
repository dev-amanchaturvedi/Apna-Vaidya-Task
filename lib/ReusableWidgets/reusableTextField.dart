import 'package:flutter/material.dart';

class ReusableTextField extends StatefulWidget {
  const ReusableTextField({
    required this.textFieldController,
    required this.currentFN,
    required this.requestFN,
    required this.errorMessage,
    required this.labelText,
    required this.keyboardType,
    required this.prefixIcon,
    required this.wantSuffixIcon,
    this.suffixIcon,
  });

  final TextEditingController textFieldController;
  final FocusNode currentFN;
  final FocusNode requestFN;
  final String errorMessage;
  final String labelText;
  final TextInputType keyboardType;
  final IconData prefixIcon;
  final bool wantSuffixIcon;
  final IconData? suffixIcon;

  @override
  State<ReusableTextField> createState() => _ReusableTextFieldState();
}

class _ReusableTextFieldState extends State<ReusableTextField> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.deepPurple),
      controller: widget.textFieldController,
      focusNode: widget.currentFN,
      onSubmitted: (value) {
        widget.currentFN.unfocus();
        widget.requestFN.requestFocus();
      },
      keyboardType: widget.keyboardType,
      obscureText: isVisible,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        prefixIcon: Icon(
          widget.prefixIcon,
          color: Colors.deepPurple,
        ),
        suffixIcon: widget.wantSuffixIcon
            ? IconButton(
                onPressed: () {
                  isVisible = !isVisible;
                  setState(() {});
                },
                icon: Icon(widget.suffixIcon),
                color: Colors.deepPurple)
            : null,
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: Colors.deepPurple, fontSize: 18),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        errorText: widget.errorMessage.isNotEmpty ? widget.errorMessage : null,
      ),
    );
  }
}
