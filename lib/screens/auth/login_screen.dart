import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_app/consts/const_data.dart';
import 'package:food_app/fetch_screen.dart';
import 'package:food_app/screens/auth/register.dart';
import 'package:food_app/screens/bottom_bar_screen.dart';
import 'package:food_app/screens/home_screen.dart';
import 'package:food_app/screens/loading_manager.dart';
import 'package:food_app/services/global_methods.dart';
import 'package:food_app/services/utils.dart';
import 'package:food_app/widgets/auth_button.dart';
import 'package:food_app/widgets/google_button.dart';
import 'package:food_app/widgets/text_widget.dart';

import '../../consts/firebase_consts.dart';
import 'forget_pass.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/loginScreen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _isLoading = false;
  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  void _submitFormOnLogin() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });
    if (isValid) {
      _formKey.currentState!.save();
      try {
        await authInstance.signInWithEmailAndPassword(
          email: _emailTextController.text.toLowerCase().trim(),
          password: _passTextController.text.trim(),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) {
            return const FetchScreen();
          }),
        );
      } on FirebaseAuthException catch (error) {
        GlobalMethods.errorDialog(subTitle: "${error.message}", context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(subTitle: "${error}", context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = Utils(context: context).getScreenSize;
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Stack(
          children: [
            Swiper(
              duration: 800,
              autoplayDelay: 6000,
              itemBuilder: (context, index) {
                return Image.asset(
                  ConstData.authImagesPaths[index],
                  fit: BoxFit.cover,
                );
              },
              autoplay: true,
              itemCount: ConstData.authImagesPaths.length,
            ),
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * 0.2,
                    ),
                    TextWidget(text: "Welcome Back", color: Colors.white, textSize: 27, isTitle: true),
                    const SizedBox(height: 8),
                    TextWidget(text: "Sign in to continue", color: Colors.white, textSize: 16, isTitle: false),
                    const SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context).requestFocus(_passFocusNode),
                            controller: _emailTextController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty || !value.contains("@")) {
                                return 'please enter a valid email address';
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              _submitFormOnLogin();
                            },
                            controller: _passTextController,
                            obscureText: _obscureText,
                            keyboardType: TextInputType.visiblePassword,
                            focusNode: _passFocusNode,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 6) {
                                return 'please enter a valid password';
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(
                                  _obscureText ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                              ),
                              hintText: 'Password',
                              hintStyle: const TextStyle(color: Colors.white),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          GlobalMethods.navigateTo(context: context, routeName: ForgetPasswordScreen.routeName);
                        },
                        child: const Text(
                          'Forget password?',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.lightBlue,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AuthButton(
                        func: () {
                          _submitFormOnLogin();
                        },
                        buttonText: "Login"),
                    const SizedBox(height: 10),
                    const GoogleButton(),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            thickness: 2,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 5),
                        TextWidget(text: "OR", color: Colors.white, textSize: 16),
                        const SizedBox(width: 5),
                        const Expanded(
                          child: Divider(
                            thickness: 2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    AuthButton(
                      func: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const FetchScreen()),
                        );
                      },
                      buttonText: "Continue as a guest",
                      primary: Colors.black,
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        text: "Dont't have an account?",
                        style: const TextStyle(color: Colors.white, fontSize: 17),
                        children: [
                          TextSpan(
                            text: "  Sign Up",
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                GlobalMethods.navigateTo(context: context, routeName: RegisterScreen.routeName);
                              },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
