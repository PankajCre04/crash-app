import 'package:flutter/material.dart';
import 'package:food_app/provider/dark_theme_provider.dart';
import 'package:food_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../inner_screens/cat_screen.dart';

class CategoriesWidget extends StatelessWidget {
  CategoriesWidget({Key? key, required this.catText, required this.imagePath, required this.ccolor}) : super(key: key);
  String imagePath, catText;
  Color ccolor;
  @override
  Widget build(BuildContext context) {
    final _themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = _themeState.getDarkTheme ? Colors.white : Colors.black;
    final _size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(CategoryScreen.routeName, arguments: catText);
      },
      child: Container(
        decoration: BoxDecoration(
          color: ccolor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: ccolor.withOpacity(0.7), width: 0.5),
        ),
        child: Column(
          children: [
            Container(
              height: _size.height * 0.18,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            TextWidget(text: catText, color: color, textSize: 17),
          ],
        ),
      ),
    );
  }
}
