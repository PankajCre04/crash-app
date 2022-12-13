import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:food_app/provider/viewed_provider.dart';
import 'package:food_app/screens/viewed_recently/viewed_widget.dart';
import 'package:food_app/services/utils.dart';
import 'package:food_app/widgets/empty_screen.dart';
import 'package:provider/provider.dart';

import '../../services/global_methods.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/text_widget.dart';

class ViewedRecentlyScreen extends StatefulWidget {
  static const routeName = '/ViewedRecentlyScreen';
  const ViewedRecentlyScreen({Key? key}) : super(key: key);

  @override
  State<ViewedRecentlyScreen> createState() => _ViewedRecentlyScreenState();
}

class _ViewedRecentlyScreenState extends State<ViewedRecentlyScreen> {
  @override
  Widget build(BuildContext context) {
    final color = Utils(context: context).color;
    bool _isEmpty = true;
    final viewedProvider = Provider.of<ViewedProductProvider>(context);
    final viewedProdtItemsList = viewedProvider.viewedProdtItemsList.values.toList().reversed.toList();
    return viewedProdtItemsList.isEmpty
        ? const EmptyScreen(
            imagePath: 'assets/images/history.png',
            title: 'Your history is empty',
            subtitle: 'No products has been viewed yet!',
            buttonText: 'Shop Now',
          )
        : Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    GlobalMethods.warningDialog(
                      title: 'Empty your history?',
                      subTitle: 'Are you sure?',
                      func: () {},
                      context: context,
                    );
                  },
                  icon: Icon(
                    IconlyBroken.delete,
                    color: color,
                  ),
                )
              ],
              leading: const BackWidget(),
              automaticallyImplyLeading: false,
              elevation: 0,
              centerTitle: true,
              title: TextWidget(
                text: 'History',
                color: color,
                textSize: 24.0,
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
            ),
            body: ListView.builder(
                itemCount: viewedProdtItemsList.length,
                itemBuilder: (ctx, index) {
                  return Container(
                    color: Theme.of(context).cardColor.withOpacity(0.5),
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                    child: ChangeNotifierProvider.value(
                      value: viewedProdtItemsList[index],
                      child: const ViewedRecentlyWidget(),
                    ),
                  );
                }),
          );
  }
}
