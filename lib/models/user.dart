import 'package:flutter/material.dart';

class User {
  final String userId;
  final String userEmail;
  final String userPassword;
  final int coins;

  User(
      {@required this.userId,
      @required this.userEmail,
      @required this.userPassword,
      this.coins = 0});
}
