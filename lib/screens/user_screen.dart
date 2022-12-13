import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:food_app/consts/firebase_consts.dart';
import 'package:food_app/screens/auth/forget_pass.dart';
import 'package:food_app/screens/auth/login_screen.dart';
import 'package:food_app/screens/loading_manager.dart';
import 'package:food_app/screens/orders/orders_screen.dart';
import 'package:food_app/screens/viewed_recently/viewed_recently_screen.dart';
import 'package:food_app/screens/wishlist/wishlist_screen.dart';
import 'package:food_app/services/global_methods.dart';
import 'package:food_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../provider/dark_theme_provider.dart';

class UserScreen extends StatefulWidget {
  UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressTextController = TextEditingController();
  final User? user = authInstance.currentUser;
  bool _isLoading = false;
  String? _email;
  String? _name;
  String? _address;
  @override
  void dispose() {
    _addressTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      String uid = user!.uid;
      final DocumentSnapshot user_doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (user_doc == null) {
        return;
      } else {
        _email = user_doc.get('email');
        _name = user_doc.get('name');
        _address = user_doc.get('shipping-address');
        _addressTextController.text = _address.toString();
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      GlobalMethods.errorDialog(subTitle: "$error", context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  RichText(
                    text: TextSpan(
                      text: "Hi,  ",
                      style: const TextStyle(color: Colors.cyan, fontSize: 27, fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: _name == null ? "user" : "$_name",
                          style: TextStyle(color: color, fontSize: 25, fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  TextWidget(text: _email == null ? "Email" : "$_email", color: color, textSize: 17),
                  const SizedBox(height: 20),
                  const Divider(thickness: 2),
                  const SizedBox(height: 20),
                  _listTile(
                      title: "Address",
                      subtitle: " $_address",
                      icon: IconlyLight.profile,
                      onPressed: () async {
                        await _showAddressDialog();
                      },
                      color: color),
                  _listTile(
                      title: "Orders",
                      icon: IconlyLight.bag,
                      onPressed: () {
                        GlobalMethods.navigateTo(context: context, routeName: OrdersScreen.routeName);
                      },
                      color: color),
                  _listTile(
                      title: "Wishlist",
                      icon: IconlyLight.heart,
                      onPressed: () {
                        GlobalMethods.navigateTo(context: context, routeName: WishlistScreen.routeName);
                      },
                      color: color),
                  _listTile(
                      title: "Viewed",
                      icon: IconlyLight.show,
                      onPressed: () {
                        GlobalMethods.navigateTo(context: context, routeName: ViewedRecentlyScreen.routeName);
                      },
                      color: color),
                  _listTile(
                      title: "Forgot Password",
                      icon: IconlyLight.unlock,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()),
                        );
                      },
                      color: color),
                  SwitchListTile(
                    title: Text(themeState.getDarkTheme ? "Dark mode" : "Light mode"),
                    secondary: Icon(themeState.getDarkTheme ? Icons.dark_mode_outlined : Icons.light_mode_outlined),
                    onChanged: (bool value) {
                      themeState.setDarkTheme = value;
                    },
                    value: themeState.getDarkTheme,
                  ),
                  _listTile(
                      title: user == null ? 'Login' : "Logout",
                      icon: user == null ? IconlyLight.login : IconlyLight.logout,
                      onPressed: () async {
                        if (user == null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                          return;
                        }
                        GlobalMethods.warningDialog(
                          title: "Sign Out",
                          subTitle: "Do you wanna sign out?",
                          func: () async {
                            await authInstance.signOut();
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                          context: context,
                        );
                      },
                      color: color),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddressDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update"),
            content: TextField(
              onChanged: (value) {
                // _addressTextController.text;
              },
              controller: _addressTextController,
              maxLines: 5,
              decoration: const InputDecoration(hintText: "Your Address"),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    String uid = user!.uid;
                    try {
                      await FirebaseFirestore.instance.collection('users').doc(uid).update({
                        'shipping-address': _addressTextController.text.toString(),
                      });
                      Navigator.of(context).pop();
                      setState(() {
                        _address = _addressTextController.text.toString();
                      });
                    } catch (error) {
                      GlobalMethods.errorDialog(subTitle: "$error", context: context);
                    }
                  },
                  child: const Text("Update")),
            ],
          );
        });
  }
}

Widget _listTile({
  required String title,
  String? subtitle,
  required IconData icon,
  required Function onPressed,
  required Color color,
}) {
  return ListTile(
    title: Text(
      title,
      style: TextStyle(color: color, fontWeight: FontWeight.w400, fontSize: 16),
    ),
    subtitle: Text(subtitle ?? "", style: TextStyle(color: color, fontSize: 14)),
    leading: Icon(icon),
    trailing: const Icon(IconlyLight.arrowRight2),
    onTap: () {
      onPressed();
    },
  );
}
