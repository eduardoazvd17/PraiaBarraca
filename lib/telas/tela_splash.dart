import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:praiabarraca/telas/tela_estabelecimentos.dart';
import 'package:praiabarraca/telas/tela_login.dart';

class TelaSplash extends StatefulWidget {
  @override
  _TelaSplashState createState() => _TelaSplashState();
}

class _TelaSplashState extends State<TelaSplash> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      Future.delayed(Duration(seconds: 3), () {
        if (user == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => TelaLogin(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => TelaEstabelecimentos(user.uid),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var altura = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          height: altura * 0.25,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
