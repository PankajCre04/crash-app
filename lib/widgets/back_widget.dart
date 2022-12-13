import 'package:flutter/material.dart';
import 'package:food_app/services/utils.dart';

class BackWidget extends StatelessWidget {
  const BackWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Utils(context: context).color;
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Icon(
        Icons.arrow_back_ios_rounded,
        color: color,
      ),
    );
    ;
  }
}
