// import 'dart:ffi';
// import 'dart:js_interop';

import 'package:flutter/material.dart';

class FodaTextfield extends StatelessWidget {
  final String title;
  final bool isPass ;
  final TextEditingController? controller;
  const FodaTextfield({
    Key? key,
    required this.title,
    this.controller, this.isPass = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: this.isPass,
      decoration: InputDecoration(
        hintText: title,
      ),
    );
  }
}
