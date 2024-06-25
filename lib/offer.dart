import 'package:flutter/material.dart';

class Offer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OfferState();
  }
}

class OfferState extends State<Offer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Offer"),
      ),
      body: Center(
        child: Text("This is Offer."),
      ),
    );
  }
}
