import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_appwrite.dart';
import '../../../controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final TextEditingController emailControl = TextEditingController();
  final TextEditingController passControl = TextEditingController();
  final authControl = Get.find<AuthController>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoginView'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Center(
            child: Column(
          children: [
            TextField(
              controller: emailControl,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              obscureText: true,
              controller: passControl,
              decoration: const InputDecoration(labelText: "Password",),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await loginUser(
                        emailControl.text, passControl.text)
                      .then((value) {
                    if (value == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Login Success")));
                      Get.offAllNamed(Routes.HOME);
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(value)));
                    }
                  });
                  await authControl.login(emailControl.text, passControl.text);
                } catch (error) {
                  print("Error during registration: $error");
                }
              },
              child: const Text("Login"),
            ),
            Row(
              children: [
                const Text("Don't have any Account?"),
                TextButton(
                    onPressed: () => Get.toNamed(Routes.SIGNUP),
                    child: const Text("Sign Up"))
              ],
            )
          ],
        )),
      ),
    );
  }
}
