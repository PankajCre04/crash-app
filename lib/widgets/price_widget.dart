import 'package:flutter/material.dart';
import 'package:food_app/services/utils.dart';
import 'package:food_app/widgets/text_widget.dart';

class PriceWidget extends StatelessWidget {
  PriceWidget({
    required this.salePrice,
    required this.price,
    required this.textPrice,
    required this.onSale,
  });
  final double salePrice, price;
  final String textPrice;
  final bool onSale;
  @override
  Widget build(BuildContext context) {
    final color = Utils(context: context).color;
    double userPrice = onSale ? salePrice : price;
    return FittedBox(
      child: Row(
        children: [
          TextWidget(
            text: "\$${(userPrice * int.parse(textPrice)).toStringAsFixed(2)}",
            color: Colors.green,
            textSize: 17,
          ),
          const SizedBox(width: 4),
          Visibility(
            visible: onSale ? true : false,
            child: Text(
              "\$${(price * int.parse(textPrice)).toStringAsFixed(2)}",
              style: TextStyle(fontSize: 14, color: color, decoration: TextDecoration.lineThrough),
            ),
          )
        ],
      ),
    );
  }
}
