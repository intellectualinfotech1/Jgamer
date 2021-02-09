import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:http/http.dart';
import 'package:jgamer/coins.dart';
import 'package:jgamer/progressscreen.dart';
import 'package:provider/provider.dart';
import 'package:jgamer/constants.dart';
import 'package:ironsource/ironsource.dart';
import 'package:ironsource/models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

const String testDevice = 'YOUR_DEVICE_ID';

class Store extends StatefulWidget {
  final Response linkData;
  Store(this.linkData);
  @override
  _StoreState createState() => _StoreState();
}

enum Level {
  one,
  two,
  three,
}

class _StoreState extends State<Store>
    with IronSourceListener, WidgetsBindingObserver {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: true,
  );

  BannerAd _bannerAd;
  NativeAd _nativeAd;
  InterstitialAd _interstitialAd;
  int _coins = 0;

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: banneridAdmob,
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: interstitialidAdmob,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }

  final _nControler = NativeAdmobController();
  creatNative() {
    NativeAdmob nativeAdmobAd = NativeAdmob(
      adUnitID: nativeidAdmob,
      controller: _nControler,
    );
    return ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
          width: double.infinity,
          height: 300,
          child: nativeAdmobAd,
        ));
  }

  var currentLevel = Level.one;
  var currentSelection;
  var currentSelection2;
  var currentSelection3;
  var _controller = TextEditingController();
  final String appKey = "e873a699";

  bool rewardeVideoAvailable = false,
      offerwallAvailable = false,
      showBanner = false,
      interstitialReady = false;
  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    _bannerAd = createBannerAd()..load();
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      print("RewardedVideoAd event $event");
      if (event == RewardedVideoAdEvent.rewarded) {
        setState(() {
          _coins += rewardAmount;
        });
      }
    };
    WidgetsBinding.instance.addObserver(this);
    init();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _nativeAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        IronSource.activityResumed();
        break;
      case AppLifecycleState.inactive:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.paused:
        // TODO: Handle this case.
        IronSource.activityPaused();
        break;
    }
  }

  void init() async {
    var userId = await IronSource.getAdvertiserId();
    await IronSource.validateIntegration();
    await IronSource.setUserId(userId);
    await IronSource.initialize(appKey: appKey, listener: this);
    rewardeVideoAvailable = await IronSource.isRewardedVideoAvailable();
    offerwallAvailable = await IronSource.isOfferwallAvailable();
    setState(() {});
  }

  void loadInterstitial() {
    IronSource.loadInterstitial();
  }

  void showInterstitial() async {
    if (await IronSource.isInterstitialReady()) {
      IronSource.showInterstitial();
    } else {
      print(
        "Interstial is not ready. use 'Ironsource.loadInterstial' before showing it",
      );
    }
  }

  void showOfferwall() async {
    if (await IronSource.isOfferwallAvailable()) {
      IronSource.showOfferwall();
    } else {
      print("Offerwall not available");
    }
  }

  void showRewardedVideo() async {
    if (await IronSource.isRewardedVideoAvailable()) {
      IronSource.showRewardedVideol();
    } else {
      print("RewardedVideo not available");
    }
  }

  void showHideBanner() {
    setState(() {
      showBanner = !showBanner;
    });
  }

  @override
  Widget build(BuildContext context) {
    var storeData = jsonDecode(widget.linkData.body);
    if (currentLevel == Level.one) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Text(
              "Store",
              style: TextStyle(
                fontFamily: "Quicksand",
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return storeData.keys.toList()[index] == "PUBG Assets" ||
                        storeData.keys.toList()[index] == "Free Fire"
                    ? Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        elevation: 10,
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: GestureDetector(
                          onTap: () {
                            currentSelection = storeData.keys.toList()[index];
                            setState(() {
                              currentLevel = Level.two;
                            });
                            createInterstitialAd()
                              ..load()
                              ..show();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => ProgressScreen()));
                            Future.delayed(Duration(milliseconds: 5000), () {
                              Navigator.pop(context);
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
                                    storeData[storeData.keys.toList()[index]]
                                        ["Weapons"][0]['imgurl'],
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                height: 200,
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
                                  height: 50,
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    storeData.keys.toList()[index],
                                    style: TextStyle(
                                      fontFamily: "Quicksand",
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        elevation: 10,
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: GestureDetector(
                          onTap: () {
                            currentSelection = storeData.keys.toList()[index];
                            setState(() {
                              currentLevel = Level.two;
                            });
                            createInterstitialAd()
                              ..load()
                              ..show();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => ProgressScreen()));
                            Future.delayed(Duration(milliseconds: 5000), () {
                              Navigator.pop(context);
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
                                    storeData[storeData.keys.toList()[index]][0]
                                        ['imgurl'],
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                height: 200,
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
                                  height: 50,
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    storeData.keys.toList()[index],
                                    style: TextStyle(
                                      fontFamily: "Quicksand",
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
              },
              itemCount: storeData.keys.length,
            ),
          ),
        ],
      );
    } else if (currentLevel == Level.two) {
      if (currentSelection == "PUBG Assets" ||
          currentSelection == "Free Fire") {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 40,
                    ),
                    onPressed: () {
                      setState(() {
                        currentSelection = null;
                        currentLevel = Level.one;
                      });
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    currentSelection,
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  var temp = storeData[currentSelection].keys.toList();
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    elevation: 10,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                        currentSelection2 = temp[index].toString();
                        setState(() {
                          currentLevel = Level.three;
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
                                currentSelection == "PUBG Assets"
                                    ? storeData["PUBG Assets"][temp[index]][2]
                                        ["imgurl"]
                                    : storeData["Free Fire"][temp[index]][2]
                                        ["imgurl"],
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            height: 200,
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
                              height: 50,
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                temp[index].toString(),
                                style: TextStyle(
                                  fontFamily: "Quicksand",
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: storeData[currentSelection].keys.toList().length,
              ),
            ),
          ],
        );
      } else if (currentSelection == "Royal Pass") {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 40,
                    ),
                    onPressed: () {
                      showInterstitial();
                      setState(() {
                        currentSelection = null;
                        currentLevel = Level.one;
                      });
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    currentSelection,
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    elevation: 10,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                        showInterstitial();
                        currentSelection2 =
                            storeData[currentSelection][index]["Discription"];
                        showDialog(
                          context: context,
                          child: AlertDialog(
                            title: Image.network(
                              storeData[currentSelection][index]["imgurl"],
                            ),
                            content: Text(
                              "Do you want to buy $currentSelection2 for ${storeData[currentSelection][index]['Diamonds']} diamonds ?",
                              style: TextStyle(
                                fontFamily: "Quicksand",
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            actions: [
                              RaisedButton(
                                onPressed: () {
                                  showInterstitial();
                                  Navigator.of(context).pop();
                                },
                                padding: EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 18),
                                child: Row(
                                  children: [
                                    Icon(Icons.cancel),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Cancel",
                                      style: TextStyle(
                                        fontFamily: "Quicksand",
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RaisedButton(
                                onPressed: () {
                                  var coinProv = Provider.of<Coins>(context,
                                      listen: false);
                                  if (coinProv.getCoins >=
                                      int.parse(storeData[currentSelection]
                                          [index]["Diamonds"])) {
                                    coinProv.reduceCoins(int.parse(
                                        storeData[currentSelection][index]
                                            ["Diamonds"]));
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      child: AlertDialog(
                                        title: Text(
                                          "Enter you ${currentSelection2.toString().startsWith("P") ? 'PUBG ID' : 'FreeFire ID'} your reward will be added to your account.",
                                          style: TextStyle(
                                            fontFamily: "Quicksand",
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        content: TextField(
                                          controller: _controller,
                                          keyboardType: TextInputType.name,
                                          decoration: InputDecoration(
                                            labelText: currentSelection2
                                                    .toString()
                                                    .startsWith("P")
                                                ? "PUBG ID"
                                                : "FreeFire ID",
                                          ),
                                        ),
                                        actions: [
                                          RaisedButton(
                                            onPressed: () async {
                                              if (_controller.text.length >=
                                                  1) {
                                                Navigator.of(context).pop();
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  child: Center(
                                                    child: Container(
                                                      height: 150,
                                                      width: 150,
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  ),
                                                );
                                                await Future.delayed(
                                                  Duration(seconds: 3),
                                                  () {
                                                    Navigator.of(context).pop();
                                                  },
                                                );
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  child: AlertDialog(
                                                    title: Text(
                                                      "Congratulations...\n\nYour purchase is approved on our servers. \nIt will be added to your account in 7 working days",
                                                      style: TextStyle(
                                                        fontFamily: "Quicksand",
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    actions: [
                                                      RaisedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          createInterstitialAd()
                                                            ..load()
                                                            ..show();
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (ctx) =>
                                                                      ProgressScreen()));
                                                          Future.delayed(
                                                              Duration(
                                                                  milliseconds:
                                                                      5000),
                                                              () {
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                        },
                                                        color: klightDeepBlue,
                                                        child: Text(
                                                          "OK",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                "Quicksand",
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            },
                                            color: klightDeepBlue,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 7, horizontal: 18),
                                            child: Text(
                                              "Submit",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Quicksand",
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      child: AlertDialog(
                                        title: Text(
                                          "You do not have enough diamonds",
                                          style: TextStyle(
                                            fontFamily: "Quicksand",
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        content: RaisedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          },
                                          color: klightDeepBlue,
                                          child: Text(
                                            "OK",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Quicksand",
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                padding: EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 18),
                                child: Row(
                                  children: [
                                    Text(
                                      storeData[currentSelection][index]
                                          ["Diamonds"],
                                      style: TextStyle(
                                        fontFamily: "Quicksand",
                                        fontSize: 15,
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                        createInterstitialAd()
                          ..load()
                          ..show();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => ProgressScreen()));
                        Future.delayed(Duration(milliseconds: 5000), () {
                          Navigator.pop(context);
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
                                storeData[currentSelection][index]["imgurl"],
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
                                    storeData[currentSelection][index]
                                        ["Discription"],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        storeData[currentSelection][index]
                                            ["Diamonds"],
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
                    ),
                  );
                },
                itemCount: storeData[currentSelection].toList().length,
              ),
            ),
          ],
        );
      } else {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 40,
                    ),
                    onPressed: () {
                      setState(() {
                        currentSelection = null;
                        currentLevel = Level.one;
                      });
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    currentSelection,
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    elevation: 10,
                    child: Container(
                      height: 100,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: ListTile(
                          onTap: () {
                            showDialog(
                              context: context,
                              child: AlertDialog(
                                title: Text(
                                  "Do you want to purchase ${storeData[currentSelection][index]["Cash"]} for ${storeData[currentSelection][index]["Diamonds"]} diamonds ?",
                                  style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                actions: [
                                  RaisedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      createInterstitialAd()
                                        ..load()
                                        ..show();
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  ProgressScreen()));
                                      Future.delayed(
                                          Duration(milliseconds: 5000), () {
                                        Navigator.pop(context);
                                      });
                                    },
                                    padding: EdgeInsets.symmetric(
                                        vertical: 7, horizontal: 18),
                                    child: Row(
                                      children: [
                                        Icon(Icons.cancel),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Cancel",
                                          style: TextStyle(
                                            fontFamily: "Quicksand",
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RaisedButton(
                                    onPressed: () {
                                      var coinProv = Provider.of<Coins>(context,
                                          listen: false);
                                      if (coinProv.getCoins >=
                                          int.parse(storeData[currentSelection]
                                              [index]["Diamonds"])) {
                                        coinProv.reduceCoins(int.parse(
                                            storeData[currentSelection][index]
                                                ["Diamonds"]));
                                        Navigator.of(context).pop();
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          child: AlertDialog(
                                            title: Text(
                                              "Enter you mobile number here, your purchase will be added to your account.",
                                              style: TextStyle(
                                                fontFamily: "Quicksand",
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            content: TextField(
                                              controller: _controller,
                                              maxLengthEnforced: true,
                                              maxLength: 10,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                labelText: "Mobile Number",
                                              ),
                                            ),
                                            actions: [
                                              RaisedButton(
                                                onPressed: () async {
                                                  if (_controller.text.length ==
                                                      10) {
                                                    Navigator.of(context).pop();
                                                    showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      child: Center(
                                                        child: Container(
                                                          height: 150,
                                                          width: 150,
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      ),
                                                    );
                                                    await Future.delayed(
                                                      Duration(seconds: 3),
                                                      () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    );
                                                    Alert(
                                                      context: context,
                                                      type: AlertType.success,
                                                      title:
                                                          "Congratulations...\n\nYour purchase is approved on our servers.\n\n100₹ added to your Paytm account.",
                                                      style: AlertStyle(
                                                        titleStyle: TextStyle(
                                                          fontFamily:
                                                              "Quicksand",
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        isButtonVisible: false,
                                                      ),
                                                    )..show();
                                                    // showDialog(
                                                    //   context: context,
                                                    //   barrierDismissible: false,
                                                    //   child: AlertDialog(
                                                    //     title: Text(
                                                    // "Congratulations...\n\nYour purchase is approved on our servers. \nIt will be added to your account in 7 working days",
                                                    // style: TextStyle(
                                                    //   fontFamily:
                                                    //       "Quicksand",
                                                    //   fontSize: 20,
                                                    //   fontWeight:
                                                    //       FontWeight.w600,
                                                    // ),
                                                    //     ),
                                                    //     actions: [
                                                    //       RaisedButton(
                                                    //         onPressed: () {
                                                    //           Navigator.of(
                                                    //                   context)
                                                    //               .pop();
                                                    //           createInterstitialAd()
                                                    //             ..load()
                                                    //             ..show();
                                                    //           Navigator.of(
                                                    //                   context)
                                                    //               .push(MaterialPageRoute(
                                                    //                   builder:
                                                    //                       (ctx) =>
                                                    //                           ProgressScreen()));
                                                    //           Future.delayed(
                                                    //               Duration(
                                                    //                   milliseconds:
                                                    //                       5000),
                                                    //               () {
                                                    //             Navigator.pop(
                                                    //                 context);
                                                    //           });
                                                    //         },
                                                    //         color:
                                                    //             klightDeepBlue,
                                                    //         child: Text(
                                                    //           "OK",
                                                    //           style: TextStyle(
                                                    //             color: Colors
                                                    //                 .white,
                                                    //             fontFamily:
                                                    //                 "Quicksand",
                                                    //             fontSize: 20,
                                                    //             fontWeight:
                                                    //                 FontWeight
                                                    //                     .w600,
                                                    //           ),
                                                    //         ),
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // );
                                                  }
                                                },
                                                color: klightDeepBlue,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 7,
                                                    horizontal: 18),
                                                child: Text(
                                                  "Submit",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "Quicksand",
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          child: AlertDialog(
                                            title: Text(
                                              "You do not have enough diamonds",
                                              style: TextStyle(
                                                fontFamily: "Quicksand",
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            content: RaisedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              },
                                              color: klightDeepBlue,
                                              child: Text(
                                                "OK",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Quicksand",
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    padding: EdgeInsets.symmetric(
                                        vertical: 7, horizontal: 18),
                                    child: Row(
                                      children: [
                                        Text(
                                          storeData[currentSelection][index]
                                              ["Diamonds"],
                                          style: TextStyle(
                                            fontFamily: "Quicksand",
                                            fontSize: 15,
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
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                            createInterstitialAd()
                              ..load()
                              ..show();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => ProgressScreen()));
                            Future.delayed(Duration(milliseconds: 5000), () {
                              Navigator.pop(context);
                            });
                          },
                          leading: Image.network(
                            storeData[currentSelection][index]["imgurl"],
                            height: 300,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            storeData[currentSelection][index]["Cash"],
                            style: TextStyle(
                              fontSize: 40,
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          trailing: Container(
                            width: 100,
                            height: 50,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        storeData[currentSelection][index]
                                            ["Diamonds"],
                                        style: TextStyle(
                                          fontFamily: "Quicksand",
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        "assets/diamond.png",
                                        width: 15,
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: storeData[currentSelection].toList().length,
              ),
            ),
          ],
        );
      }
    } else {
      var currentSelection3 =
          currentSelection.toString().startsWith("P") ? "PUBG" : "Free Fire";
      return Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 40,
                  ),
                  onPressed: () {
                    setState(() {
                      currentSelection2 = null;
                      currentLevel = Level.two;
                    });
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  currentSelection2,
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: currentSelection2 == "Outfits" ? 250 : 700,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: currentSelection2 == "Outfits" ? 0.5 : 1.5,
              ),
              itemBuilder: (ctx, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  elevation: 10,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        child: AlertDialog(
                          title: Image.network(
                            storeData[currentSelection][currentSelection2]
                                [index]["imgurl"],
                          ),
                          content: Text(
                            "Do you want to buy this item for ${storeData[currentSelection][currentSelection2][index]['Diamonds']} diamonds ?",
                            style: TextStyle(
                              fontFamily: "Quicksand",
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          actions: [
                            IronSourceBannerAd(
                                keepAlive: true, listener: BannerAdListener()),
                            RaisedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              padding: EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 18),
                              child: Row(
                                children: [
                                  Icon(Icons.cancel),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Cancel",
                                    style: TextStyle(
                                      fontFamily: "Quicksand",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RaisedButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              onPressed: () {
                                var coinProv =
                                    Provider.of<Coins>(context, listen: false);
                                if (coinProv.getCoins >=
                                    int.parse(storeData[currentSelection]
                                            [currentSelection2][index]
                                        ["Diamonds"])) {
                                  coinProv.reduceCoins(int.parse(
                                      storeData[currentSelection]
                                              [currentSelection2][index]
                                          ["Diamonds"]));
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    child: AlertDialog(
                                      title: Text(
                                        "Enter you $currentSelection3 ID here, your reward will be added to your account.",
                                        style: TextStyle(
                                          fontFamily: "Quicksand",
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      content: TextField(
                                        controller: _controller,
                                        decoration: InputDecoration(
                                          labelText: "$currentSelection3 ID",
                                        ),
                                      ),
                                      actions: [
                                        IronSourceBannerAd(
                                            keepAlive: true,
                                            listener: BannerAdListener()),
                                        RaisedButton(
                                          onPressed: () async {
                                            if (_controller.text.isNotEmpty) {
                                              Navigator.of(context).pop();
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                child: Center(
                                                  child: Container(
                                                    height: 150,
                                                    width: 150,
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ),
                                              );
                                              await Future.delayed(
                                                Duration(seconds: 3),
                                                () {
                                                  Navigator.of(context).pop();
                                                },
                                              );
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                child: AlertDialog(
                                                  title: Text(
                                                    "Congratulations...\n\nYour purchase is approved on our servers. \nIt will be added to your $currentSelection3 account in 7 working days",
                                                    style: TextStyle(
                                                      fontFamily: "Quicksand",
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  content: IronSourceBannerAd(
                                                    keepAlive: true,
                                                    listener:
                                                        BannerAdListener(),
                                                  ),
                                                  actions: [
                                                    RaisedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        createInterstitialAd()
                                                          ..load()
                                                          ..show();
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (ctx) =>
                                                                    ProgressScreen()));
                                                        Future.delayed(
                                                            Duration(
                                                                milliseconds:
                                                                    5000), () {
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      color: klightDeepBlue,
                                                      child: Text(
                                                        "OK",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              "Quicksand",
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          },
                                          color: klightDeepBlue,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 7, horizontal: 18),
                                          child: Text(
                                            "Submit",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Quicksand",
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    child: AlertDialog(
                                      title: Text(
                                        "You do not have enough diamonds",
                                        style: TextStyle(
                                          fontFamily: "Quicksand",
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      content: RaisedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        color: klightDeepBlue,
                                        child: Text(
                                          "OK",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Quicksand",
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Row(
                                children: [
                                  Text(
                                    storeData[currentSelection]
                                        [currentSelection2][index]["Diamonds"],
                                    style: TextStyle(
                                      fontFamily: "Quicksand",
                                      fontSize: 15,
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: GridTile(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        child: Image.network(
                          storeData[currentSelection][currentSelection2][index]
                              ["imgurl"],
                          fit: BoxFit.cover,
                        ),
                      ),
                      footer: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          color: kdeepBlue,
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            Text(
                              storeData[currentSelection][currentSelection2]
                                  [index]["Name"],
                              style: TextStyle(
                                fontFamily: "Quicksand",
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  storeData[currentSelection][currentSelection2]
                                      [index]["Diamonds"],
                                  style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: storeData[currentSelection][currentSelection2].length,
            ),
          ),
        ],
      );
    }
  }

  @override
  void onInterstitialAdClicked() {
    print("onInterstitialAdClicked");
  }

  @override
  void onInterstitialAdClosed() {
    print("onInterstitialAdClosed");
  }

  @override
  void onInterstitialAdLoadFailed(IronSourceError error) {
    print("onInterstitialAdLoadFailed : ${error.toString()}");
  }

  @override
  void onInterstitialAdOpened() {
    print("onInterstitialAdOpened");
    setState(() {
      interstitialReady = false;
    });
  }

  @override
  void onInterstitialAdReady() {
    print("onInterstitialAdReady");
    setState(() {
      interstitialReady = true;
    });
  }

  @override
  void onInterstitialAdShowFailed(IronSourceError error) {
    print("onInterstitialAdShowFailed : ${error.toString()}");
    setState(() {
      interstitialReady = false;
    });
  }

  @override
  void onInterstitialAdShowSucceeded() {
    print("nInterstitialAdShowSucceeded");
  }

  @override
  void onGetOfferwallCreditsFailed(IronSourceError error) {
    print("onGetOfferwallCreditsFailed : ${error.toString()}");
  }

  @override
  void onOfferwallAdCredited(OfferwallCredit reward) {
    print("onOfferwallAdCredited : $reward");
  }

  @override
  void onOfferwallAvailable(bool available) {
    print("onOfferwallAvailable : $available");

    setState(() {
      offerwallAvailable = available;
    });
  }

  @override
  void onOfferwallClosed() {
    print("onOfferwallClosed");
  }

  @override
  void onOfferwallOpened() {
    print("onOfferwallOpened");
  }

  @override
  void onOfferwallShowFailed(IronSourceError error) {
    print("onOfferwallShowFailed ${error.toString()}");
  }

  @override
  void onRewardedVideoAdClicked(Placement placement) {
    print("onRewardedVideoAdClicked");
  }

  @override
  void onRewardedVideoAdClosed() {
    print("onRewardedVideoAdClosed");
  }

  @override
  void onRewardedVideoAdEnded() {
    print("onRewardedVideoAdEnded");
  }

  @override
  void onRewardedVideoAdOpened() {
    print("onRewardedVideoAdOpened");
  }

  @override
  void onRewardedVideoAdRewarded(Placement placement) {
    print("onRewardedVideoAdRewarded: ${placement.placementName}");
  }

  @override
  void onRewardedVideoAdShowFailed(IronSourceError error) {
    print("onRewardedVideoAdShowFailed : ${error.toString()}");
  }

  @override
  void onRewardedVideoAdStarted() {
    print("onRewardedVideoAdStarted");
  }

  @override
  void onRewardedVideoAvailabilityChanged(bool available) {
    print("onRewardedVideoAvailabilityChanged : $available");
    setState(() {
      rewardeVideoAvailable = available;
    });
  }
}

class BannerAdListener extends IronSourceBannerListener {
  @override
  void onBannerAdClicked() {
    print("onBannerAdClicked");
  }

  @override
  void onBannerAdLeftApplication() {
    print("onBannerAdLeftApplication");
  }

  @override
  void onBannerAdLoadFailed(Map<String, dynamic> error) {
    print("onBannerAdLoadFailed");
  }

  @override
  void onBannerAdLoaded() {
    print("onBannerAdLoaded");
  }

  @override
  void onBannerAdScreenDismissed() {
    print("onBannerAdScreenDismisse");
  }

  @override
  void onBannerAdScreenPresented() {
    print("onBannerAdScreenPresented");
  }
}
