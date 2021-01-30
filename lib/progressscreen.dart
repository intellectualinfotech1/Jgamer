import 'package:flutter/material.dart';

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
        Duration(milliseconds: 5000),
            () {
          Navigator.pop(context);

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(130, 250, 0, 0),
          child:CircularProgressIndicator(
            backgroundColor: Colors.redAccent,
            valueColor: AlwaysStoppedAnimation(Colors.green),
            strokeWidth: 5,

          ),
      ),
    );
  }
}
