import 'package:flutter/material.dart';
import 'package:food_app/inner_screens/feeds_screen.dart';
import 'package:food_app/services/global_methods.dart';
import 'package:food_app/services/utils.dart';
import 'package:food_app/widgets/text_widget.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.buttonText,
  }) : super(key: key);
  final String imagePath, title, subtitle, buttonText;
  @override
  Widget build(BuildContext context) {
    final color = Utils(context: context).color;
    final size = Utils(context: context).getScreenSize;
    final themeState = Utils(context: context).getTheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.04),
                Image.asset(
                  imagePath.toString(),
                  width: double.infinity,
                  height: size.height * 0.4,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Whoops!",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                TextWidget(text: title, color: Colors.cyan, textSize: 20),
                const SizedBox(height: 5),
                FittedBox(
                  child: TextWidget(text: subtitle, color: Colors.cyan, textSize: 18),
                ),
                SizedBox(height: size.height * 0.12),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                      ),
                      primary: Theme.of(context).colorScheme.secondary,
                      //onPrimary: color,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    ),
                    onPressed: () {
                      GlobalMethods.navigateTo(context: context, routeName: FeedScreen.routeName);
                    },
                    child: TextWidget(
                      text: buttonText,
                      color: Colors.grey.shade800,
                      textSize: 20,
                      isTitle: true,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
