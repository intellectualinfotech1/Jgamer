import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/material.dart';
import 'package:jgamer/constants.dart';
import 'package:jgamer/progressscreen.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'coins.dart';

class TasksButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  "assets/4.jpeg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: FlatButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => TasksPage(),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                child: Text(
                  "Complete Tasks and Earn Money",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Quicksand",
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
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

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {


  bool _isInterstitialAdLoaded = false;
  bool _isRewardedAdLoaded = false;
  bool _isRewardedVideoComplete = false;

  /// All widget ads are stored in this variable. When a button is pressed, its
  /// respective ad widget is set to this variable and the view is rebuilt using
  /// setState().
  Widget _currentAd = SizedBox(
    width: 0.0,
    height: 0.0,
  );

  @override
  void initState() {
    super.initState();
    setState(() {
      _loadInterstitialAd();
    });

  }


  void _loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId:
      "411792826571456_411793176571421",
      listener: (result, value) {
        print(">> FAN > Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED)
          _isInterstitialAdLoaded = true;

        /// Once an Interstitial Ad has been dismissed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if (result == InterstitialAdResult.DISMISSED &&
            value["invalidated"] == true) {
          _isInterstitialAdLoaded = false;
          _loadInterstitialAd();
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    var coinProvider = Provider.of<Coins>(context);
    var currentCoins = coinProvider.getCoins;
    var counter = 5;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: klightDeepBlue,
        toolbarHeight: 60,
        actions: [
          Image.asset(
            "assets/diamond.png",
            height: 25,
            width: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 13, right: 15, left: 10),
            child: Text(
              currentCoins.toString(),
              style: TextStyle(
                fontSize: 25,
                fontFamily: "Quicksand",
              ),
            ),
          )
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery
                    .of(context)
                    .size
                    .height * 0.1,
                left: MediaQuery
                    .of(context)
                    .size
                    .height * 0.05,
              ),
              alignment: Alignment.center,
              child: Text(
                "Complete the tasks to earn 40 diamonds",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery
                    .of(context)
                    .size
                    .height * 0.05,
                left: MediaQuery
                    .of(context)
                    .size
                    .height * 0.05,
              ),
              child: Text(
                "1. Load the Ad from button below",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 22,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery
                    .of(context)
                    .size
                    .height * 0.05,
                left: MediaQuery
                    .of(context)
                    .size
                    .height * 0.05,
              ),
              child: Text(
                "2. Click on it",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 22,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery
                    .of(context)
                    .size
                    .height * 0.05,
                left: MediaQuery
                    .of(context)
                    .size
                    .height * 0.05,
              ),
              child: Text(
                "3. Install the app and recieve your diamonds $counter",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 22,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery
                    .of(context)
                    .size
                    .height * 0.05,
                left: MediaQuery
                    .of(context)
                    .size
                    .height * 0.05,
              ),
              height: 80,
              width: 200,
              child: RaisedButton(
                onPressed: () {
                  _loadInterstitialAd();
                  if(_isInterstitialAdLoaded){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => ProgressScreen()));
                    Future.delayed(Duration(milliseconds: 5000), () {
                      Navigator.pop(context);
                    });
                    _showInterstitialAd();
                    var coins = Provider.of<Coins>(context, listen: false);
                    coins.addCoins(5);
                  }else{
                   _onBasicAlertPressed1(context);
                  }
                },
                color: klightDeepBlue,
                child: Text(
                  "Load Ad",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Quicksand",
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showInterstitialAd() {
    if (_isInterstitialAdLoaded == true)
      FacebookInterstitialAd.showInterstitialAd();
    else
      print("Interstial Ad not yet loaded!");
  }

  _showBannerAd() {
    setState(() {
      _currentAd = FacebookBannerAd(
        placementId:
        "411792826571456_411795863237819",
        bannerSize: BannerSize.STANDARD,
        listener: (result, value) {
          print("Banner Ad: $result -->  $value");
        },
      );
    });
  }
  _onBasicAlertPressed1(context) {
    Alert(
      context: context,
      title: "Sorry",
      desc: "This time we have no ads please try after some time",
      style: AlertStyle(
        titleStyle: TextStyle(
          fontSize: 20,
          fontFamily: "Quicksand",
          fontWeight: FontWeight.bold,
        ),
        descStyle: TextStyle(
          fontSize: 18,
          fontFamily: "Quicksand",
        ),
      ),
      buttons: [
        DialogButton(
          color: Colors.purple,
          radius: BorderRadius.all(
            Radius.circular(10),
          ),
          child: Text(
            "Ok",
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


}
