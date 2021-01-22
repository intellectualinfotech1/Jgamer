import 'package:flutter/material.dart';
import 'package:jgamer/QuizScreen.dart';
import 'package:jgamer/home_page.dart';
import 'package:jgamer/memorygame.dart';
import 'package:jgamer/playquiz.dart';
import 'package:jgamer/scratch_card.dart';
import 'constants.dart';
import 'ads.dart';
import 'tasks.dart';

class FirstPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              child: ScratchCard(),
            ),
            Container(
              height: 150,
              // child: Expanded(
              //   child: AdsButton(),
              // ),
              child: AdsButton(),
            ),
            Container(
              height: 150,
              child: TasksButton(),
            ),
            Container(
              height: 150,
              child: playquiz(),
            ),
          ],
        ),
      ),
    );
  }
}
