import 'package:flutter/material.dart';
import 'package:jgamer/RateApp.dart';
import 'package:jgamer/auth.dart';
import 'package:jgamer/coins.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:rate_my_app/rate_my_app.dart';

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
    var coins = Provider.of<Coins>(context);
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
              subtitle: Text(widget.userKeys[2]["referId"]),
              onTap: () => Share.share(
                  "download jgamer from link and use my reffrel code ${widget.userKeys[2]['referId']} www.google.com"),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text(
                "Coins",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 20,
                ),
              ),
              subtitle: Text(coins.getCoins.toString()),
            ),
            Divider(),
            FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RateApps1()),
                  );
                },
                child: Text("Press")),
            ListTile(
                leading: Icon(Icons.star),
                title: Text(
                  "Rate My App",
                  style: TextStyle(
                    fontFamily: "Quicksand",
                    fontSize: 20,
                  ),
                ),
                subtitle: Text("get 1000 diamonds"),
                onTap: () {}),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                "Log Out",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 20,
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      title: Text(
                        "Are you sure you want to log out ?",
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      actionsPadding: EdgeInsets.only(
                        left: 50,
                      ),
                      actions: [
                        FlatButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            auth.logOut(context);
                          },
                          child: Text(
                            "Log Out",
                            style: TextStyle(
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          textColor: Colors.redAccent[700],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}

class RateMyApp {
  WidgetBuilder builder = buildProgressIndicator;

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Rate my app !'),
          ),
          body: RateMyAppBuilder(
            builder: builder,
            onInitialized: (context, rateMyApp) {
              rateMyApp.conditions.forEach((condition) {
                if (condition is DebuggableCondition) {
                  print(condition
                      .valuesAsString); // We iterate through our list of conditions and we print all debuggable ones.
                }
              });

              print('Are all conditions met ? ' +
                  (rateMyApp.shouldOpenDialog ? 'Yes' : 'No'));

              if (rateMyApp.shouldOpenDialog) {
                rateMyApp.showRateDialog(context);
              }
            },
          ),
        ),
      );

  /// Builds the progress indicator, allowing to wait for Rate my app to initialize.
  static Widget buildProgressIndicator(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}
