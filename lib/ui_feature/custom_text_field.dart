import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final bool isPassword;
  final TextEditingController controllerText;

  const CustomTextField({
    //super.key,
    required this.hint,
    required this.isPassword,
    required this.controllerText,
  });
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.isPassword ? isObscure : false,
      style: TextStyle(color: Color.fromARGB(194, 239, 135, 87)),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(color: Color.fromARGB(253, 247, 222, 210)),

        filled: true,
        fillColor: Color.fromARGB(184, 255, 255, 255),

        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Color.fromARGB(120, 239, 135, 87),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Color.fromARGB(194, 239, 135, 87),
            width: 2,
          ),
        ),
        // focus + error :
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        // toggle button :
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
              )
            : null,
      ),

      // toggle button :
      validator: widget.isPassword
          ? (value) {
              if (value == null || value.isEmpty) {
                return "${widget.hint} is required !";
              }
              if (value.length < 6) {
                return "Password must contain atleast 6 characters";
              }
              return null;
            }
          : (value) {
              if (value == null || value.isEmpty) {
                return "${widget.hint} is required !";
              }
              return null;
            },
      controller: widget.controllerText,
    );
  }
}
