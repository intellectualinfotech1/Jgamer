import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const kdeepBlue = Color.fromARGB(255, 21, 40, 80);
const klightDeepBlue = Color.fromARGB(255, 39, 73, 110);
const klightCyan = Color.fromARGB(255, 104, 204, 240);
var banneridAdmob = "ca-app-pub-3894791004337850/2098591679";
var interstitialidAdmob = "ca-app-pub-3894791004337850/9785510009";
var rewardidAdmob = "ca-app-pub-3894791004337850/8743891079";
var nativeidAdmob = "ca-app-pub-3894791004337850/7159346662";

// const kdeepBlue = Color.fromARGB(255, 170, 17, 85);
// const klightDeepBlue = Color.fromARGB(255, 136, 0, 68);
// const klightCyan = Color.fromARGB(255, 193, 14, 73);
// const klightCyan = Color.fromARGB(255, 220, 3, 110);

changeAdId(String newBId, String newIId, String newRId, String newNId) {
  banneridAdmob = newBId;
  interstitialidAdmob = newIId;
  rewardidAdmob = newRId;
  nativeidAdmob = newNId;
}
