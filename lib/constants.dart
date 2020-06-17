import 'package:flutter/material.dart';

const kTextFormFieldDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.horizontal(
      left: Radius.circular(20), 
      right:  Radius.circular(20),
      ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.0),
    borderRadius: BorderRadius.horizontal(
      left: Radius.circular(20), 
      right:  Radius.circular(20),
      ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 3.0),
    borderRadius: BorderRadius.horizontal(
      left: Radius.circular(20), 
      right:  Radius.circular(20),
      ),
  ),
);

const kTextFormFieldDecoration2 = InputDecoration(
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 3.0),
  ),
);