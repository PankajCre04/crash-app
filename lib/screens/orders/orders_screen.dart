import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:food_app/widgets/empty_screen.dart';
import 'package:provider/provider.dart';

import '../../provider/orders_provider.dart';
import '../../services/utils.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/text_widget.dart';
import 'order_widget.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context: context).color;
    final orderProvider = Provider.of<OrdersProvider>(context);
    final orderList = orderProvider.getOrders;
    return FutureBuilder(
      future: orderProvider.fetchOrders(),
      builder: (context, snapshot) {
        return orderList.isEmpty
            ? const EmptyScreen(
                imagePath: 'assets/images/cart.png',
                title: 'You didnt place any order yet',
                subtitle: 'order something and make me happy :)',
                buttonText: 'Shop Now',
              )
            : Scaffold(
                appBar: AppBar(
                  leading: const BackWidget(),
                  elevation: 0,
                  centerTitle: false,
                  title: TextWidget(
                    text: 'Your orders (${orderList.length})',
                    color: color,
                    textSize: 21.0,
                  ),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
                ),
                body: ListView.separated(
                  itemCount: orderList.length,
                  itemBuilder: (ctx, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                      child: ChangeNotifierProvider.value(
                        value: orderList[index],
                        child: const OrderWidget(),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: color,
                      thickness: 1,
                    );
                  },
                ));
      },
    );
  }
}
