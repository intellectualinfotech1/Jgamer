import 'dart:convert';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_apps/device_apps.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'constants.dart';

class InstallnEran extends StatefulWidget {
  final Response linkDataa;
  InstallnEran(this.linkDataa);
  @override
  _InstallnEranState createState() => _InstallnEranState();
}

class _InstallnEranState extends State<InstallnEran> {
  checkApps(data) async {
    var xyz = await DeviceApps.isAppInstalled(data);
    print(xyz);
    return xyz;
  }

  @override
  Widget build(BuildContext context) {
    var InstallData = jsonDecode(widget.linkDataa.body);
    print(InstallData);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: klightDeepBlue,
        title: Text(
          'Install & Earn',
          style: TextStyle(
            fontFamily: "Quicksand",
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          // isInstalled = checkApps(InstallData[index]["packagename"]);

          return Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              margin: EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: InkWell(
                onTap: () {
                  setState(() async {
                    bool isInstalled = await DeviceApps.isAppInstalled(
                        InstallData[index]["packagename"]);

                    if (isInstalled == false) {
                      _launchURL(InstallData[index]);
                    } else {
                      _onBasicAlertPressed(context);
                    }
                  });
                },
                child: Stack(
                  children: [
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        child: Image.network(
                          InstallData[index]["imageurl"],
                          width: double.infinity,
                          height: 170,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: 260,
                      width: double.infinity,
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          color: kdeepBlue,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        height: 90,
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              InstallData[index]["name"],
                              style: TextStyle(
                                fontFamily: "Quicksand",
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  InstallData[index]["Diamonds"],
                                  style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Image.asset(
                                  "assets/diamond.png",
                                  width: 18,
                                  height: 18,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        },
        itemCount: InstallData.length,
      ),
    );
  }
}

_launchURL(InstallData) async {
  var url = InstallData["applink"];
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_onBasicAlertPressed(context) async {
  Alert(
    context: context,
    title: "Sorry",
    desc: "This app is already install in your device",
    buttons: [
      DialogButton(
        color: Colors.blueAccent,
        radius: BorderRadius.all(
          Radius.circular(10),
        ),
        child: Text(
          "OK",
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  ).show();
}
