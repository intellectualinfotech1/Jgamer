// RaisedButton(
// child: Column(
// children: [
// Text(
// "Spin",
// style: TextStyle(
// color: Colors.white,
// fontWeight: FontWeight.bold,
// fontFamily: "Quicksand",
// fontSize: 30,
// ),
// ),
// SizedBox(
// height: 8,
// ),
// Text(
// "${coinProv.getSpinCount.toString()} free spins remaining for today...",
// style: TextStyle(
// color: Colors.white,
// fontFamily: "Quicksand",
// fontSize: 20,
// ),
// textAlign: TextAlign.center,
// ),
// ],
// ),
// color: klightDeepBlue,
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.all(
// Radius.circular(25),
// ),
// ),
// padding: EdgeInsets.symmetric(
// vertical: 15,
// ),
// onPressed: isSpinActive
// ? () async {
// var res = await registerSpin(coinProv);
// if (res) {
// Future.delayed(
// Duration(milliseconds: 5000),
// () {
// _onAlertButtonPressed(context, currentScore);
// setState(() {
// isSpinActive = true;
// });
// },
// );
// _wheelNotifier.sink.add(_generateRandomVelocity());
// setState(() {
// isSpinActive = false;
// });
// } else {
// noSpinDialog(context, coinProv);
// }
// }
// : null,
// ),

// DialogButton(
// color: Colors.purple,
// radius: BorderRadius.all(
// Radius.circular(10),
// ),
// onPressed: () {
// final assetsAudioPlayer = AssetsAudioPlayer();
// _startRotating();
// Future.delayed(
// Duration(milliseconds: 5000),
// () {
// _finishRotating();
// },
// );
// Future.delayed(
// Duration(milliseconds: 6000),
// () {
// if (first == second || second == third || third == first) {
// _onBasicAlertPressed(context);
// } else if (first == second && third == second) {
// _onBasicAlertPressed1(context);
// }
// },
// );
// },
// child: Text(
// "Start",
// style: TextStyle(
// color: Colors.white,
// fontSize: 20,
// fontFamily: "Quicksand",
// fontWeight: FontWeight.bold),
// ),
// ),
