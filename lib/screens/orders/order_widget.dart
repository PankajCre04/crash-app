import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:food_app/models/order_model.dart';
import 'package:food_app/provider/product_provider.dart';
import 'package:provider/provider.dart';
import '../../inner_screens/product_details.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/text_widget.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({Key? key}) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  late String orderDateToShow;
  @override
  void didChangeDependencies() {
    final orderModel = Provider.of<OrderModel>(context);
    var orderDate = orderModel.orderDate.toDate();
    orderDateToShow = "${orderDate.day}/${orderDate.month}/${orderDate.year}";
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context: context).color;
    Size size = Utils(context: context).getScreenSize;
    final orderModel = Provider.of<OrderModel>(context);
    final productProvider = Provider.of<ProductsProvider>(context, listen: false);
    final getCurrentProduct = productProvider.findById(orderModel.productId);
    return ListTile(
      subtitle: Text('Paid: \$${double.parse(orderModel.price).toStringAsFixed(2)}'),
      onTap: () {
        GlobalMethods.navigateTo(context: context, routeName: ProductDetails.routeName);
      },
      leading: FancyShimmerImage(
        width: size.width * 0.2,
        imageUrl: orderModel.imageUrl,
        boxFit: BoxFit.fill,
      ),
      title: TextWidget(text: '${getCurrentProduct.title} x ${orderModel.quantity}', color: color, textSize: 18),
      trailing: TextWidget(text: orderDateToShow, color: color, textSize: 16),
    );
  }
}
