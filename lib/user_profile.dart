import 'package:flutter/material.dart';
import 'package:jgamer/auth.dart';

class UserProfile extends StatefulWidget {
  final Map userData;
  UserProfile(this.userData);
  @override
  State<StatefulWidget> createState() {
    return UserProfileState();
  }
}

class UserProfileState extends State<UserProfile> {
  var auth = Auth();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  child: Image.network(widget.userData["imgUrl"]),
                ),
                title: Text(
                  widget.userData["name"],
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    fontFamily: "Quicksand",
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 200,
            ),
            RaisedButton(
              onPressed: () {
                auth.logOut(context);
              },
              child: Text(
                "Log Out",
                style: TextStyle(fontFamily: "Quicksand"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
