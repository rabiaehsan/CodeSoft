import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/googlesignin_dart_controller.dart';


class GoogleSigninDartView extends StatelessWidget {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

           ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
                  () {
                if (authController.user.value == null) {
                  return Text('Not signed in');
                } else {
                  return Column(
                    children: [
                      Text('Signed in as ${authController.user.value!.displayName}'),
                      ElevatedButton(
                        onPressed: () => authController.signOut(),
                        child: const  Text('Sign Out'),
                      ),
                    ],
                  );
                }
              },
            ),
            ElevatedButton(
              onPressed: () async {
                await authController.signInWithGoogle();
              },
              child: Text('Sign In with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
