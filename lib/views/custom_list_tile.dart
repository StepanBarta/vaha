import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCustomListTile extends StatelessWidget {
  final String text1;
  final String text2;
  final String text3;
  final VoidCallback onTap;
  final bool isSelected;

  MyCustomListTile({required this.text1, required this.text2, required this.text3, required this.onTap, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: isSelected ? Colors.blue : null, // Přidána podmínka pro změnu barvy pozadí
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              text1,
              style: TextStyle(
                fontSize: 40,
              ),
            ),
            Text(
              text2,
              style: TextStyle(
                fontSize: 40,
              ),
            ),
            Text(
              text3,
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}