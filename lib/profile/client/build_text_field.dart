import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildTextField(
    TextEditingController controller,
    //String labelText,
    String hintText,)
{
  return TextFormField(
      controller: controller,
      decoration: InputDecoration(
      //labelText: labelText,
      hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 12,
          color: Color(0xFF4B4646),
        ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFF4B4646)),
        ),
        filled: true,
        fillColor: Color(0xF4F7F9),
        labelStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4B4646),
        ),
      ),
  );
  }
