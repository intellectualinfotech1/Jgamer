import 'dart:convert';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_apps/device_apps.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class InstallnEran extends StatefulWidget {
  final Response linkDataa;
  InstallnEran(this.linkDataa);
  @override
  _InstallnEranState createState() => _InstallnEranState();
}

class _InstallnEranState extends State<InstallnEran> {

   checkApps(data) async{
    var xyz = await DeviceApps.isAppInstalled(data);
    print(xyz);
    return xyz;
  }


  @override
  Widget build(BuildContext context) {
    var InstallData = jsonDecode(widget.linkDataa.body);
    print(InstallData);
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index)  {
           var isInstalled = false;
          // isInstalled = checkApps(InstallData[index]["packagename"]);

          return Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            margin: EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: GestureDetector(
              onTap: () {

              },
              child: Container(
                height: 160,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: Image.network(
                        InstallData[index]
                        ['imageurl'],
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),

                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                          padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: RaisedButton(
                            onPressed:() {
                              setState(() async{
                                 // isInstalled = await DeviceApps.isAppInstalled(InstallData[index]["packagename"]);

                                if(isInstalled == false){
                                  _launchURL(InstallData[index]);
                                }
                                else{
                                  _onBasicAlertPressed(context);
                                }
                              }
                                );
                              },

                            child: Text("collect" ),

                          )
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
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
_onBasicAlertPressed(context) async{
  Alert(
    context: context,
    title: "RFLUTTER ALERT",
    desc: "Flutter is more awesome with RFlutter Alert.",

  ).show();

}
