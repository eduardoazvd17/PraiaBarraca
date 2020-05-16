import 'package:flutter/material.dart';

class ItemMenu extends StatelessWidget {
  final Icon icone;
  final String titulo;
  final Function onTap;
  ItemMenu({@required this.icone, @required this.titulo, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FittedBox(
                child: Text(
                  titulo,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: 60,
                child: FittedBox(
                  child: icone,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
