import 'package:flutter/material.dart';

class ErrorLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Error'),
      content: Text('wrong login or password'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('ОК'),
        ),
      ],
    );
  }
}

class SuccesLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('welcome'),
      content: Text('Loading dialogs'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('ОК'),
        ),
      ],
    );
  }
}

class NotFountServer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Attention'),
      content: Text('No connection to server'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('ОК'),
        ),
      ],
    );
  }
}
