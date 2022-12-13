import 'package:flutter/material.dart';
import 'package:food_app/services/utils.dart';

class EmptyProductWidget extends StatelessWidget {
  const EmptyProductWidget({Key? key, required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    Color color = Utils(context: context).color;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset('assets/images/box.png'),
          ),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          ),
          // const Text(
          //   "Stay tuned",
          //   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          // ),
        ],
      ),
    );
  }
}
