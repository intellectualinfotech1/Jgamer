import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jgamer/coins.dart';
import 'package:jgamer/home_page.dart';
import 'package:jgamer/memorygame.dart';
import 'package:jgamer/sloat_machine.dart';
import 'Spinner_wheel.dart';
import 'constants.dart';
import 'package:ironsource/ironsource.dart';
import 'package:ironsource/models.dart';
import 'package:http/http.dart' as http;


class GamesFrontPage extends StatefulWidget {
  @override
  _GamesFrontPageState createState() => _GamesFrontPageState();
}

class _GamesFrontPageState extends State<GamesFrontPage> with IronSourceListener , WidgetsBindingObserver{

  var games = [
    {
      "name": "Tic Tac Toe",
      "game": HomePage(),
      "thumb": "Image/itctactoeimg.jpg"
    },
    {
      "name": "Memory Game",
      "game": Memory(),
      "thumb": "Image/memorygameimg.jpg"
    },
    {
      "name": "Spin & Earn",
      "game":  Roulette(),
      "thumb": "Image/roulette-8-300.png"
    },
    {
      "name": "Slot Machine",
      "game": SlotMachine(),
      "thumb": "assets/images/slot-machine.jpg"
    },
  ];
  final String appKey = "e873a699";

  bool rewardeVideoAvailable = false,
      offerwallAvailable = false,
      showBanner = false,
      interstitialReady = true;
  @override
  void initState() {
    loadInterstitial();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadInterstitial();
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
    loadInterstitial();
    var userId = await IronSource.getAdvertiserId();
    await IronSource.validateIntegration();
    await IronSource.setUserId(userId);
    await IronSource.initialize(appKey: appKey, listener: this);
    rewardeVideoAvailable = await IronSource.isRewardedVideoAvailable();
    offerwallAvailable = await IronSource.isOfferwallAvailable();
    setState(() {loadInterstitial();});
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
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 8,
                    ),
                    child: GestureDetector(
                      onTap: () {
                       showInterstitial();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => games[index]["game"],
                          ),
                        );

                      },
                      child: Container(
                        height: 160,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius:
                              BorderRadius.all(Radius.circular(15)),
                              child: Image.asset(
                                games[index]["thumb"],
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                color: kdeepBlue,
                                child: Text(
                                  games[index]["name"],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Quicksand",
                                    fontSize: 35,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: games.length,
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
