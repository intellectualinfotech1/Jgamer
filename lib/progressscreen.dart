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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            backgroundColor: Colors.redAccent,
            valueColor: AlwaysStoppedAnimation(Colors.green),
            strokeWidth: 5,
          ),
        ),
      ),
    );
  }
}
