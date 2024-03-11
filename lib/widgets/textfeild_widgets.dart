// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:money_management/Utils/constant.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  Icon? icon;
  TextCapitalization textCapitalization;
  final TextInputType keyboardType;
  String? Function(String?)? validator;
  TextFieldWidget({
    Key? key,
    required this.controller,
    required this.obscureText,
    required this.hintText,
    this.icon,
    this.validator,
    required this.textCapitalization,
    required this.keyboardType,
  }) : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late FocusNode focusNode;
  bool isInFocus = false;
  late bool passwordVisible;

  @override
  void initState() {
    super.initState();
    passwordVisible = widget.obscureText;
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          isInFocus = true;
        });
      } else {
        setState(() {
          isInFocus = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: widget.textCapitalization,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      focusNode: focusNode,
      obscureText: passwordVisible,
      controller: widget.controller,
      maxLines: 1,
      decoration: InputDecoration(
        prefixIcon: widget.icon,
        suffixIcon: widget.obscureText
            ? IconButton(
                onPressed: () {
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
                icon: Icon(
                  passwordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
              )
            : const SizedBox(),
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          overflow: TextOverflow.ellipsis,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: appcolor,
            width: 1,
          ),
        ),
      ),
    );
  }
}
