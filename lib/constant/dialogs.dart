import 'package:flutter/material.dart';

Future mostrarAlerta(context, String texto) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('An error ocurred'),
        content: Text(texto),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'))
        ],
      );
    },
  );
}
