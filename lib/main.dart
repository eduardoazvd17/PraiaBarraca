import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:praiabarraca/telas/tela_splash.dart';

void main() => runApp(PraiaBarracaApp());

class PraiaBarracaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [const Locale('pt', 'BR')],
        debugShowCheckedModeBanner: false,
        title: 'Praia Barraca',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: TelaSplash(),
      ),
    );
  }
}
