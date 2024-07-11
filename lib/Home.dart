import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: const Text(
              "Selamat datang di Adopsian. Ada beberapa hal yang dapat anda lakukan dalam aplikasi ini, yaitu:\n\n1. Anda dapat melihat list hewan yang dapat diadopsi pada Menu 'Browse Pet', kemudian anda dapat melakukan 'Propose' untuk mengadopsi hewan yang anda inginkan.\n2. Anda dapat mengajukan hewan anda yang terbuka untuk diadopsi pada Menu 'Offer Pet'.\n3. Anda dapat melihat riwayat hewan-hewan yang telah anda 'Propose'.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: BorderSide.strokeAlignCenter,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
