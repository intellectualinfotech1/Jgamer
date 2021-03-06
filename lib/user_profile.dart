import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jgamer/Install.dart';
import 'package:jgamer/auth.dart';
import 'package:jgamer/coins.dart';
import 'package:jgamer/constants.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:http/http.dart' as http;

class UserProfile extends StatefulWidget {
  final Map userData;
  final List userKeys;
  final http.Response leaderBoard;
  final List refrenceIds;
  final List refrenceNames;
  final List refrenceEmails;
  final List refrenceImage;
  final String shareMessage;

  UserProfile(
    this.userData,
    this.userKeys,
    this.leaderBoard,
    this.refrenceIds,
    this.refrenceNames,
    this.refrenceEmails,
    this.refrenceImage,
    this.shareMessage,
  );
  @override
  State<StatefulWidget> createState() {
    return UserProfileState();
  }
}

class UserProfileState extends State<UserProfile> {
  var auth = Auth();
  http.Response linkDataa;
  Future<http.Response> loadData() async {
    var link = "https://jgamer-347e6-default-rtdb.firebaseio.com/apps.json";
    linkDataa = await http.get(link);
  }

  @override
  Widget build(BuildContext context) {
    var coins = Provider.of<Coins>(context);
    loadData();
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
                            widget.userData["name"][0],
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
                "Refer & Earn",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 20,
                ),
              ),
              subtitle: Text(widget.userKeys[2]["referId"]),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Refrences(
                    widget.refrenceIds,
                    widget.refrenceNames,
                    widget.refrenceEmails,
                    widget.refrenceImage,
                    widget.shareMessage,
                    widget.userKeys,
                  ),
                ),
              ),
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
            ListTile(
              leading: Icon(Icons.leaderboard),
              title: Text(
                "Leaderboard",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 20,
                ),
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LeaderBoard(widget.leaderBoard),
                ),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text(
                "Install & earn",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 20,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InstallnEran(linkDataa)));
              },
            ),
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

class LeaderBoard extends StatefulWidget {
  final http.Response leaderBoard;
  LeaderBoard(this.leaderBoard);
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  List leaderBoard;

  @override
  Widget build(BuildContext context) {
    leaderBoard = jsonDecode(widget.leaderBoard.body).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Leader Board",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: klightDeepBlue,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        height: 320,
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 8,
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    return Container(
                      height: 40,
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          child: Container(
                            alignment: Alignment.center,
                            width: 30,
                            height: 30,
                            color: Colors.blue[800],
                            child: Text(
                              "# ${(index + 1).toString()}",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Quicksand",
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          leaderBoard[index]["name"],
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: Container(
                          width: 80,
                          height: 50,
                          child: Row(
                            children: [
                              Text(
                                leaderBoard[index]["coins"].toString(),
                                style: TextStyle(
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Image.asset(
                                "assets/diamond.png",
                                width: 15,
                                height: 15,
                              ),
                              Divider(
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Refrences extends StatelessWidget {
  List refrenceIds;
  List refrenceNames;
  List refrenceEmails;
  List refrenceImage;
  String shareMessage;
  final List userKeys;

  Refrences(
    this.refrenceIds,
    this.refrenceNames,
    this.refrenceEmails,
    this.refrenceImage,
    this.shareMessage,
    this.userKeys,
  );

  @override
  Widget build(BuildContext context) {
    var temp = jsonDecode(shareMessage);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: klightDeepBlue,
        title: Text(
          "Your refrences",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return refrenceEmails.length == 0
                      ? Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Center(
                            child: Text(
                              "Your refrences appear here",
                              style: TextStyle(
                                fontFamily: "Quicksand",
                                fontSize: 20,
                              ),
                            ),
                          ),
                        )
                      : index < refrenceEmails.length
                          ? Container(
                              margin: EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                  child: Container(
                                    color: klightCyan,
                                    alignment: Alignment.center,
                                    width: 50,
                                    height: 50,
                                    child: Text(
                                      (index + 1).toString(),
                                      style: TextStyle(
                                        fontFamily: "Quicksand",
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  refrenceNames[index],
                                  style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            )
                          : Container();
                },
                itemCount: refrenceEmails.length + 1,
              ),
            ),
            Container(
              child: RaisedButton(
                onPressed: () => Share.share(
                    '${temp["message"]}\n\n${temp["link"]}\n\nUse my refrence code to recieve instant reward :\n${userKeys[2]["referId"]}'),
                color: klightDeepBlue,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "REFER",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Quicksand",
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
