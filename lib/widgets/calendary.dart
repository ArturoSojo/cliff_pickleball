import 'package:flutter/material.dart';

class Calendary {
  static pickDateDialog(context, function) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000, 8),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return function(DateTime.now());
      }
      return function(pickedDate);
    });
  }
}
