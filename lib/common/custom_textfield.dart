import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final int? maxLines;
  final bool isPassword;
  final String? Function(String?)? validator;
  final String? errorText;
  final Function(String?)? onChanged;
  final Function(String?)? onSaved;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyBoardType;
  final String? initialValue;
  final bool enabled;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.maxLines,
    this.isPassword = false,
    this.validator,
    this.inputFormatters,
    this.errorText,
    this.onChanged,
    this.onSaved,
    this.keyBoardType = TextInputType.text,
    this.initialValue,
    this.enabled = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 65),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
        child: TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          decoration: InputDecoration(
            labelText: widget.hintText,
            labelStyle: const TextStyle(fontSize: 20, color: Colors.blue),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: const EdgeInsets.only(bottom: 5),
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
            errorText: widget.errorText,
            errorMaxLines: 3,
            suffixIcon: widget.isPassword
                ? showPassword
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        widthFactor: 0.5,
                        heightFactor: 1,
                        child: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          icon: const Icon(
                            Icons.visibility,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : Align(
                        alignment: Alignment.bottomCenter,
                        widthFactor: 0.5,
                        heightFactor: 1,
                        child: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          icon: const Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                      )
                : null,
            suffixIconConstraints: const BoxConstraints(maxHeight: 30),
          ),
          obscureText: widget.isPassword ? showPassword : false,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          onSaved: widget.onSaved,
          validator: widget.validator,
          keyboardType: widget.keyBoardType,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
        ),
      ),
    );
  }
}
