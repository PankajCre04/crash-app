import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_app/consts/theme_dart.dart';
import 'package:food_app/fetch_screen.dart';
import 'package:food_app/inner_screens/on_sale_screen.dart';
import 'package:food_app/provider/cart_provider.dart';
import 'package:food_app/provider/dark_theme_provider.dart';
import 'package:food_app/provider/orders_provider.dart';
import 'package:food_app/provider/product_provider.dart';
import 'package:food_app/provider/viewed_provider.dart';
import 'package:food_app/provider/wishlist_provider.dart';
import 'package:food_app/screens/auth/forget_pass.dart';
import 'package:food_app/screens/auth/login_screen.dart';
import 'package:food_app/screens/auth/register.dart';
import 'package:food_app/screens/bottom_bar_screen.dart';
import 'package:food_app/screens/orders/orders_screen.dart';
import 'package:food_app/screens/viewed_recently/viewed_recently_screen.dart';
import 'package:food_app/screens/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';
import 'inner_screens/cat_screen.dart';
import 'inner_screens/feeds_screen.dart';
import 'inner_screens/product_details.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider _darkThemeProvider = DarkThemeProvider();
  void getCurrentAppTheme() async {
    _darkThemeProvider.setDarkTheme = await _darkThemeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Text("An Error Occured"),
                ),
              ),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => DarkThemeProvider()),
              ChangeNotifierProvider(create: (_) => ProductsProvider()),
              ChangeNotifierProvider(create: (_) => CartProvider()),
              ChangeNotifierProvider(create: (_) => WishlistProvider()),
              ChangeNotifierProvider(create: (_) => ViewedProductProvider()),
              ChangeNotifierProvider(create: (_) => OrdersProvider())
            ],
            child: Consumer<DarkThemeProvider>(builder: (context, provider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Food App',
                theme: Styles.themeData(provider.getDarkTheme, context),
                home: const FetchScreen(),
                routes: {
                  OnSaleScreen.routeName: (context) => const OnSaleScreen(),
                  FeedScreen.routeName: (context) => const FeedScreen(),
                  ProductDetails.routeName: (context) => ProductDetails(),
                  WishlistScreen.routeName: (context) => const WishlistScreen(),
                  OrdersScreen.routeName: (context) => const OrdersScreen(),
                  ViewedRecentlyScreen.routeName: (context) => const ViewedRecentlyScreen(),
                  LoginScreen.routeName: (context) => const LoginScreen(),
                  RegisterScreen.routeName: (context) => const RegisterScreen(),
                  ForgetPasswordScreen.routeName: (context) => const ForgetPasswordScreen(),
                  CategoryScreen.routeName: (context) => const CategoryScreen()
                },
              );
            }),
          );
        });
  }
}
