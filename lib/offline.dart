import 'package:flutter/material.dart';

class OfflineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/no-internet.png",
              height: 100,
              width: 100,
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "No Internet",
              style: TextStyle(
                fontFamily: "Quicksand",
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
