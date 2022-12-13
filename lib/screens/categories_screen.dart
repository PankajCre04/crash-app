import 'package:flutter/material.dart';
import 'package:food_app/services/utils.dart';
import 'package:food_app/widgets/categories_widget.dart';
import 'package:food_app/widgets/text_widget.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({Key? key}) : super(key: key);
  List<Color> gridColors = [
    const Color(0xff53B175),
    const Color(0xffF8A44C),
    const Color(0xffF7A593),
    const Color(0xffD3B0E0),
    const Color(0xffFDE598),
    const Color(0xffB7DFF5),
  ];
  List<Map<String, dynamic>> catInfo = [
    {
      'imgPath': 'assets/images/cat/fruits.png',
      'catText': 'Fruits',
    },
    {
      'imgPath': 'assets/images/cat/veg.png',
      'catText': 'Vegetables',
    },
    {
      'imgPath': 'assets/images/cat/Spinach.png',
      'catText': 'Herbs',
    },
    {
      'imgPath': 'assets/images/cat/nuts.png',
      'catText': 'Nuts',
    },
    {
      'imgPath': 'assets/images/cat/spices.png',
      'catText': 'Spices',
    },
    {
      'imgPath': 'assets/images/cat/grains.png',
      'catText': 'Grains',
    },
  ];
  @override
  Widget build(BuildContext context) {
    final utils = Utils(context: context);
    Color color = utils.color;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(text: 'Category', color: color, textSize: 20, isTitle: true),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 240 / 250,
          crossAxisSpacing: 7,
          mainAxisSpacing: 7,
          children: List.generate(catInfo.length, (index) {
            return CategoriesWidget(
              catText: catInfo[index]['catText'],
              imagePath: catInfo[index]['imgPath'],
              ccolor: gridColors[index],
            );
          }),
        ),
      ),
    );
  }
}
