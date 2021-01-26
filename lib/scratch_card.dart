import 'dart:math';
import 'package:flutter/material.dart';
import 'package:jgamer/coins.dart';
import 'package:jgamer/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scratcher/scratcher.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ironsource/ironsource.dart';
import 'package:ironsource/models.dart';

class ScratchCard extends StatefulWidget {
  @override
  _ScratchCardState createState() => _ScratchCardState();
}

class _ScratchCardState extends State<ScratchCard>
    with IronSourceListener, WidgetsBindingObserver {
  double _opacity = 0.0;
  var no;
  _ScratchCardState({this.no});
  final String appKey = "e873a699";

  bool rewardeVideoAvailable = false,
      offerwallAvailable = false,
      showBanner = true,
      interstitialReady = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    init();
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

  var list = [
    0,
    10,
    5,
    100,
    10,
    20,
    10,
    0,
    30,
    20,
  ];

  Future<void> scratchCardDialog(BuildContext context) async {
    no = getRandomElement(list);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          title: Align(
            alignment: Alignment.center,
            child: Text(
              'You\'ve won a scratch card',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          content: StatefulBuilder(builder: (context, StateSetter setState) {
            return Scratcher(
              accuracy: ScratchAccuracy.low,
              threshold: 40,
              brushSize: 25,
              onThreshold: () {
                setState(() {
                  _onAlertButtonPressed(context);
                });
              },
              image: Image.asset('Image/scratchcard.jpg'),
              child: Container(
                height: 200,
                width: 300,
                alignment: Alignment.center,
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
                      no.toString(),
                      style: TextStyle(
                        color: Colors.blue,
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold,
                        fontSize: 45,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  void noScractchCardDialog(BuildContext context, Coins coinProv) {
    // var coinProv = Provider.of<Coins>(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "You have 0 free coupons left.\n\nCome back tommorrow to collect 5 free coupons. \n\nOr buy a new one.",
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
          actionsPadding: EdgeInsets.symmetric(horizontal: 30),
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
                          "Do you want to trade 60 diamonds for a scratch coupon ?",
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontSize: 16,
                          ),
                        ),
                        content: OutlineButton(
                          onPressed: () async {
                            if (coinProv.getCoins >= 60) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              coinProv.reduceCoins(60);
                              scratchCardDialog(context);
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
                                "60",
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
                        "60",
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
        );
      },
    );
  }

  Future<bool> registerScratch(Coins coinProv) async {
    var prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("scratchAmount")) {
      prefs.setInt("scratchAmount", 5);
    }
    var remScr = prefs.getInt("scratchAmount");
    if (remScr == 0) {
      return false;
    }
    if (remScr == 1) {
      prefs.setString(
          "nextCoupons",
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
    prefs.setInt("scratchAmount", remScr - 1);
    coinProv.changeCouponCount(prefs.getInt("scratchAmount"));
    return true;
  }

  void refreshCoupons() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("nextCoupons")) {
      if (DateTime.parse(prefs.getString("nextCoupons"))
          .isBefore(DateTime.now())) {
        prefs.remove("nextCoupons");
        prefs.remove("scratchAmount");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    refreshCoupons();
    var coinProv = Provider.of<Coins>(context);
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                "assets/1.jpeg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          FlatButton(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
            child: Column(
              children: [
                Text(
                  "Get A ScratchCard",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Quicksand",
                    fontSize: 25,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "${coinProv.getCouponCount.toString()} free coupons remaining for today...",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Quicksand",
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            onPressed: () async {
              IronSource.loadInterstitial();
              showInterstitial();
              var res = await registerScratch(coinProv);
              if (res) {
                scratchCardDialog(context);
              } else {
                noScractchCardDialog(context, coinProv);
              }
            },
          ),
        ],
      ),
    );
  }

  getRandomElement(List list) {
    final random = new Random();
    var i = random.nextInt(list.length);
    return list[i];
  }

  _onAlertButtonPressed(context) {
    Alert(
        context: context,
        onWillPopActive: true,
        type: AlertType.success,
        title: "You Won",
        desc: no.toString(),
        style: AlertStyle(
          titleStyle: TextStyle(
            fontFamily: "Quicksand",
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          descStyle: TextStyle(
            fontFamily: "Quicksand",
            fontSize: 20,
          ),
        ),
        buttons: [
          DialogButton(
              color: klightDeepBlue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Reedem",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    no.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold,
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
              onPressed: () {
                var coins = Provider.of<Coins>(context, listen: false);
                coins.addCoins(no);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }),
        ],
        content: Align(
          alignment: Alignment.bottomCenter,
          child:
              IronSourceBannerAd(keepAlive: true, listener: BannerAdListener()),
        )).show();
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
