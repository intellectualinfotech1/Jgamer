import 'package:flutter/material.dart';

class RoutletScore1 extends StatelessWidget {
  final int selected1;
  var number;

  final Map<int, String> labels = {
    1: '100',
    2: '0',
    3: '5',
    4: '20',
    5: '0',
    6: '10',
    7: '0',
    8: '30',
  };

  RoutletScore1(this.selected1);

  @override
  Widget build(BuildContext context) {
    number = labels[selected1];
    return Text('${labels[selected1]}',
        style: TextStyle(fontStyle: FontStyle.italic, fontSize: 24.0));
  }
}
