import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinning_wheel/flutter_spinning_wheel.dart';
import 'package:jgamer/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import './displayScore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'coins.dart';
import 'package:provider/provider.dart';
import 'package:ironsource/ironsource.dart';
import 'package:ironsource/models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_admob/firebase_admob.dart';


const String testDevice = 'YOUR_DEVICE_ID';

class Roulette extends StatefulWidget {
  @override
  _RouletteState createState() => _RouletteState();
}

class _RouletteState extends State<Roulette> with IronSourceListener , WidgetsBindingObserver{
  final StreamController _dividerController = StreamController<int>();
  var isSpinActive = true;
  var currentScore;

  final _wheelNotifier = StreamController<double>();
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
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }

  NativeAd createNativeAd() {
    return NativeAd(
      adUnitId: NativeAd.testAdUnitId,
      factoryId: 'adFactoryExample',
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("$NativeAd event $event");
      },
    );
  }

  dispose() {
    _bannerAd.dispose();
    _nativeAd?.dispose();
    _interstitialAd?.dispose();
    _dividerController.close();
    _wheelNotifier.close();
  }

  final String appKey = "e873a699";

  bool rewardeVideoAvailable = false,
      offerwallAvailable = false,
      showBanner = false,
      interstitialReady = false;
  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    Future.delayed(
        Duration(milliseconds: 3000),
            () {
          _bannerAd = createBannerAd()..load()..show();

        });
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch(state){

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
    setState(() {
      IronSource.loadInterstitial();
    });

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

  void refreshSpins() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("nextSpins")) {
      if (DateTime.parse(prefs.getString("nextSpins"))
          .isBefore(DateTime.now())) {
        prefs.remove("nextSpins");
        prefs.remove("spinAmount");
      }
    }
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
              IronSourceBannerAd(
                    keepAlive: true, listener: BannerAdListener()),
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
                        "Do you want to trade 70 diamonds for a spin ?",
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontSize: 16,
                        ),
                      ),
                      content: OutlineButton(
                        onPressed: () {
                          if (coinProv.getCoins >= 70) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            coinProv.reduceCoins(70);
                            Future.delayed(
                              Duration(milliseconds: 5000),
                              () {
                                _onAlertButtonPressed(context, currentScore);
                                setState(() {
                                  isSpinActive = true;
                                });
                              },
                            );
                            _wheelNotifier.sink.add(_generateRandomVelocity());
                            setState(
                              () {
                                isSpinActive = false;
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
                              "70",
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
                      "70",
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
    refreshSpins();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.8,
                    child: SpinningWheel(
                      Image.asset('Image/roulette-8-300.jpeg'),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.width * 0.8,
                      initialSpinAngle: _generateRandomAngle(),
                      spinResistance: 0.6,
                      canInteractWhileSpinning: false,
                      dividers: 8,
                      onUpdate: _dividerController.add,
                      onEnd: _dividerController.add,
                      secondaryImage: Image.asset('Image/cpointer.png'),
                      secondaryImageHeight: 50,
                      secondaryImageWidth: 50,
                      shouldStartOrStop: _wheelNotifier.stream,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.8,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: _dividerController.stream,
              builder: (context, snapshot) {
                currentScore = snapshot.data;
                return Container();
              },
            ),
            SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.2,
              child: RaisedButton(
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
                color: klightDeepBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                ),
                onPressed: isSpinActive
                    ? () async {
                        var res = await registerSpin(coinProv);
                        if (res) {
                          Future.delayed(
                            Duration(milliseconds: 5000),
                            () {
                              _onAlertButtonPressed(context, currentScore);
                              setState(() {
                                isSpinActive = true;
                              });
                            },
                          );
                          _wheelNotifier.sink.add(_generateRandomVelocity());
                          setState(() {
                            isSpinActive = false;
                          });
                        } else {
                          noSpinDialog(context, coinProv);
                        }
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
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

  double _generateRandomVelocity() => (Random().nextDouble() * 10000) + 10000;

  double _generateRandomAngle() => Random().nextDouble() * pi * 2;


class RouletteScore extends StatelessWidget {
  final int selected;
  var number;

  final Map<int, String> labels = {
    1: '100',
    2: '0',
    3: '5',
    4: '20',
    5: '0',
    6: '10',
    7: '0',
    8: '30',
  };

  RouletteScore(this.selected);

  @override
  Widget build(BuildContext context) {
    number = labels[selected];
    return Text('${labels[selected]}', style: TextStyle(fontSize: 24.0));
  }
}

_onAlertButtonPressed(context, currentScore) {
  final Map<int, String> labels = {
    1: '100',
    2: '0',
    3: '5',
    4: '20',
    5: '0',
    6: '10',
    7: '0',
    8: '30',
  };
  Alert(
    context: context,
    type: AlertType.success,
    title: int.parse(labels[currentScore]) == 0
        ? "Better Luck Next Time"
        : "Congratulations",
    desc: 'you won ${labels[currentScore]} diamonds',
    style: AlertStyle(
      titleStyle: TextStyle(
        fontFamily: "Quicksand",
        fontSize: 25,
      ),
      descStyle: TextStyle(
        fontFamily: "Quicksand",
        fontSize: 20,
      ),
    ),
    onWillPopActive: true,
      content: Align(
        alignment: Alignment.bottomCenter,
        child: IronSourceBannerAd(
            keepAlive: true, listener: BannerAdListener()),
      ) ,
    buttons: [
      DialogButton(
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
          coinProv.addCoins(int.parse(labels[currentScore]));
          Navigator.of(context).pop();
        },
      ),
    ],
  ).show();
}
