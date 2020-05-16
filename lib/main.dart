import 'package:flutter/material.dart';
import 'package:praiabarraca/telas/tela_splash.dart';

void main() => runApp(PraiaBarracaApp());

class PraiaBarracaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Praia Barraca',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: TelaSplash(),
    );
  }
}
