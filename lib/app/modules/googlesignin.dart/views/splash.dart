import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../homepage.dart/views/home.dart';
import '../controllers/googlesignin_dart_controller.dart';


class Splash extends StatelessWidget {

  final AuthController authController = Get.find();

   Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Ink.image(
            image: const AssetImage('assets/images/img.png'),
            fit: BoxFit.cover,
          ),
           Positioned(
            left: 0,
            right: 0,
            bottom: 200,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 100),
              child: Obx(() {
                final user = authController.user.value;

                return ElevatedButton(
                  onPressed: () async {
                    await authController.signInWithGoogle();

                    // Check if user is signed in after successful sign-in
                    if (authController.user.value != null) {


                      // Navigate to the next screen
                      Get.to(() => Home());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/google.png',
                        height: 26,
                        width: 26,
                      ),
                      const SizedBox(width: 8),
                      const Text('Sign In with Google',style: TextStyle(color: Colors.black),),
                    ],
                  ),
                );
              }),
            ),
          ),

        ],
      ),
    );
  }
}