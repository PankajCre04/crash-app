import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/consts/firebase_consts.dart';
import 'package:food_app/screens/bottom_bar_screen.dart';
import 'package:food_app/services/global_methods.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({Key? key}) : super(key: key);

  Future<void> _googleSignIn(BuildContext context) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          await authInstance.signInWithCredential(
            GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (cnontext) => const BottomBarScreen()),
          );
        } on FirebaseException catch (error) {
          GlobalMethods.errorDialog(subTitle: "${error.message}", context: context);
        } catch (error) {
          GlobalMethods.errorDialog(subTitle: "${error}", context: context);
        } finally {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      child: InkWell(
        onTap: () {
          _googleSignIn(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: Image.asset(
                "assets/images/google.png",
                width: 40.0,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "Sign in with google",
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}
