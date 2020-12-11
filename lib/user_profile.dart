import 'package:flutter/material.dart';
import 'package:jgamer/auth.dart';

class UserProfile extends StatefulWidget {
  final Map userData;
  final List userKeys;
  UserProfile(this.userData, this.userKeys);
  @override
  State<StatefulWidget> createState() {
    return UserProfileState();
  }
}

class UserProfileState extends State<UserProfile> {
  var auth = Auth();
  @override
  Widget build(BuildContext context) {
    print(widget.userKeys);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 30,
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  child: widget.userData["imgUrl"] == null
                      ? Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 50,
                          color: Colors.blue[800],
                          child: Text(
                            widget.userData["email"][0],
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Quicksand",
                              fontSize: 30,
                            ),
                          ),
                        )
                      : Image.network(
                          widget.userData["imgUrl"],
                        ),
                ),
                title: widget.userData["name"] == null
                    ? Text(
                        widget.userData["email"],
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          fontFamily: "Quicksand",
                        ),
                      )
                    : Text(
                        widget.userData["name"],
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          fontFamily: "Quicksand",
                        ),
                      ),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.swap_horizontal_circle),
              title: Text(
                "Refferal Code",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 20,
                ),
              ),
              subtitle: Text(widget.userKeys[0]),
            ),
            ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text(
                "Coins",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 20,
                ),
              ),
              subtitle: Text(widget.userKeys[1].toString()),
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
            ),
          ],
        ),
      ),
    );
  }
}
