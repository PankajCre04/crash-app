import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:food_app/provider/cart_provider.dart';
import 'package:food_app/provider/dark_theme_provider.dart';
import 'package:food_app/screens/cart/cart_screen.dart';
import 'package:food_app/screens/categories_screen.dart';
import 'package:food_app/screens/home_screen.dart';
import 'package:food_app/screens/user_screen.dart';
import 'package:provider/provider.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;

  List _pages = [
    const HomeScreen(),
    CategoriesScreen(),
    const CartScreen(),
    UserScreen(),
  ];

  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _themeState = Provider.of<DarkThemeProvider>(context);
    // final cartProvider = Provider.of<CartProvider>(context);
    bool _isDark = _themeState.getDarkTheme;
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _isDark ? Theme.of(context).cardColor : Colors.white,
        currentIndex: _selectedIndex,
        onTap: _selectedPage,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: _isDark ? Colors.white10 : Colors.black12,
        selectedItemColor: _isDark ? Colors.lightBlue.shade200 : Colors.black87,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(_selectedIndex == 0 ? IconlyBold.home : IconlyLight.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(_selectedIndex == 1 ? IconlyBold.category : IconlyLight.category), label: "Category"),
          BottomNavigationBarItem(
              icon: Consumer<CartProvider>(
                builder: (_, myCart, ch) {
                  return Badge(
                    toAnimate: true,
                    badgeColor: Colors.blue.withOpacity(0.6),
                    badgeContent: Text(
                      myCart.getCartItems.length.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    child: Icon(_selectedIndex == 2 ? IconlyBold.buy : IconlyLight.buy),
                  );
                },
              ),
              label: "Cart"),
          BottomNavigationBarItem(icon: Icon(_selectedIndex == 3 ? IconlyBold.user2 : IconlyLight.user2), label: "User"),
        ],
      ),
    );
  }
}
