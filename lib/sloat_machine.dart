import 'dart:async';
import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roller_list/roller_list.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'coins.dart';
import 'constants.dart';
import 'package:ironsource/ironsource.dart';
import 'package:ironsource/models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = 'YOUR_DEVICE_ID';

class SlotMachine extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SlotMachineState();
  }
}

class _SlotMachineState extends State<SlotMachine>
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



  static const _ROTATION_DURATION = Duration(milliseconds: 300);
  final List<Widget> slots = _getSlots();
  int first, second, third;
  final leftRoller = new GlobalKey<RollerListState>();
  final rightRoller = new GlobalKey<RollerListState>();
  final centerRoller = new GlobalKey<RollerListState>();
  Timer rotator;
  Random _random = new Random();
  final String appKey = "e873a699";

  bool rewardeVideoAvailable = false,
      offerwallAvailable = false,
      showBanner = false,
      interstitialReady = false;
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
  void initState() {
    first = 0;
    second = 0;
    third = 0;
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    init();
  }

  @override
  void dispose() {
    rotator?.cancel();
    super.dispose();
  }

  Future<bool> registerSpin(Coins coinProv) async {
    var prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("spinAmount")) {
      prefs.setInt("spinAmount", 5);
    }
    var remSpin = prefs.getInt("spinAmount");
    if (remSpin == 0) {
      return false;
    }
    if (remSpin == 1) {
      prefs.setString(
          "nextSpins",
          DateTime.now()
              .add(Duration(days: 1))
              .subtract(
                Duration(
                  hours: DateTime.now().hour,
                  minutes: DateTime.now().minute,
                  seconds: DateTime.now().second,
                ),
              )
              .toIso8601String());
    }
    prefs.setInt("spinAmount", remSpin - 1);
    coinProv.changeSpinCount(prefs.getInt("spinAmount"));
    return true;
  }

  void noSpinDialog(BuildContext context, Coins coinProv) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text(
          "You have 0 free spins left.\n\nCome back tommorrow to collect 5 free spins. \n\nOr buy a new one.",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontSize: 20,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        content: Container(
          height: 120,
          child: Column(
            children: [
              IronSourceBannerAd(keepAlive: true, listener: BannerAdListener()),
              OutlineButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                padding: EdgeInsets.symmetric(vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cancel_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Cancel",
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              OutlineButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    child: AlertDialog(
                      title: Text(
                        "Do you want to trade 40 diamonds for a spin ?",
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontSize: 16,
                        ),
                      ),
                      content: OutlineButton(
                        onPressed: () {
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: IronSourceBannerAd(
                                keepAlive: true, listener: BannerAdListener()),
                          );
                          if (coinProv.getCoins >= 40) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            coinProv.reduceCoins(40);
                            _startRotating();
                            Future.delayed(
                              Duration(milliseconds: 5000),
                              () {
                                _finishRotating();
                              },
                            );
                            Future.delayed(
                              Duration(milliseconds: 6000),
                              () {
                                if (first == second ||
                                    second == third ||
                                    third == first) {
                                  _onBasicAlertPressed(context);
                                } else if (first == second && third == second) {
                                  _onBasicAlertPressed1(context);
                                } else if (first != second && third != second) {
                                  _onBasicAlertPressed3(context);
                                }
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              child: AlertDialog(
                                title: Text(
                                  "You do not have enough diamonds",
                                  style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontSize: 16,
                                  ),
                                ),
                                content: OutlineButton(
                                  onPressed: () {
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: IronSourceBannerAd(
                                          keepAlive: true,
                                          listener: BannerAdListener()),
                                    );
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                      fontFamily: "Quicksand",
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        padding: EdgeInsets.symmetric(vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/diamond.png",
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "40",
                              style: TextStyle(
                                fontFamily: "Quicksand",
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                padding: EdgeInsets.symmetric(vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/diamond.png",
                      width: 30,
                      height: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "40",
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var coinProv = Provider.of<Coins>(context);

    var currentCoins = coinProv.getCoins;
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Stack(
              children: <Widget>[
                Image.asset('assets/images/slot-machine.jpg'),
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.272,
                  top: MediaQuery.of(context).size.height * 0.21,
                  right: MediaQuery.of(context).size.width * 0.27,
                  bottom: MediaQuery.of(context).size.width * 0.4,
                  child: Container(
                    width: 90,
                    height: 91,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 10,
                          child: RollerList(
                            items: slots,
                            enabled: false,
                            key: leftRoller,
                            onSelectedIndexChanged: (value) {
                              setState(() {
                                first = value - 1;
                              });
                            },
                          ),
                        ),
                        VerticalDivider(
                          thickness: 5.0,
                          width: 2,
                          color: Colors.black,
                        ),
                        Expanded(
                          flex: 10,
                          child: RollerList(
                            items: slots,
                            enabled: false,
                            key: centerRoller,
                            onSelectedIndexChanged: (value) {
                              setState(() {
                                second = value - 1;
                              });
                            },
                          ),
                        ),
                        VerticalDivider(
                          thickness: 5.0,
                          width: 2,
                          color: Colors.black,
                        ),
                        Expanded(
                          flex: 10,
                          child: RollerList(
                            enabled: false,
                            items: slots,
                            key: rightRoller,
                            onSelectedIndexChanged: (value) {
                              setState(() {
                                third = value - 1;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.transparent,
          ),
          RaisedButton(
            child: Column(
              children: [
                Text(
                  "Spin",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Quicksand",
                    fontSize: 30,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "${coinProv.getSpinCount.toString()} free spins remaining for today...",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Quicksand",
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            color: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 15,
            ),
            onPressed: () async {
              var res = await registerSpin(coinProv);
              if (res) {
                _startRotating();
                Future.delayed(
                  Duration(milliseconds: 5000),
                  () {
                    _finishRotating();
                  },
                );
                Future.delayed(
                  Duration(milliseconds: 6000),
                  () {
                    if (first == second || second == third || third == first) {
                      _onBasicAlertPressed(context);
                    } else if (first == second && third == second) {
                      _onBasicAlertPressed1(context);
                    } else if (first != second && third != second) {
                      _onBasicAlertPressed3(context);
                    }
                  },
                );
              } else {
                noSpinDialog(context, coinProv);
              }
            },
          ),
        ],
      ),
    );
  }

  double _randomeTime() => (Random().nextDouble());
  void _startRotating() {
    rotator = Timer.periodic(_ROTATION_DURATION, _rotateRoller);
  }

  void _rotateRoller(_) {
    final leftRotationTarget = _random.nextInt(3 * slots.length);
    final rightRotationTarget = _random.nextInt(3 * slots.length);
    final centerRotationTarget = _random.nextInt(3 * slots.length);

    leftRoller.currentState?.smoothScrollToIndex(leftRotationTarget,
        duration: _ROTATION_DURATION, curve: Curves.linear);
    centerRoller.currentState?.smoothScrollToIndex(centerRotationTarget,
        duration: _ROTATION_DURATION, curve: Curves.linear);
    rightRoller.currentState?.smoothScrollToIndex(rightRotationTarget,
        duration: _ROTATION_DURATION, curve: Curves.linear);
  }

  void _finishRotating() {
    rotator?.cancel();
  }

  _onBasicAlertPressed(context) {
    Alert(
      context: context,
      title: "Congratulation",
      desc: "You won 50",
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
      content: Align(
        alignment: Alignment.bottomCenter,
        child:
            IronSourceBannerAd(keepAlive: true, listener: BannerAdListener()),
      ),
      buttons: [
        DialogButton(
          color: Colors.purple,
          radius: BorderRadius.all(
            Radius.circular(10),
          ),
          child: Text(
            "Collect",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            var coinProv = Provider.of<Coins>(context, listen: false);
            coinProv.addCoins(50);
            Navigator.of(context).pop();
          },
        ),
      ],
    ).show();
  }

  _onBasicAlertPressed3(context) {
    Alert(
      context: context,
      title: "Bad Luck",
      desc: "sorry! better luck next time",
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
      content: Align(
        alignment: Alignment.bottomCenter,
        child:
            IronSourceBannerAd(keepAlive: true, listener: BannerAdListener()),
      ),
      buttons: [
        DialogButton(
          color: Colors.purple,
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

  _onBasicAlertPressed1(context) {
    Alert(
      context: context,
      title: "Congratulation",
      desc: "You won 70",
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
      content: Align(
        alignment: Alignment.bottomCenter,
        child:
            IronSourceBannerAd(keepAlive: true, listener: BannerAdListener()),
      ),
      buttons: [
        DialogButton(
          color: Colors.purple,
          radius: BorderRadius.all(
            Radius.circular(10),
          ),
          child: Text(
            "Collect",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: "Quicksand",
                fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            var coinProv = Provider.of<Coins>(context, listen: false);
            coinProv.addCoins(70);
            Navigator.of(context).pop();
          },
        ),
      ],
    ).show();
  }

  static List<Widget> _getSlots() {
    List<Widget> result = new List();
    for (int i = 0; i <= 9; i++) {
      result.add(Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(0)),
            surfaceIntensity: 1.0,
            color: Colors.white),
        child: Image.asset(
          "assets/images/$i.png",
          width: double.infinity,
          height: double.infinity,
        ),
      ));
    }
    return result;
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
