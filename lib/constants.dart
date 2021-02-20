import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const kdeepBlue = Color.fromARGB(255, 21, 40, 80);
const klightDeepBlue = Color.fromARGB(255, 39, 73, 110);
const klightCyan = Color.fromARGB(255, 104, 204, 240);
var banneridAdmob = "ca-app-pub-6610077604910288/3648971322";
var interstitialidAdmob = "ca-app-pub-6610077604910288/4962052990";
var rewardidAdmob = "ca-app-pub-6610077604910288/8326582934";
var nativeidAdmob = "ca-app-pub-6610077604910288/8709726315";

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
